import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:finca_app_frontend/modules/web/features/purchase_reception/services/reception_api_service.dart';

class PurchaseInfoDisplay extends StatefulWidget {
  final String providerName;
  final String purchaseDate;
  final DateTime? receptionDate;
  final String? initialCattleNumber;
  final Function(DateTime) onReceptionDateChanged;
  final Function(String) onInitialNumberChanged;
  final Function(String)? onError;
  final ReceptionApiService? apiService;

  const PurchaseInfoDisplay({
    super.key,
    required this.providerName,
    required this.purchaseDate,
    this.receptionDate,
    this.initialCattleNumber,
    required this.onReceptionDateChanged,
    required this.onInitialNumberChanged,
    this.onError,
    this.apiService,
  });

  @override
  State<PurchaseInfoDisplay> createState() => _PurchaseInfoDisplayState();
}

class _PurchaseInfoDisplayState extends State<PurchaseInfoDisplay> {
  Timer? _debounce;
  bool _isValidating = false;
  String? _externalError;
  late ReceptionApiService _apiService;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ReceptionApiService();
    _controller = TextEditingController(text: widget.initialCattleNumber);
  }

  @override
  void didUpdateWidget(PurchaseInfoDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCattleNumber != oldWidget.initialCattleNumber) {
        if (widget.initialCattleNumber != _controller.text) {
           _controller.text = widget.initialCattleNumber ?? '';
        }
        _checkNumberExists(widget.initialCattleNumber ?? '');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkNumberExists(String val) async {
    final l10n = AppLocalizations.of(context)!;
    if (val.isEmpty) {
      if (_externalError != null) {
        setState(() => _externalError = null);
      }
      return;
    }
    setState(() => _isValidating = true);
    try {
      final exists = await _apiService.checkCattleNumberExists(val);
      if (exists) {
        setState(() => _externalError = l10n.cattle_exists_error);
      } else if (_externalError != null) {
        setState(() => _externalError = null);
      }
    } catch (e) {
      widget.onError?.call(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isValidating = false);
      }
    }
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.receptionDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.receptionDate) {
      widget.onReceptionDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Provider name (read-only)
            Row(
              children: [
                Text(
                  '${l10n.provider}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    widget.providerName,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Purchase date (read-only)
            Row(
              children: [
                Text(
                  '${l10n.dateSomething(l10n.purchase)}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.purchaseDate),
              ],
            ),
            const SizedBox(height: 1),
            const Divider(),
            const SizedBox(height: 1),

            // Reception date (editable with date picker)
            Row(
              children: [
                Text('${l10n.receptionDate}: '),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    DateFormat('yyyy-MM-dd').format(widget.receptionDate ?? DateTime.now()),
                  ),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 2),

            // Initial cattle number (editable)
            Row(
              children: [
                Text(
                  l10n.initialCattleNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _controller, // Use controller instead of initialValue
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: const OutlineInputBorder(),
                      errorText: _externalError, // Show validation error
                      suffixIcon: _isValidating
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      widget.onInitialNumberChanged(value);
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        _checkNumberExists(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
