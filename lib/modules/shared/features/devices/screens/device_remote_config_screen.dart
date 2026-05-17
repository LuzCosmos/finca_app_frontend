import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_event.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/bloc/device_remote_config_state.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/constants/lw001_bg_pro_safe_read_chunks.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/device_remote_config_models.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_remote_config_data_source_impl.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/widgets/apply_profile_dialog.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/widgets/command_history_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/widgets/current_parameters_table_widget.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/widgets/diagnostic_mode_card.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Pantalla principal de configuración remota para un device específico.
///
/// Acepta el `deveui` por constructor — la ruta debe extraerlo del path param.
class DeviceRemoteConfigScreen extends StatelessWidget {
  final String deveui;
  final String? deviceName;

  const DeviceRemoteConfigScreen({
    super.key,
    required this.deveui,
    this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => DeviceRemoteConfigBloc(
            dataSource: const DeviceRemoteConfigApiDataSource(),
            l10n: AppLocalizations.of(context),
          )..add(LoadDeviceRemoteConfig(deveui)),
      child: _DeviceRemoteConfigView(deveui: deveui, deviceName: deviceName),
    );
  }
}

class _DeviceRemoteConfigView extends StatelessWidget {
  final String deveui;
  final String? deviceName;
  const _DeviceRemoteConfigView({required this.deveui, this.deviceName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          deviceName == null
              ? l10n.deviceRemoteConfig_title
              : l10n.deviceRemoteConfig_titleWithName(deviceName!),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed:
                () => context.read<DeviceRemoteConfigBloc>().add(
                  LoadDeviceRemoteConfig(deveui),
                ),
          ),
        ],
      ),
      body: BlocConsumer<DeviceRemoteConfigBloc, DeviceRemoteConfigState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.lastSuccessMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.lastSuccessMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        listenWhen:
            (a, b) =>
                a.errorMessage != b.errorMessage ||
                a.lastSuccessMessage != b.lastSuccessMessage,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatusCard(state: state),
              const SizedBox(height: 16),
              DiagnosticModeCard(deveui: deveui),
              const SizedBox(height: 16),
              _ActionsCard(deveui: deveui),
              const SizedBox(height: 16),
              CurrentParametersTableWidget(status: state.status),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  l10n.deviceRemoteConfig_actions_historyTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (state.commandPage != null)
                CommandHistoryWidget(page: state.commandPage!),
            ],
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final DeviceRemoteConfigState state;
  const _StatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = state.status;
    final profileName =
        (status?.profileSnapshot['name'] as String?) ??
        l10n.deviceRemoteConfig_noProfileApplied;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.deviceRemoteConfig_statusTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  status?.isInSync == true
                      ? Icons.check_circle
                      : Icons.sync_problem,
                  color:
                      status?.isInSync == true ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status?.isInSync == true
                        ? l10n.deviceRemoteConfig_synced
                        : l10n.deviceRemoteConfig_waitingConfirmation(
                          '${status?.desiredVersion ?? 0}',
                          '${status?.confirmedVersion ?? 0}',
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.deviceRemoteConfig_currentProfile(profileName)),
            if (status?.divergent.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                l10n.deviceRemoteConfig_divergentParams(
                  status!.divergent.join(', '),
                ),
                style: const TextStyle(color: Colors.deepOrange),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final String deveui;
  const _ActionsCard({required this.deveui});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.watch<DeviceRemoteConfigBloc>();
    final state = bloc.state;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  icon:
                      state.isApplyingProfile
                          ? _smallSpinner()
                          : const Icon(Icons.tune),
                  label: Text(l10n.deviceRemoteConfig_action_applyProfile),
                  onPressed:
                      state.isApplyingProfile
                          ? null
                          : () async {
                            final selected = await ApplyProfileDialog.show(
                              context,
                              profiles: state.profiles,
                              currentProfileId: state.status?.idProfile,
                            );
                            if (selected != null) {
                              // ignore: use_build_context_synchronously
                              context.read<DeviceRemoteConfigBloc>().add(
                                ApplyConfigurationProfileRequested(
                                  deveui: deveui,
                                  idProfile: selected,
                                ),
                              );
                            }
                          },
                ),
                FilledButton.tonalIcon(
                  icon:
                      state.isRequestingPosition
                          ? _smallSpinner()
                          : const Icon(Icons.gps_fixed),
                  label: Text(
                    l10n.deviceRemoteConfig_action_requestPositionNow,
                  ),
                  onPressed:
                      state.isRequestingPosition
                          ? null
                          : () => bloc.add(RequestDevicePositionEvent(deveui)),
                ),
                FilledButton.tonalIcon(
                  icon:
                      state.isRequestingBattery
                          ? _smallSpinner()
                          : const Icon(Icons.battery_charging_full),
                  label: Text(l10n.deviceRemoteConfig_action_requestBattery),
                  onPressed:
                      state.isRequestingBattery
                          ? null
                          : () =>
                              bloc.add(RequestBatteryConsumptionEvent(deveui)),
                ),
                OutlinedButton.icon(
                  icon:
                      state.isClearingManDown
                          ? _smallSpinner()
                          : const Icon(Icons.directions_run),
                  label: Text(l10n.deviceRemoteConfig_action_clearManDown),
                  onPressed:
                      state.isClearingManDown
                          ? null
                          : () => bloc.add(ClearManDownRequested(deveui)),
                ),
                OutlinedButton.icon(
                  icon:
                      state.isConfiguring
                          ? _smallSpinner()
                          : const Icon(Icons.network_cell),
                  label: Text(l10n.deviceRemoteConfig_action_lorawanOnly),
                  onPressed:
                      state.isConfiguring
                          ? null
                          : () async {
                            final confirmed = await _confirmLorawanOnly(
                              context,
                              l10n,
                            );
                            if (confirmed == true) {
                              // ignore: use_build_context_synchronously
                              context.read<DeviceRemoteConfigBloc>().add(
                                SetLorawanOnlyPositioningRequested(deveui),
                              );
                            }
                          },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.deviceRemoteConfig_readSafeChunks_sectionTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _SafeReadChunkButtons(deveui: deveui),
            if (state.readSafeChunkPlanError != null) ...[
              const SizedBox(height: 6),
              Text(
                state.readSafeChunkPlanError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  icon:
                      state.isReadingAllSafeParameters
                          ? _smallSpinner()
                          : const Icon(Icons.manage_search),
                  label: Text(
                    l10n.deviceRemoteConfig_action_readAllSafeParameters,
                  ),
                  onPressed:
                      state.isReadingAllSafeParameters ||
                              state.readingSafeChunkIndex != null
                          ? null
                          : () =>
                              bloc.add(ReadAllSafeParametersRequested(deveui)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallSpinner() => const SizedBox(
    width: 16,
    height: 16,
    child: CircularProgressIndicator(strokeWidth: 2),
  );

  /// Diálogo de confirmación antes de apagar GPS / WiFi / BT en el collar.
  /// Cambia 6 parámetros del firmware (las 6 position-strategy a 0x00) por lo que
  /// es prudente que el operador confirme.
  Future<bool?> _confirmLorawanOnly(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.deviceRemoteConfig_lorawanOnly_dialog_title),
            content: Text(l10n.deviceRemoteConfig_lorawanOnly_dialog_body),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.deviceRemoteConfig_lorawanOnly_dialog_cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.deviceRemoteConfig_lorawanOnly_dialog_confirm),
              ),
            ],
          ),
    );
  }
}

/// Renderiza siempre los N botones (uno por bloque) usando los presets locales
/// LW001-BG PRO. Si el backend devolvió un plan, lo usa para enriquecer tooltips
/// con los nombres de parámetros; si no, muestra el HEX exacto del downlink que se
/// dispararía. Esto evita que la sección quede vacía cuando el endpoint del plan
/// falla (404/permiso) y deja claro al usuario qué bytes saldrán al device.
class _SafeReadChunkButtons extends StatelessWidget {
  final String deveui;
  const _SafeReadChunkButtons({required this.deveui});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DeviceRemoteConfigBloc>();
    final state = bloc.state;
    final plan = state.readSafeChunkPlan;
    final disableAll =
        state.readingSafeChunkIndex != null || state.isReadingAllSafeParameters;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final preset in kLw001BgProSafeReadChunkPresets)
          () {
            ReadSafeParametersChunkItemModel? live;
            if (plan != null) {
              for (final c in plan.chunks) {
                if (c.chunkIndex == preset.chunkIndex) {
                  live = c;
                  break;
                }
              }
            }
            final names = live?.parameterNames ?? const <String>[];
            final tooltipParts = <String>[
              '${preset.expectedHex} (${preset.count} IDs)',
              if (names.isNotEmpty) names.take(10).join(', '),
            ];
            return Tooltip(
              message: tooltipParts.join('\n'),
              child: OutlinedButton.icon(
                icon:
                    state.readingSafeChunkIndex == preset.chunkIndex
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.layers_outlined),
                label: Text(preset.label),
                onPressed:
                    disableAll
                        ? null
                        : () => bloc.add(
                          ReadSafeParametersChunkRequested(
                            deveui: deveui,
                            chunkIndex: preset.chunkIndex,
                          ),
                        ),
              ),
            );
          }(),
      ],
    );
  }
}
