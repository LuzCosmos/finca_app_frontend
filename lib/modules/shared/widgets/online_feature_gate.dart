import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/home/services/home_connectivity_service.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';

/// En móvil, bloquea pantallas 100 % online cuando no hay red.
class OnlineFeatureGate extends StatefulWidget {
  const OnlineFeatureGate({super.key, required this.child});

  final Widget child;

  @override
  State<OnlineFeatureGate> createState() => _OnlineFeatureGateState();
}

class _OnlineFeatureGateState extends State<OnlineFeatureGate> {
  bool? _online;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _online = true;
      return;
    }
    HomeConnectivityService.isOnline().then((online) {
      if (mounted) setState(() => _online = online);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return widget.child;

    final online = _online;
    if (online == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (online) return widget.child;

    final l10n = AppLocalizations.of(context)!;
    return FincaScaffold(
      title: l10n.home_title,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.onlineFeatureRequiresConnection,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
