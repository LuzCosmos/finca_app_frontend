import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Vacío de lista autónoma (sin filas): mismos textos y CTA en móvil y web (D7).
class MassiveEventStandaloneListEmptyState extends StatelessWidget {
  const MassiveEventStandaloneListEmptyState({
    super.key,
    required this.l10n,
    required this.hasActiveFilters,
    required this.canCreate,
    required this.onClearFilters,
    required this.onCreateMassiveEvent,
    this.inboxIconSize = 72,
    this.scrollable = false,
    this.scrollPadding = const EdgeInsets.all(24),
  });

  final AppLocalizations l10n;
  final bool hasActiveFilters;
  final bool canCreate;
  final VoidCallback onClearFilters;
  final VoidCallback onCreateMassiveEvent;
  final double inboxIconSize;
  final bool scrollable;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[
      Icon(
        Icons.inbox,
        size: inboxIconSize,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      const SizedBox(height: 16),
      Text(
        hasActiveFilters
            ? l10n.noDataFiltered(l10n.massiveEvents)
            : l10n.noDataSomething(l10n.massiveEvents),
        style: theme.textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Text(
        hasActiveFilters
            ? l10n.tryAdjustFilters
            : l10n.massiveEvents_createFirstEvent,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      ElevatedButton.icon(
        onPressed:
            hasActiveFilters
                ? onClearFilters
                : (canCreate ? onCreateMassiveEvent : null),
        icon: Icon(hasActiveFilters ? Icons.clear : Icons.add),
        label: Text(
          hasActiveFilters
              ? l10n.clearFilters
              : l10n.addSomething(l10n.massiveEvent),
        ),
      ),
    ];

    final column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    if (scrollable) {
      return Center(
        child: SingleChildScrollView(
          padding: scrollPadding,
          child: column,
        ),
      );
    }
    return Center(child: column);
  }
}

/// Sin permiso de listado con permiso de creación (mismo layout móvil/web; D7).
class MassiveEventStandaloneListNoListPermissionView extends StatelessWidget {
  const MassiveEventStandaloneListNoListPermissionView({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.massiveEventsNoListPermission,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Error genérico de carga de lista (sin detalle de API; D7).
class MassiveEventStandaloneListGenericLoadErrorView extends StatelessWidget {
  const MassiveEventStandaloneListGenericLoadErrorView({
    super.key,
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(l10n.massiveEventsListLoadError));
  }
}
