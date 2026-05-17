import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/services/provider_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/provider.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/provider_autocomplete_field.dart';

class ProviderInput extends StatefulWidget {
  final void Function(ProviderModel) onProviderSelected;
  final ProviderService? providerService;
  final void Function(String message)? onError;
  final void Function(String message)? onSuccess;

  const ProviderInput({
    super.key,
    required this.onProviderSelected,
    this.providerService,
    this.onError,
    this.onSuccess,
  });

  @override
  State<ProviderInput> createState() => _ProviderInputState();
}

class _ProviderInputState extends State<ProviderInput> {
  ProviderModel? _selectedProvider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProviderAutocompleteField(
          label: l10n.provider,
          providerType: ProviderType.PROVIDER.name,
          required: true,
          validator: (_) {
            if (_selectedProvider == null) {
              return l10n.cp_error_providerRequired;
            }
            return null;
          },
          onChanged: (id, name) {
            if (id == null || name == null) {
              setState(() => _selectedProvider = null);
              return;
            }
            final provider = ProviderModel(
              id: id,
              name: name,
              nit: '',
              type: ProviderType.PROVIDER,
            );
            setState(() => _selectedProvider = provider);
            widget.onProviderSelected(provider);
          },
        ),
      ],
    );
  }
}
