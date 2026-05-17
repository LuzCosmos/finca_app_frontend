import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Icono compacto que abre la pantalla de configuración remota del collar
/// ([DeviceRemoteConfigScreen]) mediante la ruta nombrada [deviceRemoteConfig].
///
/// Si [onOpenRemoteConfig] no es null, se invoca en lugar del `pushNamed`
/// por defecto (útil para cerrar un diálogo antes de navegar).
class TrackerRemoteConfigIconButton extends StatelessWidget {
  const TrackerRemoteConfigIconButton({
    super.key,
    required this.deveui,
    this.deviceDisplayName,
    required this.hasRemoteConfigAccess,
    this.onOpenRemoteConfig,
    this.iconSize = 16,
    this.iconPadding = EdgeInsets.zero,
    this.iconConstraints = const BoxConstraints(minWidth: 24, minHeight: 24),
  });

  final String deveui;
  final String? deviceDisplayName;
  final bool hasRemoteConfigAccess;

  /// Sustituye la navegación por defecto (p. ej. `pop` del diálogo + push).
  final VoidCallback? onOpenRemoteConfig;

  final double iconSize;
  final EdgeInsetsGeometry iconPadding;
  final BoxConstraints iconConstraints;

  @override
  Widget build(BuildContext context) {
    if (!hasRemoteConfigAccess || deveui.isEmpty) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      icon: Icon(
        Icons.settings_remote,
        size: iconSize,
        color: Colors.blueGrey,
      ),
      tooltip: l10n.openRemoteConfigTooltip,
      padding: iconPadding,
      constraints: iconConstraints,
      onPressed:
          onOpenRemoteConfig ??
          () {
            context.pushNamed(
              'deviceRemoteConfig',
              pathParameters: {'deveui': deveui},
              queryParameters: {
                if (deviceDisplayName != null &&
                    deviceDisplayName!.isNotEmpty)
                  'name': deviceDisplayName!,
              },
            );
          },
    );
  }
}
