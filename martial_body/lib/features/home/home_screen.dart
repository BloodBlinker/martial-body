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

import '../../core/content/phase_content.dart';
import '../../core/database/database.dart';
import '../../core/meal_plans/meal_plan_registry.dart';
import '../../core/models/home_view_model.dart';
import '../../core/program/phase_math.dart';
import '../../core/providers/home_provider.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/meal_plan_view.dart';

enum _HomeSection { workout, mealPlan }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homeProvider);
    return async.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Could not load programme data.\n\n$e',
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (vm) => _HomeBody(vm: vm),
    );
  }
}

// ---------------------------------------------------------------------------
// Home body — holds the phase/section tab state.
// ---------------------------------------------------------------------------

class _HomeBody extends StatefulWidget {
  final HomeViewModel vm;
  const _HomeBody({required this.vm});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  late int _selectedPhase = widget.vm.phaseNumber;
  _HomeSection _selectedSection = _HomeSection.workout;

  @override
  void didUpdateWidget(covariant _HomeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the user hasn't manually tapped a different phase, keep the selected
    // tab in sync with the live current phase as weeks roll over.
    if (_selectedPhase == oldWidget.vm.phaseNumber &&
        widget.vm.phaseNumber != oldWidget.vm.phaseNumber) {
      _selectedPhase = widget.vm.phaseNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ProgramHeader(vm: vm),
                  const SizedBox(height: 18),
                  _PhaseTabBar(
                    selected: _selectedPhase,
                    currentPhase: vm.phaseNumber,
                    onSelect: (n) => setState(() => _selectedPhase = n),
                  ),
                  const SizedBox(height: 14),
                  _SectionTabBar(
                    selected: _selectedSection,
                    onSelect: (s) => setState(() => _selectedSection = s),
                  ),
                  const SizedBox(height: 20),
                  _HomeContent(
                    vm: vm,
                    selectedPhase: _selectedPhase,
                    section: _selectedSection,
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content router — picks the right cell for (phase, section).
// ---------------------------------------------------------------------------

class _HomeContent extends StatelessWidget {
  final HomeViewModel vm;
  final int selectedPhase;
  final _HomeSection section;

  const _HomeContent({
    required this.vm,
    required this.selectedPhase,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final spec = phaseContentFor(selectedPhase);
    final phaseInfo = phaseForWeek(
      // Reuse phaseForWeek to fetch PhaseInfo for the SELECTED phase by
      // picking any week inside its range.
      kPhases
          .firstWhere((p) => p.number == selectedPhase,
              orElse: () => kPhases.first)
          .startWeek,
    );

    final isCurrentPhase = selectedPhase == vm.phaseNumber;

    switch (section) {
      case _HomeSection.workout:
        if (spec.workoutAvailable && isCurrentPhase) {
          return _CurrentPhaseWorkout(vm: vm);
        }
        if (spec.workoutAvailable && !isCurrentPhase) {
          return _OtherPhaseAvailableCard(phase: phaseInfo, section: section);
        }
        return _ComingSoonCard(
          phase: phaseInfo,
          icon: Icons.fitness_center,
          heading: 'Workout · coming soon',
          blurb: spec.workoutBlurb,
        );
      case _HomeSection.mealPlan:
        final plan = mealPlanFor(selectedPhase);
        if (spec.mealPlanAvailable && plan != null) {
          return MealPlanView(plan: plan, phase: phaseInfo);
        }
        return _ComingSoonCard(
          phase: phaseInfo,
          icon: Icons.restaurant_menu,
          heading: 'Meal plan · coming soon',
          blurb: spec.mealPlanBlurb,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Phase + section tab bars
// ---------------------------------------------------------------------------

class _PhaseTabBar extends StatelessWidget {
  final int selected;
  final int currentPhase;
  final ValueChanged<int> onSelect;

  const _PhaseTabBar({
    required this.selected,
    required this.currentPhase,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final p in kPhases) ...[
            _PhaseChip(
              info: p,
              isSelected: p.number == selected,
              isCurrent: p.number == currentPhase,
              onTap: () => onSelect(p.number),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  final PhaseInfo info;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PhaseChip({
    required this.info,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final phaseColor = AppColors.phaseColor(info.number);
    final bg = isSelected ? phaseColor.withAlpha(28) : AppColors.surface;
    final border = isSelected ? phaseColor.withAlpha(140) : AppColors.divider;
    final labelColor = isSelected ? phaseColor : AppColors.textSecondary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: isSelected ? 1.2 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PHASE ${info.number}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
              ),
              if (isCurrent) ...[
                const SizedBox(width: 6),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTabBar extends StatelessWidget {
  final _HomeSection selected;
  final ValueChanged<_HomeSection> onSelect;

  const _SectionTabBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _SectionPill(
            label: 'WORKOUT',
            icon: Icons.fitness_center,
            isSelected: selected == _HomeSection.workout,
            onTap: () => onSelect(_HomeSection.workout),
          ),
          _SectionPill(
            label: 'MEAL PLAN',
            icon: Icons.restaurant_menu,
            isSelected: selected == _HomeSection.mealPlan,
            onTap: () => onSelect(_HomeSection.mealPlan),
          ),
        ],
      ),
    );
  }
}

class _SectionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SectionPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected ? AppColors.gold.withAlpha(22) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected ? AppColors.gold : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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
// Programme header (unchanged semantics; shows user's actual position)
// ---------------------------------------------------------------------------

class _ProgramHeader extends StatelessWidget {
  final HomeViewModel vm;
  const _ProgramHeader({required this.vm});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Week ${vm.weekNumber}',
                style: tt.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'of 24 weeks',
                style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        _PhaseBadge(
          phase: vm.phaseNumber,
          name: vm.phaseName,
          isDeload: vm.isDeload,
        ),
      ],
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  final int phase;
  final String name;
  final bool isDeload;
  const _PhaseBadge({required this.phase, required this.name, required this.isDeload});

  @override
  Widget build(BuildContext context) {
    final color = isDeload ? AppColors.deload : AppColors.phaseColor(phase);
    final muted = isDeload ? AppColors.deloadMuted : AppColors.phaseMutedColor(phase);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: muted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'PHASE $phase',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
          ),
          Text(
            isDeload ? 'DELOAD' : name.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Current-phase workout content = the existing Today + This week UI.
// ---------------------------------------------------------------------------

class _CurrentPhaseWorkout extends StatelessWidget {
  final HomeViewModel vm;
  const _CurrentPhaseWorkout({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (vm.isRestDay) _RestDayBanner(vm: vm) else _TodayCard(vm: vm),
        const SizedBox(height: 24),
        _WeekSection(vm: vm),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Coming-soon / other-phase cards — driven entirely by the phase registry.
// ---------------------------------------------------------------------------

class _ComingSoonCard extends StatelessWidget {
  final PhaseInfo phase;
  final IconData icon;
  final String heading;
  final String blurb;

  const _ComingSoonCard({
    required this.phase,
    required this.icon,
    required this.heading,
    required this.blurb,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.phaseColor(phase.number);
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(22),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PHASE ${phase.number} · ${phase.name.toUpperCase()}',
                      style: tt.labelSmall?.copyWith(
                        color: color,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      heading,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.lock_outline,
                  size: 18, color: AppColors.textSecondary.withAlpha(180)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            blurb,
            style: tt.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              phase.number == 1
                  ? 'Weeks ${phase.startWeek}–${phase.endWeek}'
                  : 'Unlocks · Weeks ${phase.startWeek}–${phase.endWeek}',
              style: tt.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherPhaseAvailableCard extends StatelessWidget {
  final PhaseInfo phase;
  final _HomeSection section;

  const _OtherPhaseAvailableCard({required this.phase, required this.section});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.phaseColor(phase.number);
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PHASE ${phase.number} · ${phase.name.toUpperCase()}',
            style: tt.labelSmall?.copyWith(
              color: color,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            section == _HomeSection.workout
                ? 'Browse this phase in detail'
                : 'Meal plan for this phase',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Your active phase is different. Open the Program tab to see the '
            'full schedule for Phase ${phase.number}.',
            style: tt.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/program'),
              icon: const Icon(Icons.calendar_month, size: 16),
              label: const Text('OPEN IN PROGRAM'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Preserved sub-widgets (Today card, rest banner, this-week list)
// ---------------------------------------------------------------------------

class _RestDayBanner extends StatelessWidget {
  final HomeViewModel vm;
  const _RestDayBanner({required this.vm});

  static String _dayName(int weekday) {
    assert(weekday >= 1 && weekday <= 7);
    const n = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return n[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final day = _dayName(DateTime.now().weekday);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.self_improvement,
                color: AppColors.textSecondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REST — $day'.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Recovery day. Tap any session below to log it.',
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

class _TodayCard extends StatelessWidget {
  final HomeViewModel vm;
  const _TodayCard({required this.vm});

  static String _dayName(int weekday) {
    assert(weekday >= 1 && weekday <= 7);
    const n = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return n[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final session = vm.todaySession!;
    final day = _dayName(DateTime.now().weekday);
    final isDone = vm.isSessionDone(session.id);
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? AppColors.gold.withAlpha(60) : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.gold.withAlpha(18),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                  bottom: BorderSide(color: AppColors.gold.withAlpha(40))),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, size: 14, color: AppColors.gold),
                const SizedBox(width: 6),
                Text(
                  'TODAY — ${day.toUpperCase()}',
                  style: tt.labelSmall?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                if (isDone)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, size: 11, color: AppColors.gold),
                        const SizedBox(width: 4),
                        Text(
                          'DONE',
                          style: tt.labelSmall?.copyWith(
                            color: AppColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.name,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(session.focus, style: tt.bodySmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Chip(
                        icon: Icons.timer_outlined,
                        label: '~${session.estimatedMinutes} min'),
                    const SizedBox(width: 10),
                    _Chip(
                        icon: Icons.bar_chart,
                        label:
                            '${vm.completedThisWeek}/5 this week'),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/session/${session.id}'),
                    child: Text(isDone ? 'VIEW SESSION' : 'START SESSION'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _WeekSection extends StatelessWidget {
  final HomeViewModel vm;
  const _WeekSection({required this.vm});

  static const _dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI'];

  @override
  Widget build(BuildContext context) {
    final todayWeekday = DateTime.now().weekday; // 1=Mon … 7=Sun
    final sessions = vm.allPhaseSessions;

    final sessionByDay = <int, Session>{};
    for (final s in sessions) {
      sessionByDay[s.weekDay] = s;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'THIS WEEK',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '${vm.completedThisWeek} of 5 done',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: vm.completedThisWeek > 0
                        ? AppColors.gold
                        : AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (i) {
          final weekday = i + 1;
          final session = sessionByDay[weekday];
          final isToday = weekday == todayWeekday;
          final isDone = session != null && vm.isSessionDone(session.id);
          final isPast = weekday < todayWeekday;

          return _WeekDayTile(
            dayLabel: _dayLabels[i],
            session: session,
            isToday: isToday,
            isDone: isDone,
            isPast: isPast,
            onTap: session != null
                ? () => context.go('/session/${session.id}')
                : null,
          );
        }),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            children: [
              _WeekendDot(label: 'SAT'),
              const SizedBox(width: 8),
              _WeekendDot(label: 'SUN'),
              const SizedBox(width: 10),
              Text(
                'Rest / Active Recovery',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary.withAlpha(140),
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekDayTile extends StatelessWidget {
  final String dayLabel;
  final Session? session;
  final bool isToday;
  final bool isDone;
  final bool isPast;
  final VoidCallback? onTap;

  const _WeekDayTile({
    required this.dayLabel,
    required this.session,
    required this.isToday,
    required this.isDone,
    required this.isPast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final Color accentColor;
    final Color borderColor;
    final Color bgColor;

    if (isDone) {
      accentColor = AppColors.gold;
      borderColor = AppColors.gold.withAlpha(60);
      bgColor = AppColors.gold.withAlpha(12);
    } else if (isToday) {
      accentColor = AppColors.gold;
      borderColor = AppColors.gold.withAlpha(100);
      bgColor = AppColors.surface;
    } else {
      accentColor = AppColors.textSecondary;
      borderColor = AppColors.divider;
      bgColor = AppColors.surface;
    }

    final borderRadius = BorderRadius.circular(12);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: bgColor,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                  color: borderColor, width: isToday && !isDone ? 1.5 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.gold.withAlpha(25)
                        : isToday
                            ? AppColors.gold.withAlpha(20)
                            : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayLabel,
                        style: tt.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isToday && !isDone) ...[
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: session != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session!.name,
                              style: tt.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: isToday
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '~${session!.estimatedMinutes} min',
                              style: tt.labelSmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        )
                      : Text(
                          'Rest day',
                          style: tt.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                ),
                if (session != null)
                  isDone
                      ? const Icon(Icons.check_circle,
                          color: AppColors.gold, size: 20)
                      : Icon(Icons.chevron_right,
                          color: accentColor.withAlpha(150), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekendDot extends StatelessWidget {
  final String label;
  const _WeekendDot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary.withAlpha(140),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
