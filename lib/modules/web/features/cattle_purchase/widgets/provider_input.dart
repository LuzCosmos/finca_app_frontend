import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

class ProviderInput extends StatefulWidget {
  const ProviderInput({super.key});

  @override
  State<ProviderInput> createState() => _ProviderInputState();
}

class _ProviderInputState extends State<ProviderInput> {
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _providerExists = false;
  bool _isLoading = false;

  Future<void> _checkProviderByNit(String nit) async {
    if (nit.isEmpty) return;

    setState(() => _isLoading = true);

    // Simulación de consulta. Reemplazar por servicio real.
    await Future.delayed(const Duration(seconds: 1));

    if (nit == '123456789') {
      _providerExists = true;
      _nameController.text = 'Ganadería La Esperanza';
    } else {
      _providerExists = false;
      _nameController.clear();
    }

    setState(() => _isLoading = false);
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
                            ? '${l10n.cp_nit} is required'
                            : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.cp_provider),
                enabled: !_providerExists, // si ya existe, no se puede editar
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? '${l10n.cp_provider} is required'
                            : null,
              ),
            ),
          ],
        ),
        if (_providerExists)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.cp_providerFound,
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        if (!_providerExists && _nitController.text.isNotEmpty && !_isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.cp_providerWillBeCreated,
              style: TextStyle(color: Colors.orange.shade700),
            ),
          ),
      ],
    );
  }
}
