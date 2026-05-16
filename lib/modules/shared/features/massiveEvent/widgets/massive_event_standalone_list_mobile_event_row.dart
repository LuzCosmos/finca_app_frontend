import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/massive_event_standalone_list_column_limits.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_list_row_widgets.dart';
import 'package:intl/intl.dart';

/// Una fila del listado autónomo en **móvil**: compacta o multi-columna según [wide] / [extraWide].
class MassiveEventStandaloneListMobileEventRow extends StatelessWidget {
  const MassiveEventStandaloneListMobileEventRow({
    super.key,
    required this.l10n,
    required this.event,
    required this.theme,
    required this.small,
    required this.df,
    required this.dtf,
    required this.wide,
    required this.extraWide,
    this.onTap,
    this.onEditOpen,
  });

  final AppLocalizations l10n;
  final MassiveEventModel event;
  final ThemeData theme;
  final TextStyle? small;
  final DateFormat df;
  final DateFormat dtf;
  final bool wide;
  final bool extraWide;
  final VoidCallback? onTap;
  /// Editar masivo abierto (misma ruta que creación con `?id=`).
  final VoidCallback? onEditOpen;

  @override
  Widget build(BuildContext context) {
    final title = event.name?.isNotEmpty == true ? event.name! : event.id;
    if (!wide) {
      return ListTile(
        onTap: onTap,
        isThreeLine: true,
        trailing:
            onEditOpen != null
                ? IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 22,
                    color: Colors.blue.shade700,
                  ),
                  tooltip: l10n.massiveEventsEdit,
                  onPressed: onEditOpen,
                )
                : null,
        title: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: MassiveEventStandaloneListColumnLimits.mobileTitleMax,
          ),
          child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth:
                        MassiveEventStandaloneListColumnLimits.mobileEventDateLineMax,
                  ),
                  child: Text(
                    '${l10n.massiveEventsColumnEventDate}: ${df.format(event.eventDate)}',
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                MassiveEventListStatusChip(
                  l10n: l10n,
                  event: event,
                  maxWidth:
                      MassiveEventStandaloneListColumnLimits.statusMax,
                ),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth:
                    MassiveEventStandaloneListColumnLimits.mobileCreatedByLineMax,
              ),
              child: Text(
                '${l10n.massiveEventsColumnCreatedBy}: ${massiveEventListDisplayCreatedByUsername(event)}',
                style: small,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth:
                    MassiveEventStandaloneListColumnLimits.mobileDateTimeLineMax,
              ),
              child: Text(
                '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(event.createdAt)}',
                style: small,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth:
                    MassiveEventStandaloneListColumnLimits.mobileDateTimeLineMax,
              ),
              child: Text(
                '${l10n.massiveEventsColumnUpdatedAt}: ${dtf.format(event.updatedAt)}',
                style: small,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (extraWide) {
      return InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth:
                          MassiveEventStandaloneListColumnLimits.mobileTitleMax,
                    ),
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth:
                              MassiveEventStandaloneListColumnLimits.mobileEventDateLineMax,
                        ),
                        child: Text(
                          '${l10n.massiveEventsColumnEventDate}: ${df.format(event.eventDate)}',
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      MassiveEventListStatusChip(
                        l10n: l10n,
                        event: event,
                        maxWidth:
                            MassiveEventStandaloneListColumnLimits.statusMax,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth:
                          MassiveEventStandaloneListColumnLimits.mobileCreatedByLineMax,
                    ),
                    child: Text(
                      '${l10n.massiveEventsColumnCreatedBy}: ${massiveEventListDisplayCreatedByUsername(event)}',
                      style: small,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth:
                          MassiveEventStandaloneListColumnLimits.mobileDateTimeLineMax,
                    ),
                    child: Text(
                      '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(event.createdAt)}',
                      style: small,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.massiveEventsColumnUpdatedAt,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth:
                          MassiveEventStandaloneListColumnLimits.mobileDateTimeLineMax,
                    ),
                    child: Text(
                      dtf.format(event.updatedAt),
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (onEditOpen != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue.shade700,
                ),
                tooltip: l10n.massiveEventsEdit,
                onPressed: onEditOpen,
              ),
          ],
        ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth:
                        MassiveEventStandaloneListColumnLimits.mobileTitleMax,
                  ),
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth:
                            MassiveEventStandaloneListColumnLimits.mobileEventDateLineMax,
                      ),
                      child: Text(
                        '${l10n.massiveEventsColumnEventDate}: ${df.format(event.eventDate)}',
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MassiveEventListStatusChip(
                      l10n: l10n,
                      event: event,
                      maxWidth:
                          MassiveEventStandaloneListColumnLimits.statusMax,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth:
                        MassiveEventStandaloneListColumnLimits.mobileCreatedByLineMax,
                  ),
                  child: Text(
                    '${l10n.massiveEventsColumnCreatedBy}: ${massiveEventListDisplayCreatedByUsername(event)}',
                    style: small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth:
                        MassiveEventStandaloneListColumnLimits.mobileDateTimeLineMax,
                  ),
                  child: Text(
                    '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(event.createdAt)}',
                    style: small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth:
                        MassiveEventStandaloneListColumnLimits.mobileDateTimeLineMax,
                  ),
                  child: Text(
                    '${l10n.massiveEventsColumnUpdatedAt}: ${dtf.format(event.updatedAt)}',
                    style: small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (onEditOpen != null)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blue.shade700,
              ),
              tooltip: l10n.massiveEventsEdit,
              onPressed: onEditOpen,
            ),
        ],
      ),
      ),
    );
  }
}
