import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/models/latest_cattle_location_model.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/services/locations_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/locations/utils/location_time_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Widget tests (`flutter test`, incl. `-p chrome`) no definen siempre `FLUTTER_TEST`
/// como `dart-define`: detectamos también el binding de test.
bool _useCattleMapTestPlaceholder() {
  if (CattleLastLocationsMapWidget.debugDisableTestPlaceholder == true) {
    return false;
  }
  if (const bool.fromEnvironment('FLUTTER_TEST')) {
    return true;
  }
  final bindingName = WidgetsBinding.instance.runtimeType.toString();
  return bindingName.contains('AutomatedTestWidgetsFlutterBinding');
}

class CattleLastLocationsMapWidget extends StatefulWidget {
  /// Permite montar el mapa real en pruebas con stub HTTP (p. ej. widget test de esta HU).
  @visibleForTesting
  static bool? debugDisableTestPlaceholder;

  final double height;
  final double initialZoom;

  const CattleLastLocationsMapWidget({
    super.key,
    this.height = 420,
    this.initialZoom = 14,
  });

  @override
  State<CattleLastLocationsMapWidget> createState() =>
      _CattleLastLocationsMapWidgetState();
}

class _CattleLastLocationsMapWidgetState
    extends State<CattleLastLocationsMapWidget> {
  late final Future<List<LatestCattleLocationModel>> _future =
      LocationsApiService.getLatestCattleLocations();

  @override
  Widget build(BuildContext context) {
    // En widget tests evitamos montar el mapa real (tiles, timers, renders continuos).
    if (_useCattleMapTestPlaceholder()) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: KeyedSubtree(
            key: ValueKey<String>('cattle-last-locations-map-test-placeholder'),
            child: Text('Map Placeholder (test)'),
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: widget.height,
      child: FutureBuilder<List<LatestCattleLocationModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                l10n.locations_map_loadError,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          final items = snapshot.data ?? const [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                l10n.locations_map_empty,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          final center = LatLng(items.first.latitude, items.first.longitude);
          final markers = items.map((it) => _markerFor(context, it)).toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: widget.initialZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'finca_app_frontend',
              ),
              MarkerLayer(markers: markers),
              Positioned(
                left: 8,
                top: 8,
                child: _MapOverlayLabel(
                  icon: FontAwesomeIcons.cow,
                  label: l10n.locations_map_cattleCount(items.length),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: _MapOverlayLabel(
                  label: l10n.locations_map_osmAttribution,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Marker _markerFor(BuildContext context, LatestCattleLocationModel it) {
    final pos = LatLng(it.latitude, it.longitude);
    final label = '${it.cattleNumber} • ${formatLocationTime(it.time)}';

    return Marker(
      point: pos,
      width: 48,
      height: 48,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () => _showDetails(context, it),
          child: const Icon(Icons.location_on, size: 36, color: Colors.red),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, LatestCattleLocationModel it) {
    final l10n = AppLocalizations.of(context)!;
    final label = '${it.cattleNumber} • ${formatLocationTime(it.time)}';
    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.locations_map_lastLocationTitle),
            content: Text(label),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
            ],
          ),
    );
  }
}

class _MapOverlayLabel extends StatelessWidget {
  final IconData? icon;
  final String label;
  final TextStyle? textStyle;

  const _MapOverlayLabel({required this.label, this.icon, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x22000000),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: textStyle ?? Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
