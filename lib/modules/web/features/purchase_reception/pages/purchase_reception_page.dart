import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/event_config_panel.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_state.dart';
import 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_page_data_source_web.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/purchase_info_display.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/receive_cattle_form.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/lots_table.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/cattle_list_with_events.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/unassigned_cattle_list.dart';

class PurchaseReceptionPage extends StatefulWidget {
  final String purchaseId;
  const PurchaseReceptionPage({super.key, required this.purchaseId});

  @override
  State<PurchaseReceptionPage> createState() => _PurchaseReceptionPageState();
}

class _PurchaseReceptionPageState extends State<PurchaseReceptionPage> {
  String? idMassiveEvent;
  List<SimpleEventModel> simpleEvents = [];
  String? _globalErrorMessage;
  String? _globalSuccessMessage;
  String? _globalInfoMessage;
  late final ReceptionApiService api;
  Map<String, dynamic>? receptionData;
  String? selectedLotId;
  DateTime? receptionDate;
  String? initialCattleNumber;
  String currentCattleNumber = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    api = ReceptionApiService();
    _load();
  }

  void setidMassiveEvent(String id) {
    setState(() {
      idMassiveEvent = id;
    });
  }

  void setEvents(List<SimpleEventModel> events) {
    setState(() {
      simpleEvents = events;
    });
  }

  void setGlobalInfo(String? msg) {
    setState(() {
      _globalInfoMessage = msg;
      _globalSuccessMessage = null;
      _globalErrorMessage = null;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _globalInfoMessage = null;
        });
      }
    });
  }

  void setGlobalError(String? msg) {
    setState(() {
      _globalErrorMessage = msg;
      _globalSuccessMessage = null;
      _globalInfoMessage = null;
    });
  }

  void setGlobalSuccess(String? msg) {
    setState(() {
      _globalSuccessMessage = msg;
      _globalErrorMessage = null;
      _globalInfoMessage = null;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _globalSuccessMessage = null;
        });
      }
    });
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    try {
      final data = await api.getPurchaseReception(widget.purchaseId);
      setState(() {
        receptionData = data;
        // Initialize massive event data
        final massEvent = data['reception']['massiveEvent'];
        if (massEvent != null) {
          idMassiveEvent = massEvent['id'];
          final simpleEventsList = massEvent['simpleEvents'] as List<dynamic>?;
          if (simpleEventsList != null) {
            simpleEvents = simpleEventsList
                .map((e) => SimpleEventModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
        // Load reception date if it exists
        final receivedAtStr = data['reception']['receivedAt'] as String?;
        if (receivedAtStr != null) {
          receptionDate = DateTime.parse(receivedAtStr);
        }
        // Set default selected lot (first lot if available)
        final lots = _getLots();
        // Set default selected lot (first lot if available), but preserve selection if valid
        if (selectedLotId != null && !lots.any((l) => l['id'] == selectedLotId)) {
          selectedLotId = null;
        }
        if (selectedLotId == null && lots.isNotEmpty) {
          selectedLotId = lots[0]['id'];
        }
        currentCattleNumber = data['reception']['nextCattleNumber'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _globalErrorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _receiveCattle(Map<String, dynamic> cattleData) async {
    final l10n = AppLocalizations.of(context)!;
    // Let errors bubble up to form
      await api.receiveOne(
        receptionId: receptionData!['reception']['id'],
        idPurchase: receptionData!['reception']['purchaseId'],
        number: cattleData['number'],
        receivedWeight: cattleData['receivedWeight'],
        purchaseWeight: cattleData['purchaseWeight'],
        purchasePrice: cattleData['purchasePrice'],
        idLot: cattleData['idLot'],
        hasHorn: cattleData['hasHorns'],
        castrated: cattleData['isCastrated'],
        color: cattleData['color'],
        characteristics: cattleData['characteristics'],
        eartag: cattleData['eartag'],
        idDevice: cattleData['idDevice'],
        idProvider: receptionData!['reception']['providerId'],
        comments: cattleData['comments'],
        gender:cattleData['gender'],
        age:cattleData['age'],
        idSimpleEvents: cattleData['idSimpleEvents'],
      );
      await _load();
      setGlobalSuccess(l10n.receivedOk);
  }

  Future<void> _assignLot(String cattleId, String lotId) async {
    try {
      await api.reassignLot(
        purchaseId: widget.purchaseId,
        animalId: cattleId,
        lotId: lotId,
      );
      await _load();
      setGlobalSuccess('Lot assigned successfully');
    } catch (e) {
      setGlobalError(e.toString());
    }
  }

  Future<void> _confirmClosePurchase(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.purchaseStatusReceived), // "Received" or "Close Purchase"
        content: const Text('¿Estás seguro de marcar esta compra como recibida?'), // Localize if possible, hardcoded for now as user requested feature "cerrar compra"
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.accept),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _closePurchase();
    }
  }

  Future<void> _closePurchase() async {
    try {
      await api.updateStatus(widget.purchaseId, 'RECEIVED');
      setGlobalSuccess('Compra marcada como recibida');
      // Update local state if needed (e.g. disable form)
      // For now just show success
      // Automatically navigate back or refresh?
      // Navigator.of(context).pop(); // Maybe?
      
      // Refresh to update status variable if we were tracking it (we aren't tracking status in this page explicitly yet)
      _load();
    } catch (e) {
      setGlobalError(e.toString());
    }
  }

  List<Map<String, dynamic>> _getLots() {
    if (receptionData == null) return [];
    return (receptionData!['reception']['lots'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> _getUnassignedCattle() {
    if (receptionData == null) return [];
    return (receptionData!['reception']['cattle'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> _getCattleForLot(String? lotId) {
    if (lotId == null || receptionData == null) return [];
    final lots = _getLots();
    final lot = lots.firstWhere(
      (l) => l['id'] == lotId,
      orElse: () => {},
    );
    if (lot.isEmpty) return [];
    return (lot['cattle'] as List<dynamic>).cast<Map<String, dynamic>>();
  }

  List<String> _getColors() {
    if (receptionData == null) return [];
    return (receptionData!['colors'] as List?)?.map((e) => e.toString()).toList() ?? [];
  }

  List<String> _getCharacteristics() {
    if (receptionData == null) return [];
    return (receptionData!['characteristics'] as List?)?.map((e) => e.toString()).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (isLoading) {
      return FincaScaffold(
        title: l10n.purchaseReceptionTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (receptionData == null) {
      return FincaScaffold(
        title: l10n.purchaseReceptionTitle,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_globalErrorMessage ?? 'Error loading reception data'),
            ],
          ),
        ),
      );
    }
    final reception = receptionData!['reception'];
    final lots = _getLots();
    final unassignedCattle = _getUnassignedCattle();
    final selectedCattle = _getCattleForLot(selectedLotId);
    return BlocProvider(
      create: (context) => MassiveEventBloc(
        dataSource: MassiveEventPageDataSourceWeb(),
      ),
      child: BlocListener<MassiveEventBloc, MassiveEventState>(
        listener: (context, state) {
          if (state is MassiveEventSuccess) {
            String msg =
                state.messageKey == 'simpleEventAdded'
                    ? l10n.simpleEventAdded
                    : state.messageKey;
            setGlobalSuccess(msg);
          }
          if (state is MassiveEventError) {
            String msg =
                state.messageKey == 'simpleEventError'
                    ? l10n.simpleEventError
                    : state.messageKey;
            setGlobalError(msg);
          }
        },
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            // Return current reception stats 
            Navigator.of(context).pop(receptionData?['reception']);
          },
          child: FincaScaffold(
            title: l10n.purchaseReceptionTitle,
            body: CustomScrollView(
            slivers: [
              // Top Section (Scrollable)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Global messages
                    if (_globalErrorMessage != null)
                      MessageBanner.error(_globalErrorMessage!),
                    if (_globalSuccessMessage != null)
                      MessageBanner.success(_globalSuccessMessage!),
                    if (_globalInfoMessage != null)
                      MessageBanner.info(_globalInfoMessage!),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _confirmClosePurchase(context),
                            icon: const Icon(Icons.check_circle),
                            label: Text(l10n.purchaseStatusReceived), // Or "Cerrar Compra" if localized
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

              // Top Section: Purchase Info + Form + Event Config Panel
                    SizedBox(
                  height: 450,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              PurchaseInfoDisplay(
                                providerName: reception['purchaseProviderName'] ?? '—',
                                purchaseDate: reception['purchaseDate']?.substring(0, 10) ?? '—',
                                receptionDate: receptionDate,
                                initialCattleNumber: currentCattleNumber.isEmpty ? null : currentCattleNumber,
                                onReceptionDateChanged: (date) {
                                  setState(() => receptionDate = date);
                                },
                                onInitialNumberChanged: (number) {
                                  setState(() => currentCattleNumber = number);
                                },
                                onError: (errorMsg) {
                                  setGlobalError(errorMsg);
                                },
                              ),
                              const SizedBox(height: 5),
                              ReceiveCattleForm(
                                currentNumber: currentCattleNumber,
                                availableLots: lots,
                                colors: _getColors(),
                                characteristics: _getCharacteristics(),
                                activeEvents: simpleEvents.where((e) => e.isActive).toList(),
                                onSubmit: _receiveCattle,
                                onNumberChanged: (number) {
                                  setState(() => currentCattleNumber = number);
                                },
                                onError: setGlobalError,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 1,
                        child: EventConfigPanel(
                          key: const ValueKey('eventConfigPanel_reception'),
                          isWide: true,
                          eventDate: receptionDate ?? DateTime.now(),
                          simpleEvents: simpleEvents,
                          idMassiveEvent: idMassiveEvent,
                          onMassiveEventCreated: (newId) {
                            setidMassiveEvent(newId);
                          },
                          showError: setGlobalError,
                          showSuccess: setGlobalSuccess,
                          showInfo: setGlobalInfo,
                          onEventsChanged: setEvents,
                        ),
                      ),
                    ],
                  ),
                    ),
                  ],
                ),
              ),
              // Bottom Section (Fills remaining space)
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  children: [
                    const Divider(height: 1),
                    Flexible(
                      flex: unassignedCattle.isNotEmpty ? 6 : 1,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: LotsTable(
                              lots: lots,
                              selectedLotId: selectedLotId,
                              onLotSelected: (lotId) {
                                setState(() => selectedLotId = lotId);
                              },
                            ),
                          ),
                          const VerticalDivider(width: 1),
                          Expanded(
                            child: CattleListWithEvents(
                              cattle: selectedCattle,
                              availableLots: lots,
                              onAssignLot: _assignLot,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (unassignedCattle.isNotEmpty) ...[
                      const Divider(height: 1),
                      // 👇 En vez de Expanded: Flexible + scroll interno
                      Flexible(
                        flex: 4,
                        child: UnassignedCattleList(
                          cattle: unassignedCattle,
                          availableLots: lots,
                          onAssignLot: _assignLot,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
