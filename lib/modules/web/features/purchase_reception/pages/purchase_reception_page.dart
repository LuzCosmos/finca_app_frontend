import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/services/reception_api_service.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/widgets/intake_form.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';

class PurchaseReceptionPage extends StatefulWidget {
  final String purchaseId;
  const PurchaseReceptionPage({super.key, required this.purchaseId});

  @override
  State<PurchaseReceptionPage> createState() => _PurchaseReceptionPageState();
}

class _PurchaseReceptionPageState extends State<PurchaseReceptionPage> {
  late final ReceptionApiService api;
  Map<String, dynamic>? ov; // overview
  String? selectedLotId; // null => Sin lote
  String? selectedAnimalId;
  String? errorMsg;
  String? okMsg;

  @override
  void initState() {
    super.initState();
    api = ReceptionApiService(
      defaultHeaders: {
        'Authorization': 'Bearer token',
      }, // ajusta integración real
    );
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await api.getPurchaseReception(widget.purchaseId);
      setState(() {
        ov = data;
        selectedLotId =
            (data['lots'] as List).isNotEmpty
                ? data['lots'][0]['id'] as String
                : null;
        selectedAnimalId = null;
        errorMsg = null;
        okMsg = null;
      });
    } catch (e) {
      setState(() => errorMsg = e.toString());
    }
  }

  List<dynamic> get lots => ov?['lots'] ?? const [];
  List<dynamic> get unbatched => ov?['unbatchedCattle'] ?? const [];
  List<dynamic> get cattle {
    if (selectedLotId == null) return unbatched;
    final l = lots.firstWhere(
      (x) => x['id'] == selectedLotId,
      orElse: () => null,
    );
    return (l == null) ? [] : (l['cattle'] as List);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.purchaseReceptionTitle)),
      body: Column(
        children: [
          if (errorMsg != null) MessageBanner.error(errorMsg!),
          if (okMsg != null) MessageBanner.success(okMsg!),
          Expanded(
            child: Row(
              children: [
                // Panel lotes
                SizedBox(
                  width: 280,
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(title: Text(t.purchaseBatchesTitle)),
                        ListTile(
                          selected: selectedLotId == null,
                          title: Text(t.withoutLot),
                          onTap:
                              () => setState(() {
                                selectedLotId = null;
                                selectedAnimalId = null;
                              }),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.builder(
                            itemCount: lots.length,
                            itemBuilder: (_, i) {
                              final lot = lots[i] as Map<String, dynamic>;
                              final count = (lot['cattle'] as List).length;
                              return ListTile(
                                selected: selectedLotId == lot['id'],
                                title: Text(
                                  '${t.lot} ${lot['lotNumber'] ?? i + 1}',
                                ),
                                subtitle: Text('${t.cattleCountLabel(count)}'),
                                onTap:
                                    () => setState(() {
                                      selectedLotId = lot['id'] as String;
                                      selectedAnimalId = null;
                                    }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Panel reses
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(title: Text(t.cattleOfSelection)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cattle.length,
                            itemBuilder: (_, i) {
                              final a = cattle[i] as Map<String, dynamic>;
                              return ListTile(
                                selected: selectedAnimalId == a['id'],
                                title: Text(a['number'] ?? '-'),
                                subtitle: Text('${a['weightKg'] ?? ''} kg'),
                                trailing: _LotDropdown(
                                  lots: lots,
                                  value: a['lotId'],
                                  onChanged: (newLotId) async {
                                    try {
                                      await api.reassignLot(
                                        purchaseId: widget.purchaseId,
                                        animalId: a['id'],
                                        lotId: newLotId,
                                      );
                                      await _load();
                                    } catch (e) {
                                      setState(() => errorMsg = e.toString());
                                    }
                                  },
                                ),
                                onTap:
                                    () => setState(
                                      () => selectedAnimalId = a['id'],
                                    ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Panel eventos simples
                SizedBox(
                  width: 360,
                  child: _SimpleEventsPanel(
                    api: api,
                    massEventId: ov?['massEventId'],
                    catalog:
                        (ov?['simpleEventsCatalog'] ?? []) as List<dynamic>,
                    animalId: selectedAnimalId,
                    onChanged: _load,
                  ),
                ),
              ],
            ),
          ),

          // Formulario de ingreso
          if (ov != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: IntakeForm(
                lots: lots.cast<Map<String, dynamic>>(),
                onSubmit: (data) async {
                  try {
                    await api.receiveOne(
                      receptionId: ov!['receptionId'],
                      purchaseId: widget.purchaseId,
                      number: data.number,
                      weightKg: data.weightKg,
                      lotId: data.lotId,
                      colorId: data.colorId,
                      characteristicsIds: data.characteristicsIds,
                      eartag: data.eartag,
                      trackerId: data.trackerId,
                    );
                    await _load();
                    setState(() => okMsg = t.receivedOk);
                  } catch (e) {
                    setState(() => errorMsg = e.toString());
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _LotDropdown extends StatelessWidget {
  final List<dynamic> lots;
  final String? value;
  final Future<void> Function(String?) onChanged;
  const _LotDropdown({
    required this.lots,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      hint: Text(AppLocalizations.of(context)!.assignLot),
      items:
          [
            const DropdownMenuItem<String>(value: null, child: Text('—')),
            ...lots.map(
              (l) => DropdownMenuItem<String>(
                value: l['id'] as String,
                child: Text(
                  '${AppLocalizations.of(context)!.lot} ${l['lotNumber']}',
                ),
              ),
            ),
          ].cast<DropdownMenuItem<String>>(),
      onChanged: (v) => onChanged(v),
    );
  }
}

class _SimpleEventsPanel extends StatefulWidget {
  final ReceptionApiService api;
  final String? massEventId;
  final List<dynamic> catalog;
  final String? animalId;
  final Future<void> Function() onChanged;

  const _SimpleEventsPanel({
    required this.api,
    required this.massEventId,
    required this.catalog,
    required this.animalId,
    required this.onChanged,
  });

  @override
  State<_SimpleEventsPanel> createState() => _SimpleEventsPanelState();
}

class _SimpleEventsPanelState extends State<_SimpleEventsPanel> {
  List<Map<String, dynamic>> applied = [];
  bool loading = false;

  @override
  void didUpdateWidget(covariant _SimpleEventsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animalId != widget.animalId) _load();
  }

  Future<void> _load() async {
    if (widget.animalId == null) {
      setState(() => applied = []);
      return;
    }
    setState(() => loading = true);
    try {
      applied = await widget.api.listAnimalEvents(widget.animalId!);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final appliedIds = applied.map((e) => e['id'] as String).toSet();
    final notApplied =
        widget.catalog.where((e) => !appliedIds.contains(e['id'])).toList();

    return Card(
      child: Column(
        children: [
          ListTile(title: Text(t.simpleEventsTitle)),
          if (widget.animalId == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(t.selectAnimalHint),
            ),
          if (widget.animalId != null) ...[
            Text(t.appliedEvents),
            Expanded(
              child: ListView(
                children:
                    applied
                        .map(
                          (e) => ListTile(
                            title: Text(e['type']),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () async {
                                await widget.api.patchAnimalEvents(
                                  animalId: widget.animalId!,
                                  massEventId: widget.massEventId!,
                                  removeIds: [e['id']],
                                );
                                await widget.onChanged();
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const Divider(height: 1),
            Text(t.availableEvents),
            Expanded(
              child: ListView(
                children:
                    notApplied
                        .map(
                          (e) => ListTile(
                            title: Text(e['type']),
                            trailing: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () async {
                                await widget.api.patchAnimalEvents(
                                  animalId: widget.animalId!,
                                  massEventId: widget.massEventId!,
                                  addIds: [e['id']],
                                );
                                await widget.onChanged();
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
