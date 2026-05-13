// Martial Body — 24-week MMA preparation trainer
// Copyright (C) 2026 Robin Roy <robinroy3107@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/models/weekly_stats.dart';
import '../../core/program/phase_math.dart';
import '../../core/providers/analytics_provider.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/home_provider.dart';
import '../../core/providers/progress_provider.dart';
import 'package:martial_body/core/theme/app_colors.dart';

final _sessionNamesByIdProvider = FutureProvider<Map<int, String>>((ref) async {
  final db = ref.watch(databaseProvider);
  final allSessions = await db.programDao.getAllSessions();
  return {for (final s in allSessions) s.id: s.name};
});

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(progressProvider);
    final analyticsAsync = ref.watch(analyticsProvider);
    final homeAsync = ref.watch(homeProvider);
    final sessionNamesAsync = ref.watch(_sessionNamesByIdProvider);

    // Real calendar-derived current week (not "max week with a log"), so the
    // streak banner stays honest if the user takes a week off.
    final currentWeek = homeAsync.value?.weekNumber ?? 1;
    final sessionNamesById = sessionNamesAsync.valueOrNull ?? {};

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Expanded(
              child: logsAsync.when(
                loading: () => Center(
                    child: CircularProgressIndicator(color: context.appColors.gold)),
                error: (e, _) => Center(
                    child: Text('Error: $e',
                        style:
                            TextStyle(color: context.appColors.textSecondary))),
                data: (logs) => analyticsAsync.when(
                  loading: () => Center(
                      child:
                          CircularProgressIndicator(color: context.appColors.gold)),
                  error: (e, _) => _ProgressBody(
                    logs: logs,
                    weeklyStats: const [],
                    currentWeek: currentWeek,
                    analyticsError: '$e',
                    sessionNamesById: sessionNamesById,
                  ),
                  data: (stats) => _ProgressBody(
                    logs: logs,
                    weeklyStats: stats,
                    currentWeek: currentWeek,
                    analyticsError: null,
                    sessionNamesById: sessionNamesById,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ProgressBody extends StatelessWidget {
  final List<WorkoutLog> logs;
  final List<WeeklyStats> weeklyStats;
  final int currentWeek;
  final String? analyticsError;
  final Map<int, String> sessionNamesById;

  const _ProgressBody({
    required this.logs,
    required this.weeklyStats,
    required this.currentWeek,
    required this.analyticsError,
    required this.sessionNamesById,
  });

  @override
  Widget build(BuildContext context) {
    final completed = logs.where((l) => l.completed).toList();
    final totalSessions = completed.length;
    final weekNumbers = logs.map((l) => l.weekNumber).toSet();
    final thisWeekCompleted =
        completed.where((l) => l.weekNumber == currentWeek).length;
    final weeksWithSessions = weekNumbers.length;
    final currentPhase = phaseForWeek(currentWeek);
    final phaseLogs = completed
        .where((l) => l.phaseNumber == currentPhase.number)
        .length;
    final phaseSessionCount = currentPhase.lengthWeeks * 5;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        _StatsRow(
          totalSessions: totalSessions,
          weeksActive: weeksWithSessions,
          thisWeekCompleted: thisWeekCompleted,
        ),
        const SizedBox(height: 24),
        _PhaseProgressBar(
          phase: currentPhase,
          completedInPhase: phaseLogs,
          totalInPhase: phaseSessionCount,
        ),
        const SizedBox(height: 24),
        _StreakBanner(
            currentWeek: currentWeek,
            thisWeekCompleted: thisWeekCompleted),
        if (analyticsError != null) ...[
          const SizedBox(height: 20),
          _AnalyticsErrorNote(message: analyticsError!),
        ],
        if (weeklyStats.length >= 2) ...[
          const SizedBox(height: 28),
          _SectionLabel('SESSIONS PER WEEK'),
          const SizedBox(height: 12),
          _SessionsBarChart(stats: weeklyStats),
          const SizedBox(height: 28),
          _SectionLabel('TOTAL VOLUME (kg)'),
          const SizedBox(height: 12),
          _VolumeLineChart(stats: weeklyStats),
        ],
        const SizedBox(height: 28),
        if (logs.isNotEmpty) ...[
          _SectionLabel('SESSION HISTORY'),
          const SizedBox(height: 12),
          ...logs.map((l) => _HistoryTile(log: l, sessionName: sessionNamesById[l.sessionId])),
        ] else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.fitness_center_outlined,
                      color: context.appColors.textSecondary, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No sessions logged yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.appColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete a workout from the Home tab\nto start tracking your progress.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Charts
// ---------------------------------------------------------------------------

class _SessionsBarChart extends StatelessWidget {
  final List<WeeklyStats> stats;
  const _SessionsBarChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final maxY = stats
        .map((s) => s.sessionsCompleted.toDouble())
        .reduce((a, b) => a > b ? a : b)
        .ceilToDouble()
        .clamp(1.0, 7.0);

    final barGroups = stats.asMap().entries.map((e) {
      final i = e.key;
      final s = e.value;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: s.sessionsCompleted.toDouble(),
            color: context.appColors.phase1,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 5,
              color: context.appColors.surfaceVariant,
            ),
          ),
        ],
      );
    }).toList();

    return _ChartCard(
      child: BarChart(
        BarChartData(
          maxY: maxY + 1,
          barGroups: barGroups,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (_) => FlLine(
              color: context.appColors.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (v, m) => v % 1 == 0
                    ? Text('${v.toInt()}',
                        style: TextStyle(
                            color: context.appColors.textSecondary, fontSize: 10))
                    : const SizedBox.shrink(),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (v, m) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= stats.length) {
                    return const SizedBox.shrink();
                  }
                  return Text('Wk ${stats[idx].weekNumber}',
                      style: TextStyle(
                          color: context.appColors.textSecondary, fontSize: 9));
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => context.appColors.surface,
              getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                '${rod.toY.toInt()} sessions',
                TextStyle(color: context.appColors.textPrimary, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VolumeLineChart extends StatelessWidget {
  final List<WeeklyStats> stats;
  const _VolumeLineChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final spots = stats.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.totalVolumeKg);
    }).toList();

    final maxY = stats
        .map((s) => s.totalVolumeKg)
        .reduce((a, b) => a > b ? a : b);
    final yMax = maxY <= 0 ? 100.0 : (maxY * 1.2);

    return _ChartCard(
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: yMax,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: context.appColors.phase1,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 4,
                  color: context.appColors.phase1,
                  strokeWidth: 1.5,
                  strokeColor: context.appColors.background,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: context.appColors.phase1Muted,
              ),
            ),
          ],
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: context.appColors.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, m) {
                  if (v == 0) return const SizedBox.shrink();
                  final label = v >= 1000
                      ? '${(v / 1000).toStringAsFixed(1)}k'
                      : v.toInt().toString();
                  return Text(label,
                      style: TextStyle(
                          color: context.appColors.textSecondary, fontSize: 10));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (v, m) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= stats.length || v != v.roundToDouble()) {
                    return const SizedBox.shrink();
                  }
                  return Text('Wk ${stats[idx].weekNumber}',
                      style: TextStyle(
                          color: context.appColors.textSecondary, fontSize: 9));
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => context.appColors.surface,
              getTooltipItems: (spots) => spots.map((s) {
                final idx = s.x.toInt();
                final wk = idx < stats.length ? stats[idx].weekNumber : idx + 1;
                return LineTooltipItem(
                  'Wk $wk\n${s.y.toStringAsFixed(0)} kg',
                  TextStyle(color: context.appColors.textPrimary, fontSize: 12),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: context.appColors.textSecondary,
            letterSpacing: 1.5,
          ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat cards
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  final int totalSessions;
  final int weeksActive;
  final int thisWeekCompleted;

  const _StatsRow({
    required this.totalSessions,
    required this.weeksActive,
    required this.thisWeekCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(value: '$totalSessions', label: 'Sessions\nCompleted'),
        const SizedBox(width: 12),
        _StatCard(value: '$weeksActive', label: 'Weeks\nActive'),
        const SizedBox(width: 12),
        _StatCard(value: '$thisWeekCompleted', label: 'This\nWeek'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: context.appColors.phase1,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.appColors.textSecondary,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _PhaseProgressBar extends StatelessWidget {
  final PhaseInfo phase;
  final int completedInPhase;
  final int totalInPhase;

  const _PhaseProgressBar({
    required this.phase,
    required this.completedInPhase,
    required this.totalInPhase,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.phaseColor(phase.number);
    final muted = context.appColors.phaseMutedColor(phase.number);
    final progress =
        totalInPhase == 0 ? 0.0 : (completedInPhase / totalInPhase).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: muted,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PHASE ${phase.number}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const Spacer(),
              Text(
                '$completedInPhase / $totalInPhase sessions',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.appColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${phase.name} — Weeks ${phase.startWeek}–${phase.endWeek}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${(progress * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsErrorNote extends StatelessWidget {
  final String message;
  const _AnalyticsErrorNote({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.deload.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16, color: context.appColors.deload),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Charts unavailable: $message',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _StreakBanner extends StatelessWidget {
  final int currentWeek;
  final int thisWeekCompleted;
  const _StreakBanner(
      {required this.currentWeek, required this.thisWeekCompleted});

  @override
  Widget build(BuildContext context) {
    final onTrack = thisWeekCompleted >= 3;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.appColors.deloadMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_fire_department,
                color: context.appColors.deload, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                onTrack
                    ? 'Week $currentWeek On Track'
                    : 'Week $currentWeek — Keep Going',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '$thisWeekCompleted of 5 sessions this week',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Text(
        'Progress',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _HistoryTile extends StatelessWidget {
  final WorkoutLog log;
  final String? sessionName;
  const _HistoryTile({required this.log, this.sessionName});

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(log.date);
    final duration = log.completedAt != null && log.startedAt != null
        ? log.completedAt!.difference(log.startedAt!).inMinutes
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: log.completed
                  ? context.appColors.phase1Muted
                  : context.appColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              log.completed
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              color:
                  log.completed ? context.appColors.phase1 : context.appColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionName ?? 'Week ${log.weekNumber} · Phase ${log.phaseNumber}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(dateStr,
                        style: Theme.of(context).textTheme.bodySmall),
                    if (duration != null) ...[
                      const SizedBox(width: 8),
                      Text('·',
                          style:
                              TextStyle(color: context.appColors.textSecondary)),
                      const SizedBox(width: 8),
                      Text('$duration min',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            log.completed ? 'Done' : 'In progress',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: log.completed
                      ? context.appColors.phase1
                      : context.appColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}
