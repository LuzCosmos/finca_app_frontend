import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';

class TrackerEditDialog extends StatefulWidget {
  final String? initialValue;
  final Function(DeviceModel) onSelected;

  const TrackerEditDialog({
    super.key,
    this.initialValue,
    required this.onSelected,
  });

  @override
  State<TrackerEditDialog> createState() => _TrackerEditDialogState();
}

class _TrackerEditDialogState extends State<TrackerEditDialog> {
  final TextEditingController _controller = TextEditingController();
  // List<DeviceModel> _options = [];
  bool _isLoading = false;
  Timer? _debounce;
  Completer<List<DeviceModel>>? _lastCompleter;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.trackerLabel), // Assuming trackerLabel exists, else "Tracker"
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RawAutocomplete<DeviceModel>(
              textEditingController: _controller,
              focusNode: FocusNode(), // Manage focus if needed
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (_lastCompleter != null && !_lastCompleter!.isCompleted) {
                  _lastCompleter!.complete(const Iterable<DeviceModel>.empty().toList());
                }

                final Completer<List<DeviceModel>> completer = Completer();
                _lastCompleter = completer;

                if (textEditingValue.text.length < 3) {
                  // setState(() => _options = []);
                  completer.complete(const Iterable<DeviceModel>.empty().toList());
                  return completer.future;
                }

                if (_debounce?.isActive ?? false) _debounce!.cancel();

                _debounce = Timer(const Duration(milliseconds: 500), () async {
                  if (!mounted) return;
                  setState(() {
                    _isLoading = true;
                    _errorText = null;
                  });
                  try {
                    final results = await DeviceApiService.searchDevices(textEditingValue.text);
                    if (mounted) {
                      setState(() {
                        // _options = results;
                        _isLoading = false;
                      });
                    }
                    if (!completer.isCompleted) completer.complete(results);
                  } catch (e) {
                     if (mounted) {
                        setState(() {
                            _isLoading = false;
                            _errorText = e.toString();
                        });
                     }
                     if (!completer.isCompleted) completer.complete(const Iterable<DeviceModel>.empty().toList());
                  }
                });

                return completer.future;
              },
              displayStringForOption: (DeviceModel option) => option.name,
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.searchTracker, // Using existing key if possible
                    hintText: 'Min 3 chars...',
                    border: const OutlineInputBorder(),
                    suffixIcon: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        : null,
                    errorText: _errorText,
                  ),
                  onSubmitted: (value) {
                     // Handle submit if needed, or rely on selection
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name),
                            subtitle: Text(option.deveui),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (DeviceModel selection) {
                widget.onSelected(selection);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
