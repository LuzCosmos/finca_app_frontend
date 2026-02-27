import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finca_app_frontend/core/utils/date_time_helper.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/services/cattle_master_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle/widgets/add_medication_dialog.dart';

class WeightHistoryDialog extends StatelessWidget {
  final List<dynamic> history;
  final String cattleNumber;
  /// Textos pasados desde el padre para evitar que el overlay no tenga localizaciones y falle el build.
  final String noDataMessage;
  final String closeLabel;
  final String weightHistoryLabel;

  const WeightHistoryDialog({
    super.key,
    required this.history,
    required this.cattleNumber,
    required this.noDataMessage,
    required this.closeLabel,
    required this.weightHistoryLabel,
  });

  List<({DateTime date, double weight})> _parseAndSortHistory() {
    final list = <({DateTime date, double weight})>[];
    final safeHistory = history;
    if (safeHistory.isEmpty) return list;
    for (final item in safeHistory) {
      final date = DateTimeHelper.parseToLocal(item['date']);
      final w = item['weight'];
      if (date == null) continue;
      final weight = w is num ? w.toDouble() : (double.tryParse(w?.toString() ?? '') ?? 0);
      list.add((date: date, weight: weight));
    }
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final sorted = _parseAndSortHistory();
    final hasData = sorted.isNotEmpty;

    final Widget bodyContent;
    if (hasData) {
      final spots = <FlSpot>[];
      for (var i = 0; i < sorted.length; i++) {
        spots.add(FlSpot(i.toDouble(), sorted[i].weight));
      }
      final minY = sorted.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
      final maxY = sorted.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
      final rangeY = maxY - minY;
      final paddingY = (rangeY * 0.1).clamp(2.0, 20.0);
      final chartMinY = (minY - paddingY).clamp(0.0, double.infinity);
      final chartMaxY = rangeY > 0 ? maxY + paddingY : maxY + 5;
      final maxX = sorted.length <= 1 ? 1.0 : (sorted.length - 1).toDouble();

      final lineData = LineChartData(
        minX: 0,
        maxX: maxX,
        minY: chartMinY,
        maxY: chartMaxY,
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.shade300, strokeWidth: 0.5)),
        borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: Colors.grey.shade400), left: BorderSide(color: Colors.grey.shade400))),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= sorted.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateTimeHelper.formatLocalDate(sorted[i].date, fallback: ''),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 9),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: theme.colorScheme.primary.withValues(alpha: 0.15)),
          ),
        ],
      );

      bodyContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            l10n?.weightKg ?? 'Peso (kg)',
            style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: LineChart(lineData, duration: const Duration(milliseconds: 250)),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (ctx, i) {
                final e = sorted[i];
                return ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: Icon(Icons.show_chart, size: 18, color: theme.colorScheme.primary),
                  title: Text('${e.weight.toStringAsFixed(1)} kg — ${DateTimeHelper.formatLocalDate(e.date, fallback: '')}'),
                );
              },
            ),
          ),
        ],
      );
    } else {
      bodyContent = Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              noDataMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      title: Text('#$cattleNumber - $weightHistoryLabel'),
      content: SizedBox(
        width: 520,
        height: 420,
        child: bodyContent,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(closeLabel),
        ),
      ],
    );
  }
}



class MedicationHistoryDialog extends StatefulWidget {
  final String cattleId;
  final String cattleNumber;
  final List<dynamic> history;
  final CattleMasterService service;

  const MedicationHistoryDialog({
    super.key,
    required this.cattleId,
    required this.cattleNumber,
    required this.history,
    required this.service,
    this.onAdded,
  });
  
  final Function(Map<String, dynamic>)? onAdded;

  @override
  State<MedicationHistoryDialog> createState() => _MedicationHistoryDialogState();
}

class _MedicationHistoryDialogState extends State<MedicationHistoryDialog> {
  late List<dynamic> _history;

  @override
  void initState() {
    super.initState();
    _history = List.from(widget.history);
  }

  Future<void> _addMedication() async {
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AddMedicationDialog(
        onSave: (data) async {
          final newRecord = await widget.service.addMedication(widget.cattleId, data);
          if (newRecord != null) {
            widget.onAdded?.call(newRecord);
            setState(() {
              _history.insert(0, newRecord);
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('#${widget.cattleNumber} - ${l10n.medicationHistory}'),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.addSomething(l10n.medication),
            onPressed: _addMedication,
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: _history.isEmpty 
          ? Center(child: Text(l10n.noData)) 
          : ListView.separated(
              itemCount: _history.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (ctx, i) {
                final item = _history[i];
                final dateStr = DateTimeHelper.formatLocalDateTime(
                  item['appliedAt'],
                );
                final product = item['medicationName'] ?? '-';
                final dosage = item['dosage'] ?? '-';
                final route = item['route'] ?? '-';
                
                return ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const Icon(Icons.vaccines_outlined),
                  title: Text('$dateStr: $product'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l10n.dosage}: $dosage - ${l10n.route}: $route'),
                      //Text('$dateStr - ${l10n.appliedBy}: $appliedBy'),
                    ],
                  ),
                );
              },
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_history),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
