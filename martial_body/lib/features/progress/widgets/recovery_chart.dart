import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/models/weekly_stats.dart';
import '../../../core/providers/units_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/units.dart';

class RecoveryChart extends StatelessWidget {
  final List<SessionStats> sessions;
  final UnitSystem unit;

  const RecoveryChart({super.key, required this.sessions, required this.unit});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const SizedBox.shrink();
    }

    final validRpe = sessions.where((s) => s.rpe != null).toList();
    final validSleep = sessions.where((s) => s.sleepHours != null).toList();
    final validVolume = sessions.where((s) => s.volumeKg > 0).toList();

    return Semantics(
      container: true,
      label: 'Recovery mapping. Trends for training volume, sleep hours, and '
          'perceived exertion across your logged sessions.',
      child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RECOVERY MAPPING',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.appColors.textSecondary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          if (validVolume.isNotEmpty) ...[
            _ChartSection(
              title: 'Volume (${Units.weightUnit(unit)})',
              color: context.appColors.phase3,
              data: sessions
                  .map((s) => unit == UnitSystem.imperial
                      ? Units.kgToLb(s.volumeKg)
                      : s.volumeKg)
                  .toList(),
              minY: 0,
            ),
            const SizedBox(height: 24),
          ],
          if (validSleep.isNotEmpty) ...[
            _ChartSection(
              title: 'Sleep (hrs)',
              color: context.appColors.phase2,
              data: sessions.map((s) => s.sleepHours ?? 0).toList(),
              minY: 0,
            ),
            const SizedBox(height: 24),
          ],
          if (validRpe.isNotEmpty) ...[
            _ChartSection(
              title: 'Exertion (RPE)',
              color: context.appColors.gold,
              data: sessions.map((s) => s.rpe?.toDouble() ?? 0).toList(),
              minY: 0,
              maxY: 10,
            ),
          ],
        ],
      ),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<double> data;
  final double minY;
  final double? maxY;

  const _ChartSection({
    required this.title,
    required this.color,
    required this.data,
    required this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }

    final computedMaxY = maxY ?? (data.reduce((a, b) => a > b ? a : b) * 1.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              data.last.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (data.length - 1).toDouble(),
              minY: minY,
              maxY: computedMaxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    // Only mark the latest point so the line reads as a trend,
                    // not a busy scatter.
                    checkToShowDot: (spot, barData) =>
                        spot.x == (data.length - 1).toDouble(),
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3.5,
                        color: color,
                        strokeWidth: 2,
                        strokeColor: context.appColors.surface,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color.withAlpha(70), color.withAlpha(0)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
