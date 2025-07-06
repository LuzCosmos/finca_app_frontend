import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import '../services/provider_service.dart';

class ProviderInput extends StatefulWidget {
  final void Function(Map<String, dynamic> providerData) onProviderSelected;

  const ProviderInput({super.key, required this.onProviderSelected});

  @override
  State<ProviderInput> createState() => _ProviderInputState();
}

class _ProviderInputState extends State<ProviderInput> {
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _providerExists = false;
  bool _isLoading = false;
  Map<String, dynamic>? _selectedProvider;

  Future<void> _checkProviderByNit(String nit) async {
    if (nit.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final provider = await ProviderService.getByNit(nit);
      if (provider != null) {
        _providerExists = true;
        _nameController.text = provider['name'];
        _selectedProvider = provider;
        widget.onProviderSelected(provider);
      } else {
        _providerExists = false;
        _nameController.clear();
        _selectedProvider = null;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error buscando proveedor: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _createProviderIfNeeded() async {
    if (_providerExists || _selectedProvider != null) return;

    final nit = _nitController.text.trim();
    final name = _nameController.text.trim();
    if (nit.isEmpty || name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final created = await ProviderService.create(name: name, nit: nit);
      _providerExists = true;
      _selectedProvider = created;
      widget.onProviderSelected(created);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creando proveedor: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.cp_provider, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _nitController,
                decoration: InputDecoration(
                  labelText: l10n.cp_nit,
                  suffixIcon:
                      _isLoading
                          ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                          : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed:
                                () => _checkProviderByNit(_nitController.text),
                          ),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? l10n.cp_nitIsRequired
                            : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.cp_provider),
                enabled: !_providerExists,
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? l10n.cp_providerIsRequired
                            : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!_providerExists && _nitController.text.isNotEmpty && !_isLoading)
          ElevatedButton.icon(
            onPressed: _createProviderIfNeeded,
            icon: const Icon(Icons.add),
            label: Text(l10n.cp_createProvider),
          ),
      ],
    );
  }
}
