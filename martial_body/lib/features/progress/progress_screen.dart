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
import 'package:go_router/go_router.dart';

import '../../core/database/database.dart';
import '../../core/models/weekly_stats.dart';
import '../../core/program/phase_math.dart';
import '../../core/providers/analytics_provider.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/home_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/providers/records_provider.dart';
import '../../core/providers/units_provider.dart';
import '../../core/models/lift_entry.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/units.dart';
import 'widgets/recovery_chart.dart';
import 'widgets/shareable_dashboard.dart';

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
    final unit = ref.watch(unitSystemProvider);

    // Real calendar-derived current week (not "max week with a log"), so the
    // streak banner stays honest if the user takes a week off.
    final currentWeek = homeAsync.value?.weekNumber ?? 1;
    final sessionNamesById = sessionNamesAsync.valueOrNull ?? {};

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
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
                    unit: unit,
                  ),
                  data: (stats) => _ProgressBody(
                    logs: logs,
                    weeklyStats: stats,
                    currentWeek: currentWeek,
                    analyticsError: null,
                    sessionNamesById: sessionNamesById,
                    unit: unit,
                  ),
                ),
              ),
            ),
          ],
        ),
          ),
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
  final UnitSystem unit;

  const _ProgressBody({
    required this.logs,
    required this.weeklyStats,
    required this.currentWeek,
    required this.analyticsError,
    required this.sessionNamesById,
    required this.unit,
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
    final phaseSessionCount =
        currentPhase.lengthWeeks * currentPhase.sessionsPerWeek;
    final allSessions = weeklyStats.expand((w) => w.sessionStats).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        if (totalSessions > 0) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.gold.withAlpha(25),
                foregroundColor: context.appColors.gold,
              ),
              icon: const Icon(Icons.share, size: 20),
              label: const Text('EXPORT FIGHT CAMP DASHBOARD'),
              onPressed: () {
                final totalVolume = weeklyStats.fold<double>(0, (sum, ws) => sum + ws.totalVolumeKg);
                String rankName;
                switch (currentPhase.number) {
                  case 1: rankName = 'Rank I · Dormant Form'; break;
                  case 2: rankName = 'Rank II · Kinetic Awakened'; break;
                  case 3: rankName = 'Rank III · Somatic Apex'; break;
                  case 4: rankName = 'Rank IV · Absolute Synthesis'; break;
                  default: rankName = 'Rank I · Dormant Form';
                }
                ShareableDashboard.show(
                  context,
                  phaseNumber: currentPhase.number,
                  sessionsCompleted: totalSessions,
                  totalVolumeKg: totalVolume,
                  rankName: rankName,
                  unit: unit,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
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
            thisWeekCompleted: thisWeekCompleted,
            sessionsPerWeek: currentPhase.sessionsPerWeek),
        if (allSessions.isNotEmpty) ...[
          const SizedBox(height: 24),
          RecoveryChart(sessions: allSessions, unit: unit),
        ],
        if (analyticsError != null) ...[
          const SizedBox(height: 20),
          _AnalyticsErrorNote(message: analyticsError!),
        ],
        if (weeklyStats.length >= 2) ...[
          const SizedBox(height: 28),
          _SectionLabel('SESSIONS PER WEEK'),
          const SizedBox(height: 12),
          _SessionsBarChart(stats: weeklyStats),
          const SizedBox(height: 10),
          _sessionsTakeaway(context, weeklyStats),
          const SizedBox(height: 28),
          _SectionLabel('TOTAL VOLUME (${Units.weightUnit(unit)})'),
          const SizedBox(height: 12),
          _VolumeLineChart(stats: weeklyStats, unit: unit),
          const SizedBox(height: 10),
          _volumeTakeaway(context, weeklyStats),
        ],
        _BodyweightSection(unit: unit),
        _PersonalRecordsSection(unit: unit),
        const SizedBox(height: 28),
        if (logs.isNotEmpty) ...[
          _SectionLabel('SESSION HISTORY'),
          const SizedBox(height: 12),
          ...logs.map((l) => _HistoryTile(log: l, sessionName: sessionNamesById[l.sessionId])),
        ] else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.appColors.divider),
              ),
              child: Column(
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: SizedBox(
                      height: 100,
                      child: LineChart(
                        LineChartData(
                          minY: 0, maxY: 10,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [FlSpot(0, 2), FlSpot(1, 5), FlSpot(2, 4), FlSpot(3, 8), FlSpot(4, 7)],
                              isCurved: true,
                              color: context.appColors.gold,
                              barWidth: 4,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your data goes here',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: context.appColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete your first workout to start tracking your volume, sessions, and consistency.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.5, color: context.appColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColors.gold.withAlpha(25),
                        foregroundColor: context.appColors.gold,
                      ),
                      onPressed: () => context.go('/home'),
                      child: const Text('Go to Today\'s Workout'),
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

    return Semantics(
      container: true,
      label: 'Sessions completed per week chart. '
          'Most recent week: ${stats.last.sessionsCompleted} sessions.',
      child: _ChartCard(
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
    ),
    );
  }
}

class _VolumeLineChart extends StatelessWidget {
  final List<WeeklyStats> stats;
  final UnitSystem unit;
  const _VolumeLineChart({required this.stats, required this.unit});

  double _disp(double kg) =>
      unit == UnitSystem.imperial ? Units.kgToLb(kg) : kg;

  @override
  Widget build(BuildContext context) {
    final spots = stats.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), _disp(e.value.totalVolumeKg));
    }).toList();

    final maxY = stats
        .map((s) => _disp(s.totalVolumeKg))
        .reduce((a, b) => a > b ? a : b);
    final yMax = maxY <= 0 ? 100.0 : (maxY * 1.2);
    final unitLabel = Units.weightUnit(unit);

    return Semantics(
      container: true,
      label: 'Total training volume per week in $unitLabel. '
          'Most recent week: ${_disp(stats.last.totalVolumeKg).toStringAsFixed(0)} $unitLabel.',
      child: _ChartCard(
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
              barWidth: 3,
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appColors.phase1.withAlpha(60),
                    context.appColors.phase1.withAlpha(0),
                  ],
                ),
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
                  'Wk $wk\n${s.y.toStringAsFixed(0)} $unitLabel',
                  TextStyle(color: context.appColors.textPrimary, fontSize: 12),
                );
              }).toList(),
            ),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.appColors.textSecondary,
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),
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
  final int sessionsPerWeek;
  const _StreakBanner(
      {required this.currentWeek,
      required this.thisWeekCompleted,
      required this.sessionsPerWeek});

  @override
  Widget build(BuildContext context) {
    // "On track" = within two of the full week; "perfect" = every session.
    final onTrack = thisWeekCompleted >= (sessionsPerWeek - 2).clamp(1, sessionsPerWeek);
    final isPerfect = thisWeekCompleted >= sessionsPerWeek;
    // Never show a week number beyond the programme length.
    final displayWeek = currentWeek > 24 ? 24 : currentWeek;

    final flameColor = isPerfect 
        ? context.appColors.phase2 // Orange for hot streak
        : onTrack 
            ? context.appColors.gold 
            : context.appColors.textSecondary;
            
    final bgFlameColor = isPerfect 
        ? context.appColors.phase2.withAlpha(40)
        : onTrack 
            ? context.appColors.gold.withAlpha(40) 
            : context.appColors.surfaceVariant;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
        boxShadow: isPerfect ? [
          BoxShadow(
            color: context.appColors.phase2.withAlpha(30),
            blurRadius: 20,
            spreadRadius: -5,
          )
        ] : [],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgFlameColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_fire_department,
                color: flameColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPerfect ? 'Week $displayWeek Flawless' : onTrack
                    ? 'Week $displayWeek On Track'
                    : 'Week $displayWeek — Keep Going',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '$thisWeekCompleted of $sessionsPerWeek sessions this week',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
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
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
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
                    if (log.rpe != null) ...[
                      const SizedBox(width: 8),
                      Text('·',
                          style:
                              TextStyle(color: context.appColors.textSecondary)),
                      const SizedBox(width: 8),
                      Icon(Icons.bolt, size: 12, color: context.appColors.gold),
                      const SizedBox(width: 2),
                      Text('RPE ${log.rpe}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.appColors.gold, fontWeight: FontWeight.bold)),
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

// ---------------------------------------------------------------------------
// Plain-language chart takeaways
// ---------------------------------------------------------------------------

Widget _sessionsTakeaway(BuildContext context, List<WeeklyStats> stats) {
  final last = stats.last.sessionsCompleted;
  final prev = stats[stats.length - 2].sessionsCompleted;
  final diff = last - prev;
  final String text;
  final IconData icon;
  final Color color;
  if (diff > 0) {
    text = '$last sessions this week — $diff more than last.';
    icon = Icons.trending_up;
    color = context.appColors.phase1;
  } else if (diff < 0) {
    text = '$last sessions this week — ${diff.abs()} fewer than last.';
    icon = Icons.trending_down;
    color = context.appColors.deload;
  } else {
    text = '$last sessions this week — same as last.';
    icon = Icons.trending_flat;
    color = context.appColors.textSecondary;
  }
  return _ChartTakeaway(text: text, icon: icon, color: color);
}

Widget _volumeTakeaway(BuildContext context, List<WeeklyStats> stats) {
  final last = stats.last.totalVolumeKg;
  final prev = stats[stats.length - 2].totalVolumeKg;
  if (prev <= 0) {
    return _ChartTakeaway(
      text: 'Volume is building — keep logging your sets.',
      icon: Icons.trending_up,
      color: context.appColors.phase1,
    );
  }
  final pct = ((last - prev) / prev * 100).round();
  final String text;
  final IconData icon;
  final Color color;
  if (pct >= 3) {
    text = 'Volume up $pct% vs last week.';
    icon = Icons.trending_up;
    color = context.appColors.phase1;
  } else if (pct <= -3) {
    text = 'Volume down ${pct.abs()}% vs last week.';
    icon = Icons.trending_down;
    color = context.appColors.deload;
  } else {
    text = 'Volume held steady vs last week.';
    icon = Icons.trending_flat;
    color = context.appColors.textSecondary;
  }
  return _ChartTakeaway(text: text, icon: icon, color: color);
}

class _ChartTakeaway extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _ChartTakeaway(
      {required this.text, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Bodyweight trend
// ---------------------------------------------------------------------------

class _BodyweightSection extends ConsumerWidget {
  final UnitSystem unit;
  const _BodyweightSection({required this.unit});

  double _disp(double kg) =>
      unit == UnitSystem.imperial ? Units.kgToLb(kg) : kg;

  Future<void> _logWeight(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: Text('Log bodyweight',
            style: TextStyle(color: context.appColors.textPrimary)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: context.appColors.textPrimary),
          decoration: InputDecoration(
            hintText: unit == UnitSystem.imperial ? 'e.g. 165 lb' : 'e.g. 75 kg',
            hintStyle: TextStyle(color: context.appColors.textSecondary),
            border: const OutlineInputBorder(),
            suffixText: Units.weightUnit(unit),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(double.tryParse(ctrl.text)),
            style: TextButton.styleFrom(foregroundColor: context.appColors.gold),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (value == null) return;
    await ref
        .read(databaseProvider)
        .userDao
        .upsertTodayWeight(Units.toKg(value, unit));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weights = ref.watch(bodyweightProvider).valueOrNull ?? [];
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.appColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'BODYWEIGHT',
                  style: tt.labelSmall?.copyWith(
                    color: context.appColors.textSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _logWeight(context, ref),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Log'),
                  style: TextButton.styleFrom(
                    foregroundColor: context.appColors.gold,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
            if (weights.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Log your weight to track changes over time.',
                  style: tt.bodySmall
                      ?.copyWith(color: context.appColors.textSecondary),
                ),
              )
            else ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Units.weight(weights.last.weightKg, unit),
                    style: tt.headlineSmall?.copyWith(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (weights.length >= 2)
                    Builder(builder: (_) {
                      final delta =
                          weights.last.weightKg - weights.first.weightKg;
                      final up = delta >= 0;
                      final color = context.appColors.textSecondary;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${up ? '+' : '−'}${Units.weight(delta.abs(), unit)} since start',
                          style: tt.bodySmall?.copyWith(color: color),
                        ),
                      );
                    }),
                ],
              ),
              if (weights.length >= 2) ...[
                const SizedBox(height: 14),
                SizedBox(
                  height: 70,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            for (var i = 0; i < weights.length; i++)
                              FlSpot(i.toDouble(), _disp(weights[i].weightKg)),
                          ],
                          isCurved: true,
                          curveSmoothness: 0.3,
                          color: context.appColors.phase4,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: context.appColors.phase4.withAlpha(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Personal records + per-exercise progression
// ---------------------------------------------------------------------------

class _PersonalRecordsSection extends ConsumerWidget {
  final UnitSystem unit;
  const _PersonalRecordsSection({required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prs = ref.watch(personalRecordsProvider).valueOrNull ?? [];
    if (prs.isEmpty) return const SizedBox.shrink();
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Text(
          'PERSONAL RECORDS',
          style: tt.labelSmall?.copyWith(
            color: context.appColors.textSecondary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...prs.map((pr) => _PrTile(pr: pr, unit: unit)),
      ],
    );
  }
}

class _PrTile extends StatelessWidget {
  final ExercisePr pr;
  final UnitSystem unit;
  const _PrTile({required this.pr, required this.unit});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            backgroundColor: context.appColors.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => _ProgressionSheet(pr: pr, unit: unit),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 20, color: context.appColors.gold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pr.name,
                        style: tt.bodyMedium?.copyWith(
                          color: context.appColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Best e1RM ${Units.weight(pr.bestE1rmKg, unit)}',
                        style: tt.labelSmall
                            ?.copyWith(color: context.appColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${Units.weight(pr.maxWeightKg, unit)} × ${pr.repsAtMax}',
                  style: tt.bodyMedium?.copyWith(
                    color: context.appColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right,
                    size: 18, color: context.appColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressionSheet extends ConsumerWidget {
  final ExercisePr pr;
  final UnitSystem unit;
  const _ProgressionSheet({required this.pr, required this.unit});

  double _disp(double kg) =>
      unit == UnitSystem.imperial ? Units.kgToLb(kg) : kg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points =
        ref.watch(exerciseProgressionProvider(pr.exerciseId)).valueOrNull ?? [];
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.appColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pr.name,
            style: tt.titleLarge?.copyWith(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Best: ${Units.weight(pr.maxWeightKg, unit)} × ${pr.repsAtMax}  ·  '
            'e1RM ${Units.weight(pr.bestE1rmKg, unit)}',
            style: tt.bodySmall?.copyWith(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (points.length < 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Log this exercise on more days to see your progression.',
                  textAlign: TextAlign.center,
                  style: tt.bodySmall
                      ?.copyWith(color: context.appColors.textSecondary),
                ),
              ),
            )
          else
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
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
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, m) => Text(
                          v.toInt().toString(),
                          style: TextStyle(
                              color: context.appColors.textSecondary,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < points.length; i++)
                          FlSpot(i.toDouble(), _disp(points[i].weightKg)),
                      ],
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: context.appColors.gold,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) =>
                            FlDotCirclePainter(
                          radius: 3,
                          color: context.appColors.gold,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: context.appColors.gold.withAlpha(25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
