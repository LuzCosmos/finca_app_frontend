import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_web_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/web/data/sales/sales_data_source_web_interface.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_detail_model.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/business_partner_autocomplete_field.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/utils/sale_min_weight_classification.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/min_weight_buyer_change_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/min_weight_reclassify_cattle_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/weight_approval_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/sale_confirmation_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/services/cattle_validation_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/shared/features/hardware/widgets/live_scale_reading_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:finca_app_frontend/core/services/sale_update_notifier.dart';

class CreateSalePage extends StatelessWidget {
  final String? saleId;
  final ISalesDataSource? dataSource;

  const CreateSalePage({super.key, this.saleId, this.dataSource});

  bool get isEditMode => saleId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SalesWebBloc(dataSource: dataSource ?? createSalesDataSource())
                ..add(const LoadBusinessPartnersEvent()),
      child: _CreateSaleView(saleId: saleId),
    );
  }
}

class _CreateSaleView extends StatefulWidget {
  final String? saleId;

  const _CreateSaleView({this.saleId});

  bool get isEditMode => saleId != null;

  @override
  State<_CreateSaleView> createState() => _CreateSaleViewState();
}

class _CreateSaleViewState extends State<_CreateSaleView> {
  final _formKey = GlobalKey<FormState>();
  final _minWeightController = TextEditingController();
  final _minWeightFocusNode = FocusNode();
  final _pricePerKgController = TextEditingController();
  final _notesController = TextEditingController();

  // Cattle input fields
  final _cattleIdController = TextEditingController();
  final _cattleWeightController = TextEditingController();

  DateTime _transactionDate = DateTime.now();
  String? _selectedBuyerId;
  String? _selectedTransporterId;

  // Separate lists for approved and rejected cattle
  final List<SaleDetailModel> _approvedCattle = [];
  final List<SaleDetailModel> _rejectedCattle = [];

  bool _isValidatingCattle = false;
  bool _trackerRemoved = false;
  bool _loadingSale = false;
  bool _didStartEditLoad = false;
  String? _loadError;
  String? _editingSaleId;
  String? _initialBuyerName;
  String? _initialTransporterName;
  final _cattleService = CattleMasterService();

  /// Min weight (kg) used when the current approved/rejected lists were classified.
  double? _minWeightUsedForClassification;

  /// Value in the min-weight field when it last gained focus (manual edits).
  double? _minWeightWhenFieldFocused;

  bool _isCommittingMinWeightField = false;

  @override
  void initState() {
    super.initState();
    _pricePerKgController.addListener(_onPriceChanged);
    _minWeightFocusNode.addListener(_onMinWeightFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditMode && !_didStartEditLoad) {
      _didStartEditLoad = true;
      _loadSaleForEdit();
    }
  }

  Future<void> _loadSaleForEdit() async {
    if (!mounted) return;
    setState(() {
      _loadingSale = true;
      _loadError = null;
    });
    try {
      final sale = await context.read<SalesWebBloc>().dataSource.getSaleById(
        widget.saleId!,
      );
      if (!mounted) return;
      _populateFromSale(sale);
      setState(() => _loadingSale = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingSale = false;
        _loadError = AppLocalizations.of(context)!.sale_editLoadError;
      });
    }
  }

  void _populateFromSale(SaleModel sale) {
    _editingSaleId = sale.id;
    _transactionDate = sale.transactionDate;
    _selectedBuyerId = sale.buyerId;
    _selectedTransporterId = sale.transporterId;
    _initialBuyerName = sale.buyerName;
    _initialTransporterName = sale.transporterName;
    _minWeightController.text = sale.minWeightConfig.toString();
    _pricePerKgController.text = sale.valuePerKgConfig.toString();
    _notesController.text = sale.notes ?? '';
    _approvedCattle.clear();
    _rejectedCattle.clear();
    for (final detail in sale.details) {
      if (detail.isApproved) {
        _approvedCattle.add(detail);
      } else {
        _rejectedCattle.add(detail);
      }
    }
    _minWeightUsedForClassification = sale.minWeightConfig;
  }

  void _onPriceChanged() {
    setState(() {
      for (int i = 0; i < _approvedCattle.length; i++) {
        final item = _approvedCattle[i];
        final newPrice = _calculateCattlePrice(item.measuredWeight);
        _approvedCattle[i] = SaleDetailModel(
          id: item.id,
          saleId: item.saleId,
          cattleId: item.cattleId,
          cattleNumber: item.cattleNumber,
          measuredWeight: item.measuredWeight,
          calculatedPrice: newPrice,
          isApproved: item.isApproved,
          rejectionReason: item.rejectionReason,
          trackerRemoved: item.trackerRemoved,
        );
      }
    });
  }

  void _onMinWeightFocusChanged() {
    if (_minWeightFocusNode.hasFocus) {
      _minWeightWhenFieldFocused = _minWeight;
      return;
    }
    _scheduleMinWeightFieldCommit();
  }

  void _scheduleMinWeightFieldCommit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_onMinWeightFieldCommitted());
    });
  }

  @override
  void dispose() {
    _minWeightFocusNode.removeListener(_onMinWeightFocusChanged);
    _minWeightController.dispose();
    _minWeightFocusNode.dispose();
    _pricePerKgController.dispose();
    _notesController.dispose();
    _cattleIdController.dispose();
    _cattleWeightController.dispose();
    super.dispose();
  }

  double get _minWeight => double.tryParse(_minWeightController.text.trim()) ?? 0;
  double get _pricePerKg => double.tryParse(_pricePerKgController.text) ?? 0;

  String _formatMinWeightForField(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  bool get _hasCattleInLists =>
      _approvedCattle.isNotEmpty || _rejectedCattle.isNotEmpty;

  void _ensureClassificationMinInitialized(double minWeightKg) {
    if (_minWeightUsedForClassification == null && minWeightKg > 0) {
      _minWeightUsedForClassification = minWeightKg;
    }
  }

  void _syncClassificationMinAfterCattleAdded() {
    final min = _minWeight;
    if (min > 0) {
      _ensureClassificationMinInitialized(min);
    }
  }

  Future<void> _promptReclassificationIfNeeded({
    required double previousMin,
    required double newMin,
  }) async {
    if (newMin <= 0) return;
    if ((newMin - previousMin).abs() < 0.001) {
      if (!_hasCattleInLists) {
        _minWeightUsedForClassification = newMin;
      }
      return;
    }

    if (!_hasCattleInLists) {
      _minWeightUsedForClassification = newMin;
      return;
    }

    final choice = await showMinWeightReclassifyCattleDialog(
      context: context,
      previousMinWeightKg: previousMin,
      newMinWeightKg: newMin,
      approvedCount: _approvedCattle.length,
      rejectedCount: _rejectedCattle.length,
    );

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    if (choice == MinWeightReclassifyChoice.reclassify) {
      setState(() {
        _reclassifyCattleForMinWeight(newMin, l10n.cattle_rejectionReason);
        _minWeightUsedForClassification = newMin;
      });
      return;
    }

    setState(() {
      _recalculateApprovedPricesWithoutReclassify();
    });
  }

  void _reclassifyCattleForMinWeight(double minNuevo, String rejectionReason) {
    final all = [..._approvedCattle, ..._rejectedCattle];
    final result = SaleMinWeightClassification.partition(
      all,
      minNuevo,
      _pricePerKg,
      rejectionReason,
    );
    _approvedCattle
      ..clear()
      ..addAll(result.approved);
    _rejectedCattle
      ..clear()
      ..addAll(result.rejected);
  }

  void _recalculateApprovedPricesWithoutReclassify() {
    for (int i = 0; i < _approvedCattle.length; i++) {
      final item = _approvedCattle[i];
      _approvedCattle[i] = SaleDetailModel(
        id: item.id,
        saleId: item.saleId,
        cattleId: item.cattleId,
        cattleNumber: item.cattleNumber,
        measuredWeight: item.measuredWeight,
        calculatedPrice: _calculateCattlePrice(item.measuredWeight),
        isApproved: item.isApproved,
        rejectionReason: item.rejectionReason,
        trackerRemoved: item.trackerRemoved,
      );
    }
  }

  Future<void> _applyMinWeightChangeFromField() async {
    final newMin = _minWeight;
    if (newMin <= 0) return;

    var previousMin = _minWeightUsedForClassification;
    if (previousMin == null && _hasCattleInLists) {
      final atFocus = _minWeightWhenFieldFocused;
      if (atFocus != null && atFocus > 0) {
        previousMin = atFocus;
      }
    }
    if (previousMin == null) {
      _minWeightUsedForClassification = newMin;
      return;
    }

    await _promptReclassificationIfNeeded(previousMin: previousMin, newMin: newMin);
  }

  Future<void> _onBuyerChanged(
    String? id,
    String? name, {
    double? buyerMinWeightKg,
  }) async {
    setState(() => _selectedBuyerId = id);

    if (id == null) {
      return;
    }

    final previousClassificationMin = _minWeightUsedForClassification ?? _minWeight;
    var fieldMinBefore = _minWeight;

    if (buyerMinWeightKg != null && buyerMinWeightKg > 0) {
      if (fieldMinBefore <= 0) {
        setState(() {
          _minWeightController.text = _formatMinWeightForField(buyerMinWeightKg);
        });
        fieldMinBefore = buyerMinWeightKg;
      } else if ((fieldMinBefore - buyerMinWeightKg).abs() >= 0.001) {
        final choice = await showMinWeightBuyerChangeDialog(
          context: context,
          buyerName: name ?? '',
          currentMinWeightKg: fieldMinBefore,
          buyerDefaultMinWeightKg: buyerMinWeightKg,
        );

        if (!mounted) return;

        if (choice == MinWeightBuyerChangeChoice.useBuyerDefault) {
          setState(() {
            _minWeightController.text = _formatMinWeightForField(buyerMinWeightKg);
          });
        }
      }
    }

    if (!mounted) return;

    final newMin = _minWeight;
    if (newMin > 0) {
      await _promptReclassificationIfNeeded(
        previousMin: previousClassificationMin,
        newMin: newMin,
      );
    }
  }

  Future<void> _onMinWeightFieldCommitted() async {
    if (_isCommittingMinWeightField) return;
    _isCommittingMinWeightField = true;
    try {
      await _applyMinWeightChangeFromField();
    } finally {
      _isCommittingMinWeightField = false;
    }
  }

  double _calculateCattlePrice(double weight) {
    final effectiveWeight = weight >= _minWeight ? weight : _minWeight;
    return effectiveWeight * _pricePerKg;
  }

  // Calculate totals from APPROVED cattle only
  int get _totalCount => _approvedCattle.length;
  double get _totalWeight =>
      _approvedCattle.fold(0, (sum, item) => sum + item.measuredWeight);
  double get _totalAmount =>
      _approvedCattle.fold(0, (sum, item) => sum + item.calculatedPrice);

  Future<void> _addCattle() async {
    final l10n = AppLocalizations.of(context)!;
    final cattleNumber = _cattleIdController.text.trim();
    final weightText = _cattleWeightController.text.trim();

    // Validate inputs
    if (cattleNumber.isEmpty || weightText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.error_enterCattleNumberWeight)),
      );
      return;
    }

    final weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.error_enterValidWeight)));
      return;
    }

    setState(() => _isValidatingCattle = true);

    try {
      // 1. Validate cattle by number (checks ACTIVE status)
      final cattleData = await CattleValidationService.validateCattleByNumber(
        cattleNumber,
      );
      final cattleId = cattleData['id'];

      // 2. Compare weight vs minWeight
      final minWeight = _minWeight;
      bool isApproved = true;
      String? rejectionReason;

      if (weight < minWeight && minWeight > 0) {
        if (!mounted) return;
        // Show approval dialog
        final approved = await showDialog<bool>(
          context: context,
          builder:
              (context) => WeightApprovalDialog(
                cattleNumber: cattleNumber,
                measuredWeight: weight,
                minWeight: minWeight,
              ),
        );

        if (!mounted) return;
        if (approved == null) {
          // User dismissed dialog
          setState(() => _isValidatingCattle = false);
          return;
        }

        isApproved = approved;
        if (!approved) {
          rejectionReason = l10n.cattle_rejectionReason;
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
        cattleNumber: cattleNumber,
        measuredWeight: weight,
        calculatedPrice: _calculateCattlePrice(weight),
        isApproved: isApproved,
        rejectionReason: rejectionReason,
        trackerRemoved: _trackerRemoved,
      );

      // 6. Add to appropriate list
      if (mounted) {
        setState(() {
          if (isApproved) {
            _approvedCattle.add(cattleDetail);
          } else {
            _rejectedCattle.add(cattleDetail);
          }
          _syncClassificationMinAfterCattleAdded();
          _cattleIdController.clear();
          _cattleWeightController.clear();
          _trackerRemoved = false;
          _isValidatingCattle = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isValidatingCattle = false);
        // Show validation error dialog
        await showDialog(
          context: context,
          builder:
              (context) => CattleValidationErrorDialog(
                cattleNumber: cattleNumber,
                errorMessage: e.toString().replaceAll('Exception: ', ''),
              ),
        );
      }
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cattle[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${l10n.cattle} #${item.cattleNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${item.measuredWeight.toStringAsFixed(2)} kg',
                        ),
                      ),
                      if (showRejectionReason && item.rejectionReason != null)
                        Expanded(
                          child: Text(
                            item.rejectionReason!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            '\$${item.calculatedPrice.toStringAsFixed(2)}',
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => onRemove(index),
                        color: Colors.red,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 18,
                        ),
                        visualDensity: VisualDensity.compact,
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
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check we have approved cattle
    if (_approvedCattle.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.error_addApprovedCattle)));
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => SaleConfirmationDialog(
            approvedCattle: _approvedCattle,
            totalAmount: _totalAmount,
            totalWeight: _totalWeight,
            isEditMode: widget.isEditMode,
          ),
    );

    // User cancelled or dismissed
    if (confirmed != true) {
      return;
    }

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                widget.isEditMode ? l10n.sale_editSaving : l10n.sale_creating,
              ),
            ],
          ),
          duration: const Duration(
            minutes: 1,
          ), // Long duration, will be manually dismissed
        ),
      );
    }

    try {
      final allDetails = [..._approvedCattle, ..._rejectedCattle];
      final sale = SaleModel(
        id: widget.isEditMode ? _editingSaleId! : const Uuid().v4(),
        idTenant: '',
        transactionDate: _transactionDate,
        buyerId: _selectedBuyerId!,
        transporterId: _selectedTransporterId,
        minWeightConfig: _minWeight,
        valuePerKgConfig: _pricePerKg,
        totalAmount: _totalAmount,
        totalWeight: _totalWeight,
        totalCount: _totalCount,
        notes:
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
        details: widget.isEditMode ? allDetails : _approvedCattle,
      );

      if (mounted) {
        if (widget.isEditMode) {
          context.read<SalesWebBloc>().add(UpdateSaleWeb(sale: sale));
        } else {
          context.read<SalesWebBloc>().add(CreateSaleEvent(sale: sale));
        }
      }
    } catch (e) {
      // Dismiss loading snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.isEditMode
                        ? l10n.sale_editSaveError
                        : l10n.sale_createError,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<SalesWebBloc, SalesWebState>(
      listener: (context, state) {
        if (state.status == SalesWebStatus.saleCreated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.saleSavedSuccess)));
          context.push('/sales');
        } else if (state.status == SalesWebStatus.saleUpdated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.sale_editSuccess)));
          SaleUpdateNotifier.instance.notifySaleUpdated(_editingSaleId ?? '');
          context.push('/sales');
        } else if (state.status == SalesWebStatus.failure &&
            state.error != null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.isEditMode
                    ? l10n.sale_editSaveError
                    : 'Error: ${state.error}',
              ),
            ),
          );
        }
      },
      child: FincaScaffold(
        title: widget.isEditMode ? l10n.sale_editTitle : l10n.sale,
        body: BlocBuilder<SalesWebBloc, SalesWebState>(
          builder: (context, state) {
            if (_loadError != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _loadError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (_loadingSale ||
                (state.status == SalesWebStatus.loading &&
                    state.businessPartners == null)) {
              return const Center(child: CircularProgressIndicator());
            }

            final buyers =
                state.businessPartners
                    ?.where((p) => p['type'] == BusinessPartnerRole.BUYER.name)
                    .toList() ??
                [];
            final transporters =
                state.businessPartners
                    ?.where((p) => p['type'] == BusinessPartnerRole.TRANSPORTER.name)
                    .toList() ??
                [];

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
                                    child: _buildSaleInfoSection(
                                      context,
                                      buyers,
                                      transporters,
                                    ),
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
                                  _buildSaleInfoSection(
                                    context,
                                    buyers,
                                    transporters,
                                  ),
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

  Widget _buildSaleInfoSection(
    BuildContext context,
    List buyers,
    List transporters,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.sale_info, style: Theme.of(context).textTheme.titleLarge),
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
                decoration: InputDecoration(
                  labelText: l10n.sales_transactionDate,
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                child: Text(DateFormat('MMM d, yyyy').format(_transactionDate)),
              ),
            ),
            const SizedBox(height: 16),

            // Buyer Autocomplete (replaces dropdown)
            BusinessPartnerAutocompleteField(
              label: l10n.label_buyer_required,
              businessPartnerRole: BusinessPartnerRole.BUYER.name,
              initialValue: _initialBuyerName,
              onChanged: _onBuyerChanged,
              validator:
                  (val) =>
                      _selectedBuyerId == null
                          ? (l10n.error_buyer_required)
                          : null,
            ),
            const SizedBox(height: 16),
            // Transporter Autocomplete (replaces dropdown)
            BusinessPartnerAutocompleteField(
              label: l10n.label_transporter_optional,
              businessPartnerRole: BusinessPartnerRole.TRANSPORTER.name,
              initialValue: _initialTransporterName,
              onChanged:
                  (id, name, {buyerMinWeightKg}) => setState(() {
                    _selectedTransporterId = id;
                  }),
            ),
            const SizedBox(height: 24),

            Text(
              l10n.pricing_config,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Min Weight & Price Per Kg
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minWeightController,
                    focusNode: _minWeightFocusNode,
                    decoration: InputDecoration(
                      labelText: l10n.minWeightKg,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                    onEditingComplete: _onMinWeightFieldCommitted,
                    onFieldSubmitted: (_) => _onMinWeightFieldCommitted(),
                    onTapOutside: (_) => _scheduleMinWeightFieldCommit(),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return l10n.fieldRequired;
                      }
                      final num = double.tryParse(val);
                      if (num == null || num < 0) {
                        return l10n.error_invalid_number;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _pricePerKgController,
                    decoration: InputDecoration(
                      labelText: l10n.pricePerKg,
                      border: const OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      final num = double.tryParse(val);
                      if (num == null || num <= 0) {
                        return l10n.error_invalid_price;
                      }
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
              decoration: InputDecoration(
                labelText: l10n.label_notes_optional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCattleSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.label_cattle_management,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            LiveScaleReadingPanel(
              onApplyStableWeight: (_, formatted) {
                _cattleWeightController.text = formatted;
                setState(() {});
              },
            ),
            const SizedBox(height: 12),

            // Add Cattle Form
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return RawAutocomplete<Map<String, dynamic>>(
                        textEditingController: _cattleIdController,
                        focusNode: FocusNode(),
                        optionsBuilder: (
                          TextEditingValue textEditingValue,
                        ) async {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Map<String, dynamic>>.empty();
                          }
                          try {
                            return await _cattleService.searchCattle(
                              textEditingValue.text,
                            );
                          } catch (e) {
                            return const Iterable<Map<String, dynamic>>.empty();
                          }
                        },
                        displayStringForOption: (option) => option['number'],
                        onSelected: (Map<String, dynamic> selection) {
                          // Controller is updated automatically by Autocomplete when using displayStringForOption
                          // No extra action needed for now, user will click Add
                        },
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: l10n.cattleNumber,
                              border: const OutlineInputBorder(),
                              hintText: l10n.hint_enterScanId,
                            ),
                            onFieldSubmitted: (String value) {
                              onFieldSubmitted();
                            },
                          );
                        },
                        optionsViewBuilder: (
                          BuildContext context,
                          AutocompleteOnSelected<Map<String, dynamic>>
                          onSelected,
                          Iterable<Map<String, dynamic>> options,
                        ) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    final Map<String, dynamic> option = options
                                        .elementAt(index);
                                    final device = option['device'];
                                    final deviceText =
                                        device != null
                                            ? (device['name'] ??
                                                device['deveui'] ??
                                                '')
                                            : '';
                                    final colorValue = option['color'];
                                    final colorText =
                                        colorValue != null
                                            ? CattleColor.fromString(
                                              colorValue.toString(),
                                            ).localizedName(context)
                                            : '';
                                    final eartagLeft =
                                        (option['eartagLeft'] ?? '')
                                            .toString()
                                            .trim();
                                    final eartagRight =
                                        (option['eartagRight'] ?? '')
                                            .toString()
                                            .trim();
                                    final eartagLabel = [
                                      if (eartagLeft.isNotEmpty) eartagLeft,
                                      if (eartagRight.isNotEmpty) eartagRight,
                                    ].join(' / ');
                                    return ListTile(
                                      title: Text(
                                        '${option['number']?.toString() ?? ''}${eartagLabel.isNotEmpty ? ' / $eartagLabel' : ''}${deviceText.isNotEmpty ? ' / $deviceText' : ''}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      subtitle:
                                          colorText.isNotEmpty
                                              ? Text(
                                                '${l10n.color}: $colorText / ${l10n.castrated}: ${option['castrated'] == true ? l10n.yes : l10n.no} / ${l10n.hasHorns}: ${option['hasHorn'] == true ? l10n.yes : l10n.no}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              )
                                              : null,
                                      onTap: () {
                                        onSelected(option);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cattleWeightController,
                    decoration: InputDecoration(
                      labelText: l10n.weightKg,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed:
                      _minWeight > 0 && !_isValidatingCattle
                          ? _addCattle
                          : null,
                  icon:
                      _isValidatingCattle
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.add),
                  label: Text(
                    _isValidatingCattle ? (l10n.label_validating) : (l10n.add),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),

            // Tracker Removed Checkbox
            CheckboxListTile(
              title: Text(l10n.tracker_removed),
              value: _trackerRemoved,
              onChanged:
                  (val) => setState(() => _trackerRemoved = val ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            // Validation message for min weight
            if (_minWeight <= 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.warning_set_min_weight,
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                ),
              ),

            const SizedBox(height: 8),

            // Approved Cattle Section
            _buildCattleListSection(
              context,
              title: l10n.cattle_approved_title,
              count: _approvedCattle.length,
              cattle: _approvedCattle,
              isEmpty: _approvedCattle.isEmpty,
              emptyMessage: l10n.cattle_noApproved,
              color: Colors.green,
              onRemove: _removeApprovedCattle,
            ),

            const SizedBox(height: 12),
            // Rejected Cattle Section
            if (_rejectedCattle.isNotEmpty)
              _buildCattleListSection(
                context,
                title: l10n.cattle_rejected_title,
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
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.label_summary,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: cs.onPrimaryContainer),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  context,
                  l10n.label_totalCattle,
                  _totalCount.toString(),
                  FontAwesomeIcons.cow,
                  // si tu _buildSummaryItem acepta color:
                  // color: cs.onPrimaryContainer,
                ),
                _buildSummaryItem(
                  context,
                  l10n.totalWeightKg,
                  '${_totalWeight.toStringAsFixed(2)} kg',
                  Icons.scale,
                  // color: cs.onPrimaryContainer,
                ),
                _buildSummaryItem(
                  context,
                  l10n.sales_totalAmount,
                  '\$${_totalAmount.toStringAsFixed(2)}',
                  Icons.attach_money,
                  // color: cs.onPrimaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => context.push('/sales'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.onPrimaryContainer, // texto/ícono
                    side: BorderSide(color: cs.onPrimaryContainer), // borde
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      state.status == SalesWebStatus.loading ||
                              _loadError != null
                          ? null
                          : _submitSale,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child:
                      state.status == SalesWebStatus.loading
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                cs.onPrimary,
                              ),
                            ),
                          )
                          : Text(
                            widget.isEditMode
                                ? l10n.sale_saveChanges
                                : l10n.create,
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 25, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
