import 'package:flutter/material.dart';

import 'package:finca_app_frontend/l10n/app_localizations.dart';

/// Contenedor visual común para widgets de reporte (título, estados, reintento).
class ReportMetricCardShell extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;

  const ReportMetricCardShell({
    super.key,
    required this.title,
    required this.child,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (isLoading)
              const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (hasError)
              SizedBox(
                height: 160,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.reports_general_loadError,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (onRetry != null) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: onRetry,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              child,
          ],
        ),
      ),
    );
  }
}
