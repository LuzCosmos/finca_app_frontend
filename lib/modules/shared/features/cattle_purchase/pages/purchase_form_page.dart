import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/widgets/business_partner_input.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/widgets/lots_section.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/lot.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/purchase_status.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/services/purchases_api_service.dart';
import 'package:finca_app_frontend/modules/shared/enums/cattle_enums.dart';
import 'package:go_router/go_router.dart';

class PurchaseFormPage extends StatefulWidget {
  final String? purchaseId;
  final String? initialBusinessPartnerName;

  const PurchaseFormPage({
    super.key,
    this.purchaseId,
    this.initialBusinessPartnerName,
  });

  bool get isEditMode => purchaseId != null;

  @override
  State<PurchaseFormPage> createState() => _PurchaseFormPageState();
}

class _PurchaseFormPageState extends State<PurchaseFormPage> {
  final _formKey = GlobalKey<FormState>();
  BusinessPartnerModel? _selectedBusinessPartner;
  DateTime _selectedDate = DateTime.now();
  List<LotModel> _lots = [];
  List<LotModel>? _initialLots;
  String? _initialBusinessPartnerId;
  String? _initialBusinessPartnerLabel;
  String? _globalErrorMessage;
  String? _globalSuccessMessage;
  bool _loadingPurchase = false;
  bool _didStartEditLoad = false;
  final GlobalKey<LotsSectionState> _lotsSectionKey =
      GlobalKey<LotsSectionState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditMode && !_didStartEditLoad) {
      _didStartEditLoad = true;
      _loadPurchaseForEdit();
    }
  }

  static double _readApiDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0.0;
  }

  static int _readApiInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  static DateTime _readPurchaseDate(dynamic value) {
    final raw = '$value'.trim();
    if (raw.isEmpty) return DateTime.now();
    final dateOnly = raw.length >= 10 ? raw.substring(0, 10) : raw;
    return DateTime.parse(dateOnly);
  }

  Future<void> _loadPurchaseForEdit() async {
    if (!mounted) return;
    setState(() => _loadingPurchase = true);
    try {
      final data = await PurchasesApiService().getById(widget.purchaseId!);
      if (!mounted) return;

      final status = PurchaseStatus.fromString('${data['status'] ?? 'OPEN'}');
      final l10n = AppLocalizations.of(context)!;

      if (status == PurchaseStatus.received) {
        setState(() {
          _globalErrorMessage = l10n.purchase_editForbiddenReceived;
          _loadingPurchase = false;
        });
        return;
      }

      final lotsRaw = data['lots'];
      final lots =
          (lotsRaw is List ? lotsRaw : const <dynamic>[])
              .map((raw) {
                final lot = Map<String, dynamic>.from(raw as Map);
                final count = _readApiInt(lot['purchasedCattleCount']);
                final totalWeight = _readApiDouble(lot['totalWeight']);
                final avg = count > 0 ? totalWeight / count : 0.0;
                return LotModel(
                  id: lot['id']?.toString(),
                  lotNumber: '${lot['lotNumber'] ?? ''}',
                  origin: '${lot['originPlace'] ?? ''}',
                  purchasedCattleCount: count,
                  gender: CattleGender.fromString('${lot['gender'] ?? 'MALE'}'),
                  avgWeight: avg,
                  totalWeight: totalWeight,
                  pricePerKg: _readApiDouble(lot['pricePerKg']),
                  totalValue: _readApiDouble(lot['totalValue']),
                );
              })
              .toList();

      final businessPartnerId = data['idProvider']?.toString();
      setState(() {
        _selectedDate = _readPurchaseDate(data['purchaseDate']);
        _initialBusinessPartnerId = businessPartnerId;
        _initialBusinessPartnerLabel =
            widget.initialBusinessPartnerName ?? businessPartnerId;
        if (businessPartnerId != null && widget.initialBusinessPartnerName != null) {
          _selectedBusinessPartner = BusinessPartnerModel(
            id: businessPartnerId,
            name: widget.initialBusinessPartnerName!,
            nit: '',
            role: BusinessPartnerRole.PROVIDER,
          );
        }
        _initialLots = lots;
        _lots = lots;
        _loadingPurchase = false;
      });
    } on ApiException {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _globalErrorMessage = l10n.purchase_editLoadError;
        _loadingPurchase = false;
      });
    } catch (e, st) {
      debugPrint('PurchaseFormPage._loadPurchaseForEdit: $e\n$st');
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _globalErrorMessage = l10n.purchase_editLoadError;
        _loadingPurchase = false;
      });
    }
  }

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

  List<Map<String, dynamic>> _lotsPayload() {
    return _lots
        .map(
          (lot) => {
            'lotNumber': lot.lotNumber,
            'originPlace': lot.origin,
            'purchasedCattleCount': lot.purchasedCattleCount,
            'totalWeight': lot.totalWeight,
            'pricePerKg': lot.pricePerKg,
            'totalValue': lot.totalValue,
            'gender': lot.gender.name,
          },
        )
        .toList();
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBusinessPartner == null) {
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
    try {
      setState(() {
        _globalErrorMessage = null;
        _globalSuccessMessage = null;
      });
      final service = PurchasesApiService();
      final lotsJson = _lotsPayload();
      if (widget.isEditMode) {
        await service.updatePurchase(
          id: widget.purchaseId!,
          idProvider: _selectedBusinessPartner!.id,
          purchaseDate: _selectedDate,
          lots: lotsJson,
        );
        setState(() {
          _globalSuccessMessage = l10n.purchase_editSuccess;
        });
      } else {
        await service.createPurchase(
          idProvider: _selectedBusinessPartner!.id,
          purchaseDate: _selectedDate,
          lots: lotsJson,
        );
        setState(() {
          _globalSuccessMessage = l10n.purchase_saveSuccess;
        });
      }
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _globalSuccessMessage = null;
          });
          context.push('/purchases');
        }
      });
    } on ApiException catch (e) {
      final code = ApiExceptionCode.fromString(e.code);
      String errorMessage;
      if (e.message.contains('reception already started')) {
        errorMessage = l10n.purchase_editForbiddenReceptionStarted;
      } else if (e.message.contains('already received')) {
        errorMessage = l10n.purchase_editForbiddenReceived;
      } else {
        switch (code) {
          case ApiExceptionCode.serverConnectionError ||
              ApiExceptionCode.serverError:
            errorMessage = l10n.error_server;
            break;
          default:
            errorMessage =
                widget.isEditMode
                    ? l10n.purchase_editSaveError
                    : l10n.purchase_saveError;
        }
      }
      setState(() {
        _globalErrorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _globalErrorMessage =
            widget.isEditMode
                ? l10n.purchase_editSaveError
                : l10n.purchase_saveError;
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

    if (_loadingPurchase) {
      return FincaScaffold(
        title:
            widget.isEditMode ? l10n.purchase_editTitle : l10n.cattlePurchase,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FincaScaffold(
      title: widget.isEditMode ? l10n.purchase_editTitle : l10n.cattlePurchase,
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
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _globalErrorMessage != null && widget.isEditMode
                      ? null
                      : _onSubmit,
                  icon: const Icon(Icons.save),
                  label: Text(l10n.save),
                ),
              ),
              const SizedBox(height: 5),
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
              BusinessPartnerInput(
                initialBusinessPartnerId: _initialBusinessPartnerId,
                initialBusinessPartnerName: _initialBusinessPartnerLabel,
                onBusinessPartnerSelected: (businessPartnerData) {
                  setState(() {
                    _selectedBusinessPartner = businessPartnerData;
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
              LotsSection(
                key: _lotsSectionKey,
                initialLots: _initialLots,
                onLotsChanged: _onLotsChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
