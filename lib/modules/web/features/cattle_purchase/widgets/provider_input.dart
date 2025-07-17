import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../services/provider_service.dart';
import '../models/provider.dart';
import '../../../../../core/services/exceptions.dart';

class ProviderInput extends StatefulWidget {
  final void Function(ProviderModel) onProviderSelected;
  final ProviderService? providerService;

  const ProviderInput({
    super.key,
    required this.onProviderSelected,
    this.providerService,
  });

  @override
  State<ProviderInput> createState() => _ProviderInputState();
}

class _ProviderInputState extends State<ProviderInput> {
  final TextEditingController _nameController = TextEditingController();
  bool _providerExists = false;
  bool _isLoading = false;
  String _enteredNit = '';
  ProviderModel? _selectedProvider;
  Timer? _debounce;
  List<ProviderModel> _cachedSuggestions = [];
  ProviderService get _service => widget.providerService ?? ProviderService();

  void _createProviderIfNeeded(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final nit = _enteredNit.trim();
    final name = _nameController.text.trim();
    if (nit.isEmpty || name.isEmpty || _providerExists) return;

    setState(() => _isLoading = true);

    try {
      final created = await _service.create(name: name, nit: nit);
      _selectedProvider = created;
      _providerExists = true;
      _cachedSuggestions.add(created);
      widget.onProviderSelected(_selectedProvider!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.provider_createdSuccessfully)),
        );
      }
    } catch (e) {
      if (mounted) {
        String message;
        if (e is ProviderCreationException) {
          final l10n = AppLocalizations.of(context)!;
          message = switch (e.message) {
            'providerCreationDuplicateNit' => l10n.provider_nitAlreadyExists,
            _ => l10n.provider_creationError,
          };
        } else {
          message = l10n.provider_creationError;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
      //ScaffoldMessenger.of(context,).showSnackBar(SnackBar(content: Text('Error creando proveedor: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: RawAutocomplete<ProviderModel>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.length < 3) {
                    return Future.value([]);
                  }
                  final completer = Completer<List<ProviderModel>>();
                  _debounce?.cancel();
                  _debounce = Timer(
                    const Duration(milliseconds: 1000),
                    () async {
                      try {
                        final results = await _service.searchByNit(
                          textEditingValue.text,
                        );
                        _cachedSuggestions = results;
                        if (!completer.isCompleted) completer.complete(results);
                      } catch (_) {
                        if (!completer.isCompleted) completer.complete([]);
                      }
                    },
                  );
                  return completer.future;
                },
                displayStringForOption: (ProviderModel option) => option.nit,
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  controller.addListener(() {
                    setState(() {
                      _enteredNit = controller.text;
                      if (_providerExists && _selectedProvider != null) {
                        if (_enteredNit != _selectedProvider!.nit) {
                          _selectedProvider = null;
                          _providerExists = false;
                          _nameController.text = '';
                        }
                      }
                    });
                  });

                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: l10n.provider_nit,
                      suffixIcon:
                          _isLoading
                              ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                              : null,
                    ),
                    keyboardType: TextInputType.number,
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? l10n.provider_nitIsRequired
                                : null,
                  );
                },
                onSelected: (ProviderModel selected) {
                  setState(() {
                    _providerExists = true;
                    _selectedProvider = selected;
                    _nameController.text = selected.name;
                  });
                  widget.onProviderSelected(_selectedProvider!);
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final ProviderModel option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name),
                            subtitle: Text(option.nit),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 4,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.provider),
                enabled: !_providerExists,
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? l10n.cp_error_providerRequired
                            : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (!_providerExists && _enteredNit.isNotEmpty && !_isLoading)
          ElevatedButton.icon(
            onPressed: () => _createProviderIfNeeded(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.provider_create),
          ),
      ],
    );
  }
}
