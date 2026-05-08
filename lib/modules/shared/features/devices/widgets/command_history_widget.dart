import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Widget que renderiza el historial de comandos enviados a un device.
class CommandHistoryWidget extends StatelessWidget {
  final DeviceCommandPage page;

  const CommandHistoryWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (page.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.deviceRemoteConfig_history_empty),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: page.items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final c = page.items[index];
        return ListTile(
          leading: Icon(_iconForType(c.type), color: _colorForStatus(c.status)),
          title: Text(c.action),
          subtitle: Text(
            '${l10n.deviceRemoteConfig_history_statusLabel(c.status)}\n'
            '${_formatDate(c.createdAt)}'
            '${c.errorMessage != null ? '\n${l10n.deviceRemoteConfig_history_errorLabel(c.errorMessage!)}' : ''}',
          ),
          isThreeLine: c.errorMessage != null,
          trailing: Text(
            l10n.deviceRemoteConfig_history_fportLabel('${c.fPort}'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'CONFIGURE':
        return Icons.tune;
      case 'CONTROL':
        return Icons.touch_app;
      case 'READ':
        return Icons.visibility;
      case 'LOCAL_STORAGE':
        return Icons.sd_storage;
      default:
        return Icons.bolt;
    }
  }

  Color _colorForStatus(String status) {
    switch (status) {
      case 'APPLIED':
        return Colors.green;
      case 'PENDING_VERIFICATION':
        return Colors.orange;
      case 'QUEUED_IN_CHIRPSTACK':
      case 'SENT':
      case 'ACKED':
        return Colors.blue;
      case 'FAILED':
      case 'EXPIRED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime d) {
    final dt = d.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }
}
