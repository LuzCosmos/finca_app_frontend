import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../../../../shared/widgets/finca_scaffold.dart';
import '../widgets/provider_input.dart';
import '../widgets/lots_section.dart';
import '../models/provider.dart';
import '../models/lot.dart';
import '../../../../shared/widgets/message_banner.dart';
import '../services/purchase_service.dart';
import '../../../../../core/services/api_exception.dart';
import 'package:go_router/go_router.dart';

class PurchaseFormPage extends StatefulWidget {
  const PurchaseFormPage({super.key});

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  ProviderModel? _selectedProvider;
  DateTime _selectedDate = DateTime.now();
  List<LotModel> _lots = [];
  String? _globalErrorMessage;
  String? _globalSuccessMessage;
  final GlobalKey<LotsSectionState> _lotsSectionKey =
      GlobalKey<LotsSectionState>();

  void _selectDate() async {
    _globalErrorMessage = null;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onLotsChanged(List<LotModel> updatedLots) {
    _globalErrorMessage = null;
    setState(() {
      _lots = updatedLots;
    });
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvider == null) {
      _showError(l10n.cp_error_providerRequired);
      return;
    }
    if (_lots.isEmpty) {
      _showError(l10n.cp_error_noLots);
      return;
    }
    if (!_lotsSectionKey.currentState!.validateDuplicatedLotNumbers(context)) {
      _showError(l10n.lot_duplicateLotNumber);
      return;
    }

    final lotsJson =
        _lots.map((lot) {
          return {
            "lotNumber": lot.lotNumber,
            "originPlace": lot.origin,
            "cattleCount": lot.cattleCount,
            "totalWeight": lot.totalWeight,
            "pricePerKg": lot.pricePerKg,
            "totalValue": lot.totalValue,
            "age": lot.age,
            "sex": lot.gender,
          };
        }).toList();

    try {
      setState(() {
        _globalErrorMessage = null;
        _globalSuccessMessage = null;
      });

      final service = PurchaseService();
      await service.createPurchase(
        idProvider: _selectedProvider!.id,
        purchaseDate: _selectedDate,
        lots: lotsJson,
      );

      setState(() {
        _globalSuccessMessage = l10n.purchase_saveSuccess;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _globalSuccessMessage = null;
          });
          context.go('/home');
        }
      });
    } on ApiException catch (e) {
      setState(() {
        switch (e.code) {
          case 'invalidData':
            _globalErrorMessage = l10n.purchase_saveError;
            break;
          case 'forbidden':
            _globalErrorMessage = l10n.purchase_saveError;
            break;
          case 'serverError':
            _globalErrorMessage = l10n.error_server;
            break;
          default:
            _globalErrorMessage = l10n.purchase_saveError;
        }
      });
    } catch (e) {
      setState(() {
        _globalErrorMessage = l10n.purchase_saveError;
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _globalErrorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FincaScaffold(
      title: l10n.cattlePurchase,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_globalErrorMessage != null)
                MessageBanner.error(_globalErrorMessage!),
              if (_globalSuccessMessage != null)
                MessageBanner.success(_globalSuccessMessage!),

              /// Save Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _onSubmit,
                  icon: const Icon(Icons.save),
                  label: Text(l10n.purchase_create),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                l10n.provider,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              /// Provider
              ProviderInput(
                onProviderSelected: (providerData) {
                  setState(() {
                    _selectedProvider = providerData;
                    _globalErrorMessage = null;
                  });
                },
                onError: (msg) {
                  setState(() {
                    _globalSuccessMessage = null;
                    _globalErrorMessage = msg;
                  });
                },
                onSuccess: (msg) {
                  setState(() {
                    _globalErrorMessage = null;
                    _globalSuccessMessage = msg;
                  });
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() {
                        _globalSuccessMessage = null;
                      });
                    }
                  });
                },
              ),
              const SizedBox(height: 5),

              /// Purchase Date
              Row(
                children: [
                  Text('${l10n.purchase_date}: '),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    onPressed: _selectDate,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Lots
              LotsSection(key: _lotsSectionKey, onLotsChanged: _onLotsChanged),
            ],
          ),
        ),
      ),
    );
  }
}
