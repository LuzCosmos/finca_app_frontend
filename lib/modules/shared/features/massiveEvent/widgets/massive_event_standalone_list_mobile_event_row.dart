import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final title = event.name?.isNotEmpty == true ? event.name! : event.id;
    if (!wide) {
      return ListTile(
        onTap: onTap,
        isThreeLine: true,
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '${l10n.massiveEventsColumnEventDate}: ${df.format(event.eventDate)}',
                  style: theme.textTheme.bodyMedium,
                ),
                MassiveEventListStatusChip(l10n: l10n, event: event),
              ],
            ),
            Text(
              '${l10n.massiveEventsColumnCreatedBy}: ${massiveEventListDisplayCreatedByUsername(event)}',
              style: small,
            ),
            Text(
              '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(event.createdAt)}',
              style: small,
            ),
            Text(
              '${l10n.massiveEventsColumnUpdatedAt}: ${dtf.format(event.updatedAt)}',
              style: small,
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
                  Text(
                    title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${l10n.massiveEventsColumnEventDate}: ${df.format(event.eventDate)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      MassiveEventListStatusChip(l10n: l10n, event: event),
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
                  Text(
                    '${l10n.massiveEventsColumnCreatedBy}: ${massiveEventListDisplayCreatedByUsername(event)}',
                    style: small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(event.createdAt)}',
                    style: small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                  Text(
                    dtf.format(event.updatedAt),
                    style: theme.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${l10n.massiveEventsColumnEventDate}: ${df.format(event.eventDate)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    MassiveEventListStatusChip(l10n: l10n, event: event),
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
                Text(
                  '${l10n.massiveEventsColumnCreatedBy}: ${massiveEventListDisplayCreatedByUsername(event)}',
                  style: small,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.massiveEventsColumnCreatedAt}: ${dtf.format(event.createdAt)}',
                  style: small,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.massiveEventsColumnUpdatedAt}: ${dtf.format(event.updatedAt)}',
                  style: small,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
