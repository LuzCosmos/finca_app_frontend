import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/widgets/provider_input.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/widgets/lots_section.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/provider.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/lot.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/services/purchases_api_service.dart';
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
            "purchasedCattleCount": lot.purchasedCattleCount,
            "totalWeight": lot.totalWeight,
            "pricePerKg": lot.pricePerKg,
            "totalValue": lot.totalValue,
            "gender": lot.gender.name,
          };
        }).toList();
    try {
      setState(() {
        _globalErrorMessage = null;
        _globalSuccessMessage = null;
      });
      final service = PurchasesApiService();
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
          context.push('/purchases');
        }
      });
    } on ApiException catch (e) {
      String errorMessage;
      final ApiExceptionCode codeEnum = ApiExceptionCode.fromString(e.code);
      switch (codeEnum) {
        case ApiExceptionCode.serverConnectionError ||
            ApiExceptionCode.serverError:
          errorMessage = l10n.error_server;
          break;
        default:
          errorMessage = l10n.purchase_saveError;
      }
      setState(() {
        _globalErrorMessage = errorMessage;
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
                  label: Text(l10n.save),
                ),
              ),

              const SizedBox(height: 5),

              /// Purchase Date
              Row(
                children: [
                  Text('${l10n.dateSomething(l10n.purchase)}: '),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    onPressed: _selectDate,
                  ),
                ],
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
