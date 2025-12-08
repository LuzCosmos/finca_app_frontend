import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/sales/bloc/sales_web_bloc.dart';
import 'package:finca_app_frontend/modules/web/data/sales/sales_data_source_web_interface.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_detail_model.dart';
import 'package:finca_app_frontend/modules/web/features/sales/widgets/provider_autocomplete_field.dart';
import 'package:finca_app_frontend/modules/web/features/sales/widgets/weight_approval_dialog.dart';
import 'package:finca_app_frontend/modules/web/features/sales/services/cattle_validation_service.dart';
import 'package:uuid/uuid.dart';

class CreateSalePage extends StatelessWidget {
 const CreateSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesWebBloc(
        dataSource: createSalesDataSource(),
      )..add(const LoadProvidersEvent()),
      child: const _CreateSaleView(),
    );
  }
}

class _CreateSaleView extends StatefulWidget {
  const _CreateSaleView();

  @override
  State<_CreateSaleView> createState() => _CreateSaleViewState();
}

class _CreateSaleViewState extends State<_CreateSaleView> {
  final _formKey = GlobalKey<FormState>();
  final _minWeightController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Cattle input fields
  final _cattleIdController = TextEditingController();
  final _cattleWeightController = TextEditingController();
  
  DateTime _transactionDate = DateTime.now();
  String? _selectedBuyerId;
  String? _selectedBuyerName; // Added for provider name
  String? _selectedTransporterId;
  String? _selectedTransporterName; // Added for provider name
  
  // Separate lists for approved and rejected cattle
  final List<SaleDetailModel> _approvedCattle = [];
  final List<SaleDetailModel> _rejectedCattle = [];
  
  bool _isValidatingCattle = false;

  @override
  void dispose() {
    _minWeightController.dispose();
    _pricePerKgController.dispose();
    _notesController.dispose();
    _cattleIdController.dispose();
    _cattleWeightController.dispose();
    super.dispose();
  }

  double get _minWeight => double.tryParse(_minWeightController.text) ?? 0;
  double get _pricePerKg => double.tryParse(_pricePerKgController.text) ?? 0;
  
  double _calculateCattlePrice(double weight) {
    final effectiveWeight = weight >= _minWeight ? weight : _minWeight;
    return effectiveWeight * _pricePerKg;
  }
  
  // Calculate totals from APPROVED cattle only
  int get _totalCount => _approvedCattle.length;
  double get _totalWeight => _approvedCattle.fold(0, (sum, item) => sum + item.measuredWeight);
  double get _totalAmount => _approvedCattle.fold(0, (sum, item) => sum + item.calculatedPrice);

  Future<void> _addCattle() async {
    final l10n = AppLocalizations.of(context);
    final cattleNumber = _cattleIdController.text.trim();
    final weightText = _cattleWeightController.text.trim();

    // Validate inputs
    if (cattleNumber.isEmpty || weightText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter cattle number and weight')),
      );
      return;
    }

    final weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }

    setState(() => _isValidatingCattle = true);

    try {
      // 1. Validate cattle by number (checks ACTIVE status)
      final cattleData = await CattleValidationService.validateCattleByNumber(cattleNumber);
      final cattleId = cattleData['id'];

      // 2. Compare weight vs minWeight
      final minWeight = _minWeight;
      bool isApproved = true;
      String? rejectionReason;

      if (weight < minWeight && minWeight > 0) {
        // Show approval dialog
        final approved = await showDialog<bool>(
          context: context,
          builder: (context) => WeightApprovalDialog(
            cattleNumber: cattleNumber,
            measuredWeight: weight,
            minWeight: minWeight,
          ),
        );

        if (approved == null) {
          // User dismissed dialog
          setState(() => _isValidatingCattle = false);
          return;
        }

        isApproved = approved;
        if (!approved) {
          rejectionReason = l10n?.cattle_rejectionReason ?? 'Underweight';
        }
      }

      // 3. Record weight in history
      await CattleValidationService.recordWeightHistory(
        cattleId: cattleId,
        weight: weight,
        measuredDate: DateTime.now(),
        context: 'SALE',
      );

      // 4. Update cattle current weight
      await CattleValidationService.updateCattleWeight(
        cattleId: cattleId,
        weight: weight,
      );

      // 5. Create sale detail
      final cattleDetail = SaleDetailModel(
        id: const Uuid().v4(),
        saleId: '',
        cattleId: cattleId,
        measuredWeight: weight,
        calculatedPrice: _calculateCattlePrice(weight),
        isApproved: isApproved,
        rejectionReason: rejectionReason,
        trackerRemoved: false,
      );

      // 6. Add to appropriate list
      setState(() {
        if (isApproved) {
          _approvedCattle.add(cattleDetail);
        } else {
          _rejectedCattle.add(cattleDetail);
        }
        _cattleIdController.clear();
        _cattleWeightController.clear();
        _isValidatingCattle = false;
      });

    } catch (e) {
      setState(() => _isValidatingCattle = false);
      
      // Show validation error dialog
      await showDialog(
        context: context,
        builder: (context) => CattleValidationErrorDialog(
          cattleNumber: cattleNumber,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  void _removeApprovedCattle(int index) {
    setState(() => _approvedCattle.removeAt(index));
  }

  void _removeRejectedCattle(int index) {
    setState(() => _rejectedCattle.removeAt(index));
  }

  // Helper method to build cattle list sections
  Widget _buildCattleListSection(
    BuildContext context, {
    required String title,
    required int count,
    required List<SaleDetailModel> cattle,
    required bool isEmpty,
    required String emptyMessage,
    required Color color,
    required Function(int) onRemove,
    bool showRejectionReason = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Row(
              children: [
                Icon(
                  showRejectionReason ? Icons.cancel : Icons.check_circle,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$title ($count)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cattle.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cattle[index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Cattle #${item.cattleId}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Text('${item.measuredWeight.toStringAsFixed(2)} kg'),
                      ),
                      if (showRejectionReason && item.rejectionReason != null)
                        Expanded(
                          child: Text(
                            item.rejectionReason!,
                            style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                          ),
                        )
                      else
                        Expanded(
                          child: Text('\$${item.calculatedPrice.toStringAsFixed(2)}'),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => onRemove(index),
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _submitSale() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check we have approved cattle
    if (_approvedCattle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one approved cattle')),
      );
      return;
    }

    try {
      // 1. Create sale with APPROVED cattle only
      final sale = SaleModel(
        id: const Uuid().v4(),
        idTenant: '', // Will be set by backend
        transactionDate: _transactionDate,
        buyerId: _selectedBuyerId!,
        transporterId: _selectedTransporterId,
        minWeightConfig: _minWeight,
        valuePerKgConfig: _pricePerKg,
        totalAmount: _totalAmount,
        totalWeight: _totalWeight,
        totalCount: _totalCount,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        isSynced: false,
        details: _approvedCattle,
      );

      // 2. Submit sale
      context.read<SalesWebBloc>().add(CreateSaleEvent(sale: sale));

      // 3. Update cattle status to SOLD
      final cattleIds = _approvedCattle.map((c) => c.cattleId).toList();
      await CattleValidationService.bulkUpdateCattleStatus(
        cattleIds: cattleIds,
        status: 'SOLD',
      );
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<SalesWebBloc, SalesWebState>(
      listener: (context, state) {
        if (state.status == SalesWebStatus.saleCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sale created successfully!')),
          );
          context.go('/sales');
        } else if (state.status == SalesWebStatus.failure && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      child: FincaScaffold(
        title: l10n?.home_sale ?? 'Create Sale',
        body: BlocBuilder<SalesWebBloc, SalesWebState>(
          builder: (context, state) {
            if (state.status == SalesWebStatus.loading && state.providers == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final buyers = state.providers?.where((p) => p['type'] == 'BUYER').toList() ?? [];
            final transporters = state.providers?.where((p) => p['type'] == 'TRANSPORTER').toList() ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => context.go('/sales'),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'New Sale',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Main Content - Responsive Layout
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 900) {
                              // Desktop: Two columns
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildSaleInfoSection(context, buyers, transporters),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 1,
                                    child: _buildCattleSection(context),
                                  ),
                                ],
                              );
                            } else {
                              // Mobile/Tablet: Stacked
                              return Column(
                                children: [
                                  _buildSaleInfoSection(context, buyers, transporters),
                                  const SizedBox(height: 24),
                                  _buildCattleSection(context),
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 32),

                        // Summary & Submit Section
                        _buildSummarySection(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSaleInfoSection(BuildContext context, List buyers, List transporters) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sale Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Transaction Date
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _transactionDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _transactionDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Transaction Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(DateFormat('MMM d, yyyy').format(_transactionDate)),
              ),
            ),
            const SizedBox(height: 16),

            // Buyer Autocomplete (replaces dropdown)
            ProviderAutocompleteField(
              label: 'Buyer *',
              providerType: 'BUYER',
              onChanged: (id, name) => setState(() {
                _selectedBuyerId = id;
                _selectedBuyerName = name;
              }),
              validator: (val) => _selectedBuyerId == null ? 'Buyer is required' : null,
            ),
            const SizedBox(height: 16),

            // Transporter Autocomplete (replaces dropdown)
            ProviderAutocompleteField(
              label: 'Transporter (Optional)',
              providerType: 'TRANSPORTER',
              onChanged: (id, name) => setState(() {
                _selectedTransporterId = id;
                _selectedTransporterName = name;
              }),
            ),
            const SizedBox(height: 24),

            Text(
              'Pricing Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Min Weight & Price Per Kg
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minWeightController,
                    decoration: const InputDecoration(
                      labelText: 'Min Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      final num = double.tryParse(val);
                      if (num == null || num < 0) return 'Invalid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _pricePerKgController,
                    decoration: const InputDecoration(
                      labelText: 'Price / Kg *',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      final num = double.tryParse(val);
                      if (num == null || num <= 0) return 'Invalid price';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCattleSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cattle Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Add Cattle Form
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cattleIdController,
                    decoration: const InputDecoration(
                      labelText: 'Cattle ID',
                      border: OutlineInputBorder(),
                      hintText: 'Enter or scan ID',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cattleWeightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _addCattle,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Approved Cattle Section
            _buildCattleListSection(
              context,
              title: l10n?.cattle_approved_title ?? 'Approved Cattle',
              count: _approvedCattle.length,
              cattle: _approvedCattle,
              isEmpty: _approvedCattle.isEmpty,
              emptyMessage: l10n?.cattle_noApproved ?? 'No approved cattle yet',
              color: Colors.green,
              onRemove: _removeApprovedCattle,
            ),
            
            const SizedBox(height: 16),

            // Rejected Cattle Section
            if (_rejectedCattle.isNotEmpty)
              _buildCattleListSection(
                context,
                title: l10n?.cattle_rejected_title ?? 'Rejected Cattle',
                count: _rejectedCattle.length,
                cattle: _rejectedCattle,
                isEmpty: false,
                emptyMessage: '',
                color: Colors.red,
                onRemove: _removeRejectedCattle,
                showRejectionReason: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, SalesWebState state) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(context, 'Total Cattle', _totalCount.toString(), Icons.pets),
                _buildSummaryItem(context, 'Total Weight', '${_totalWeight.toStringAsFixed(2)} kg', Icons.scale),
                _buildSummaryItem(context, 'Total Amount', '\$${_totalAmount.toStringAsFixed(2)}', Icons.attach_money),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => context.go('/sales'),
                  child: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: state.status == SalesWebStatus.loading ? null : _submitSale,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: state.status == SalesWebStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Sale'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
