import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/core/services/session_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/tracker_remote_config_icon_button.dart';

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
  final FocusNode _focusNode = FocusNode();
  // List<DeviceModel> _options = [];
  bool _isLoading = false;
  Timer? _debounce;
  bool _remoteConfigRead = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _loadRemoteConfigPermission();
  }

  Future<void> _loadRemoteConfigPermission() async {
    final ok = await SessionService.hasActionPermission(
      'PROD_CENTER',
      'remote_config',
      'read',
    );
    if (mounted) setState(() => _remoteConfigRead = ok);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.tracker),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RawAutocomplete<DeviceModel>(
              textEditingController: _controller,
              focusNode: _focusNode,
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text.length < 3) {
                  return const Iterable<DeviceModel>.empty();
                }

                // Use a Completer to bridge the async gap with debounce
                final Completer<List<DeviceModel>> completer = Completer();

                if (_debounce?.isActive ?? false) _debounce!.cancel();

                _debounce = Timer(const Duration(milliseconds: 500), () async {
                  if (!mounted) return;
                  // Only set loading if not already loading to avoid unnecessary rebuilds
                  if (!_isLoading) setState(() => _isLoading = true);

                  try {
                    final results = await DeviceApiService.searchDevices(
                      textEditingValue.text,
                    );
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _errorText = null;
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
                    if (!completer.isCompleted)
                      completer.complete(
                        const Iterable<DeviceModel>.empty().toList(),
                      );
                  }
                });

                return completer.future;
              },
              displayStringForOption: (DeviceModel option) => option.name,
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.searchTracker,
                    hintText: l10n.trackerSearch_minCharsHint(3),
                    border: const OutlineInputBorder(),
                    suffixIcon:
                        _isLoading
                            ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                            : null,
                    errorText: _errorText,
                  ),
                  onSubmitted: (value) {
                    // Submit can be handled if needed
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 360,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name),
                            subtitle: Text(option.deveui),
                            /*
                            //Edit Device by downlinks button
                            trailing: TrackerRemoteConfigIconButton(
                              deveui: option.deveui,
                              deviceDisplayName: option.name,
                              hasRemoteConfigAccess: _remoteConfigRead,
                              onOpenRemoteConfig: () {
                                final router = GoRouter.of(context);
                                Navigator.of(context).pop();
                                Future.microtask(() {
                                  router.pushNamed(
                                    'deviceRemoteConfig',
                                    pathParameters: {'deveui': option.deveui},
                                    queryParameters: {
                                      if (option.name.isNotEmpty)
                                        'name': option.name,
                                    },
                                  );
                                });
                              },
                            ),*/
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
                Navigator.of(context).pop(selection);
              },
            ),
          ],
        ),
      ),
      actions: [
        if (widget.initialValue != null && widget.initialValue!.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.of(context).pop('remove'),
            child: Text(l10n.remove, style: const TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
