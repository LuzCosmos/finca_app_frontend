import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_event.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_state.dart';

/// Puedes pasar un callback que devuelva el número de pendientes
class SyncButtonWidget extends StatefulWidget {
  final String idTenant;
  final Future<int> Function(String idTenant)? getPendingCount;

  const SyncButtonWidget({
    super.key,
    required this.idTenant,
    this.getPendingCount,
  });

  @override
  State<SyncButtonWidget> createState() => _SyncButtonWidgetState();
}

class _SyncButtonWidgetState extends State<SyncButtonWidget> {
  int _pendingCount = 0;
  bool _loadingCount = false;

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    if (widget.getPendingCount == null) return;
    setState(() => _loadingCount = true);
    final count = await widget.getPendingCount!(widget.idTenant);
    setState(() {
      _pendingCount = count;
      _loadingCount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncBloc, SyncState>(
      listener: (context, state) async {
        final l10n = AppLocalizations.of(context)!;
        if (state is SyncInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.syncMassiveEventsInProgress)),
          );
        } else if (state is SyncSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.syncMassiveEventsSuccess)),
          );
          await _loadPendingCount(); // recargar pendientes
        } else if (state is SyncFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.syncMassiveEventsFailure(state.message)),
            ),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final button = ElevatedButton.icon(
          icon: const Icon(Icons.sync),
          label:
              _loadingCount
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    _pendingCount > 0
                        ? l10n.syncMassiveEventsWithPendingCount(_pendingCount)
                        : l10n.syncNow,
                  ),
          onPressed: () {
            context.read<SyncBloc>().add(StartSync(widget.idTenant));
          },
        );

        // Si no hay getPendingCount, no ponemos badge
        if (widget.getPendingCount == null) {
          return button;
        }

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            button,
            if (_pendingCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  child: Center(
                    child: Text(
                      '$_pendingCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
/**
Future<int> _getPendingCount(String idTenant) async {
  return await syncService.getPendingCount(idTenant);
}


Center(
  child: SyncButtonWidget(
  idTenant: _idTenant,
  getPendingCount: syncService.getPendingCount, // 👈 ya no tienes lógica en UI
),
),


 */