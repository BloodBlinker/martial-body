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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/achievement.dart';
import '../../core/program/phase_math.dart';
import '../../core/providers/journey_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dimensions.dart';

const _rankRoman = ['I', 'II', 'III', 'IV'];
const _rankNames = [
  'Dormant Form',
  'Kinetic Awakened',
  'Somatic Apex',
  'Absolute Synthesis',
];

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(journeyProvider);
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: context.appColors.textPrimary),
                        tooltip: 'Back',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go('/home'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your Journey',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: async.when(
                    loading: () => Center(
                        child: CircularProgressIndicator(
                            color: context.appColors.gold)),
                    error: (e, _) => Center(
                        child: Text('Error: $e',
                            style: TextStyle(
                                color: context.appColors.textSecondary))),
                    data: (j) => _JourneyBody(j: j),
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

class _JourneyBody extends StatelessWidget {
  final JourneyState j;
  const _JourneyBody({required this.j});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        _MomentumCard(j: j),
        const SizedBox(height: AppSpacing.xxl),
        _SectionLabel('THE PATH'),
        const SizedBox(height: AppSpacing.lg),
        ...List.generate(kPhases.length, (i) {
          final p = kPhases[i];
          return _PhaseNode(
            phase: p,
            j: j,
            isLast: false,
          );
        }),
        _GraduationNode(j: j),
        const SizedBox(height: AppSpacing.xxl),
        _SectionLabel('ACHIEVEMENTS'),
        const SizedBox(height: AppSpacing.lg),
        _AchievementsGrid(unlocked: j.unlocked),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _MomentumCard extends StatelessWidget {
  final JourneyState j;
  const _MomentumCard({required this.j});

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.gold;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: AppRadius.cardR,
        border: Border.all(color: gold.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                j.programComplete ? 'Complete' : 'Week ${j.currentWeek}',
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              if (!j.programComplete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('of 24',
                      style: tt.bodySmall
                          ?.copyWith(color: context.appColors.textSecondary)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: j.fractionComplete,
              minHeight: 8,
              backgroundColor: context.appColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(gold),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _Stat(value: '${j.weeksCompleted}', label: 'Weeks done'),
              _Stat(value: '${j.totalSessions}', label: 'Sessions'),
              _Stat(
                value: 'Rank ${_rankRoman[(j.phaseNumber - 1).clamp(0, 3)]}',
                label: 'Current',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: context.appColors.gold,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _PhaseNode extends StatelessWidget {
  final PhaseInfo phase;
  final JourneyState j;
  final bool isLast;
  const _PhaseNode({required this.phase, required this.j, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.phaseColor(phase.number);
    final isComplete = j.weeksCompleted >= phase.endWeek;
    final isCurrent = !j.programComplete && j.phaseNumber == phase.number;
    final weeksDone =
        (j.weeksCompleted - (phase.startWeek - 1)).clamp(0, phase.lengthWeeks);

    final railColor = (isComplete || isCurrent) ? color : context.appColors.divider;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline rail
          SizedBox(
            width: 28,
            child: Column(
              children: [
                _RailNode(color: railColor, filled: isComplete || isCurrent),
                Expanded(
                  child: Container(width: 2, color: railColor.withAlpha(120)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _PhaseCard(
                phase: phase,
                color: color,
                isComplete: isComplete,
                isCurrent: isCurrent,
                weeksDone: weeksDone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RailNode extends StatelessWidget {
  final Color color;
  final bool filled;
  const _RailNode({required this.color, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: filled ? color : context.appColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  final PhaseInfo phase;
  final Color color;
  final bool isComplete;
  final bool isCurrent;
  final int weeksDone;
  const _PhaseCard({
    required this.phase,
    required this.color,
    required this.isComplete,
    required this.isCurrent,
    required this.weeksDone,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final rankIdx = (phase.number - 1).clamp(0, 3);
    final progress = weeksDone / phase.lengthWeeks;
    final statusLabel =
        isComplete ? 'COMPLETE' : (isCurrent ? 'IN PROGRESS' : 'LOCKED');
    final statusColor = isComplete
        ? color
        : (isCurrent ? color : context.appColors.textSecondary);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: AppRadius.cardR,
        border: Border.all(
          color: isCurrent ? color : context.appColors.divider,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _rankRoman[rankIdx],
                  style: tt.labelMedium
                      ?.copyWith(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase.name,
                      style: tt.titleSmall?.copyWith(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rank ${_rankRoman[rankIdx]} · ${_rankNames[rankIdx]}',
                      style: tt.labelSmall
                          ?.copyWith(color: context.appColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (isComplete)
                Icon(Icons.check_circle, color: color, size: 20)
              else if (!isCurrent)
                Icon(Icons.lock_outline,
                    color: context.appColors.textSecondary, size: 16),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: context.appColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weeks ${phase.startWeek}–${phase.endWeek}  ·  $weeksDone/${phase.lengthWeeks} done',
                style: tt.bodySmall
                    ?.copyWith(color: context.appColors.textSecondary),
              ),
              Text(
                statusLabel,
                style: tt.labelSmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GraduationNode extends StatelessWidget {
  final JourneyState j;
  const _GraduationNode({required this.j});

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.gold;
    final done = j.programComplete;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: _RailNode(color: gold, filled: done),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: done ? gold.withAlpha(20) : context.appColors.surface,
              borderRadius: AppRadius.cardR,
              border: Border.all(color: gold.withAlpha(done ? 120 : 50)),
            ),
            child: Row(
              children: [
                Icon(Icons.military_tech,
                    color: done ? gold : context.appColors.textSecondary,
                    size: 26),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fight Ready',
                        style: tt.titleSmall?.copyWith(
                          color: done ? gold : context.appColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        done
                            ? 'Program complete — your body is prepared.'
                            : 'Graduate after all 24 weeks.',
                        style: tt.labelSmall?.copyWith(
                            color: context.appColors.textSecondary),
                      ),
                    ],
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

class _AchievementsGrid extends StatelessWidget {
  final Set<AchievementId> unlocked;
  const _AchievementsGrid({required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.82,
      children: [
        for (final a in kAchievements)
          _AchievementTile(achievement: a, unlocked: unlocked.contains(a.id)),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;
  const _AchievementTile(
      {required this.achievement, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final gold = context.appColors.gold;
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(unlocked
                ? '${achievement.title} — unlocked'
                : '${achievement.title}: ${achievement.description}'),
            duration: const Duration(seconds: 2),
          ));
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: unlocked ? gold.withAlpha(18) : context.appColors.surface,
          borderRadius: AppRadius.cardR,
          border: Border.all(
            color: unlocked ? gold.withAlpha(90) : context.appColors.divider,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              unlocked ? achievement.icon : Icons.lock_outline,
              color: unlocked ? gold : context.appColors.textSecondary,
              size: 26,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.labelSmall?.copyWith(
                color: unlocked
                    ? context.appColors.textPrimary
                    : context.appColors.textSecondary,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
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
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
