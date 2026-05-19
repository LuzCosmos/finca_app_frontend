import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/widgets/massive_event_list_row_widgets.dart';
import 'package:intl/intl.dart';

/// Detalle solo lectura de un evento masivo (listado autónomo móvil).
Future<void> showMassiveEventStandaloneReadOnlyDetail(
  BuildContext context, {
  required AppLocalizations l10n,
  required MassiveEventModel event,
}) async {
  final locale = Localizations.localeOf(context).toString();
  final df = DateFormat.yMMMd(locale).add_Hm();
  final title = event.name?.isNotEmpty == true ? event.name! : event.id;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _detailRow(
                  theme,
                  l10n.massiveEventsColumnEventDate,
                  df.format(event.eventDate),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.status}: ',
                      style: theme.textTheme.labelLarge,
                    ),
                    MassiveEventListStatusChip(l10n: l10n, event: event),
                  ],
                ),
                const SizedBox(height: 8),
                _detailRow(
                  theme,
                  l10n.massiveEventsColumnCreatedBy,
                  massiveEventListDisplayCreatedByUsername(event),
                ),
                const SizedBox(height: 8),
                _detailRow(
                  theme,
                  l10n.massiveEventsColumnCreatedAt,
                  df.format(event.createdAt),
                ),
                const SizedBox(height: 8),
                _detailRow(
                  theme,
                  l10n.massiveEventsColumnUpdatedAt,
                  df.format(event.updatedAt),
                ),
                const SizedBox(height: 8),
                _detailRow(
                  theme,
                  l10n.massiveEventsDetailInternalId,
                  event.id,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _detailRow(ThemeData theme, String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 4),
      SelectableText(value, style: theme.textTheme.bodyLarge),
    ],
  );
}
