import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Diálogo modal que permite al usuario elegir un perfil de configuración para
/// aplicar al collar. Devuelve el `idProfile` seleccionado o `null` si cancela.
class ApplyProfileDialog extends StatefulWidget {
  final List<ConfigurationProfileModel> profiles;
  final String? currentProfileId;

  const ApplyProfileDialog({
    super.key,
    required this.profiles,
    this.currentProfileId,
  });

  static Future<String?> show(
    BuildContext context, {
    required List<ConfigurationProfileModel> profiles,
    String? currentProfileId,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => ApplyProfileDialog(
        profiles: profiles,
        currentProfileId: currentProfileId,
      ),
    );
  }

  @override
  State<ApplyProfileDialog> createState() => _ApplyProfileDialogState();
}

class _ApplyProfileDialogState extends State<ApplyProfileDialog> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.currentProfileId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.deviceRemoteConfig_dialog_applyProfileTitle),
      content: SizedBox(
        width: 400,
        child: widget.profiles.isEmpty
            ? Text(l10n.deviceRemoteConfig_dialog_noProfiles)
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.profiles.length,
                itemBuilder: (context, index) {
                  final p = widget.profiles[index];
                  final isSelected = _selectedId == p.id;
                  return ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    selected: isSelected,
                    onTap: () => setState(() => _selectedId = p.id),
                    title: Text(p.name),
                    subtitle: Text(
                      '${p.code}${p.isSystem ? ' · ${l10n.deviceRemoteConfig_profile_systemBadge}' : ''}'
                      '${p.description != null ? '\n${p.description}' : ''}',
                    ),
                    isThreeLine: p.description != null,
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _selectedId == null
              ? null
              : () => Navigator.of(context).pop(_selectedId),
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
