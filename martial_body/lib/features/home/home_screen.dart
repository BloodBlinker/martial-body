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
import '../../core/utils/confirm_quit_dialog.dart';
import 'program_complete_screen.dart';
import 'widgets/meal_plan_view.dart';
import 'package:martial_body/core/theme/app_colors.dart';
import 'package:martial_body/core/theme/dimensions.dart';

enum _HomeSection { workout, mealPlan }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homeProvider);
    return async.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(child: CircularProgressIndicator(color: context.appColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Could not load program data.\n\n$e',
              style: TextStyle(color: context.appColors.textSecondary, height: 1.5),
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
    if (vm.isProgramComplete) {
      return ProgramCompleteScreen(vm: vm);
    }
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: CustomScrollView(
              slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ProgramHeader(vm: vm),
                  if (vm.missCount >= 1) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _MissBanner(vm: vm),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _RankBanner(phaseNumber: vm.phaseNumber),
                  const SizedBox(height: AppSpacing.xl),
                  _PhaseTabBar(
                    selected: _selectedPhase,
                    currentPhase: vm.phaseNumber,
                    onSelect: (n) => setState(() => _selectedPhase = n),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SectionTabBar(
                    selected: _selectedSection,
                    onSelect: (s) => setState(() => _selectedSection = s),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _HomeContent(
                    vm: vm,
                    selectedPhase: _selectedPhase,
                    section: _selectedSection,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ]),
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
    final phaseColor = context.appColors.phaseColor(info.number);
    final bg = isSelected ? phaseColor.withAlpha(28) : context.appColors.surface;
    final border = isSelected ? phaseColor.withAlpha(140) : context.appColors.divider;
    final labelColor = isSelected ? phaseColor : context.appColors.textSecondary;

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
                    color: context.appColors.gold,
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
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColors.divider),
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
        color: isSelected ? context.appColors.gold.withAlpha(22) : Colors.transparent,
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
                  color: isSelected ? context.appColors.gold : context.appColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected ? context.appColors.gold : context.appColors.textSecondary,
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
                vm.isProgramComplete ? 'Complete' : 'Week ${vm.displayWeek}',
                style: tt.headlineLarge?.copyWith(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                vm.isProgramComplete
                    ? 'All 24 weeks done — keep training'
                    : 'of 24 weeks',
                style: tt.bodySmall?.copyWith(color: context.appColors.textSecondary),
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
    final color = isDeload ? context.appColors.deload : context.appColors.phaseColor(phase);
    final muted = isDeload ? context.appColors.deloadMuted : context.appColors.phaseMutedColor(phase);
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

/// Warning when the user has missed workout days this week. One miss = amber
/// nudge; two misses = the week is marked for reset (work no longer counts).
class _MissBanner extends StatelessWidget {
  final HomeViewModel vm;
  const _MissBanner({required this.vm});

  @override
  Widget build(BuildContext context) {
    final failed = vm.weekFailed;
    final color = failed ? context.appColors.error : context.appColors.deload;
    final tt = Theme.of(context).textTheme;
    final message = failed
        ? "You've missed 2 workout days this week. You can still train today, "
            "but it won't count. This week's progress will reset — you'll "
            'restart from Monday.'
        : "You've missed 1 workout day this week. If you miss one more, this "
            "week's progress will be reset.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(failed ? Icons.warning_amber_rounded : Icons.info_outline,
              size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: tt.bodySmall?.copyWith(
                color: context.appColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBanner extends StatelessWidget {
  final int phaseNumber;
  const _RankBanner({required this.phaseNumber});

  String _getRankName() {
    switch (phaseNumber) {
      case 1:
        return 'Rank I · Dormant Form';
      case 2:
        return 'Rank II · Kinetic Awakened';
      case 3:
        return 'Rank III · Somatic Apex';
      case 4:
        return 'Rank IV · Absolute Synthesis';
      default:
        return 'Rank I · Dormant Form';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankName = _getRankName();
    final color = context.appColors.phaseColor(phaseNumber);
    const roman = ['I', 'II', 'III', 'IV'];
    // The one rank motif: a single I→IV progression strip instead of scattered
    // "Kinesic Evolution" jargon. Each segment carries its phase colour, so the
    // user sees their whole journey and where they stand in it. Tapping opens
    // the full Journey map.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/journey'),
        borderRadius: AppRadius.cardR,
        child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: AppRadius.cardR,
        border: Border.all(color: color.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: color, size: 15),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  rankName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'JOURNEY',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.appColors.textSecondary,
                      fontSize: 9,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(Icons.chevron_right,
                  size: 16, color: context.appColors.textSecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(4, (i) {
              final n = i + 1;
              final segColor = context.appColors.phaseColor(n);
              final isPast = n < phaseNumber;
              final isCurrent = n == phaseNumber;
              final Color bg;
              final Color fg;
              final Color border;
              if (isCurrent) {
                bg = segColor.withAlpha(40);
                fg = segColor;
                border = segColor;
              } else if (isPast) {
                bg = segColor.withAlpha(22);
                fg = segColor.withAlpha(210);
                border = segColor.withAlpha(60);
              } else {
                bg = context.appColors.surfaceVariant;
                fg = context.appColors.textSecondary;
                border = context.appColors.divider;
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 3 ? AppSpacing.sm : 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: AppRadius.chipR,
                      border:
                          Border.all(color: border, width: isCurrent ? 1.2 : 1),
                    ),
                    child: Text(
                      roman[i],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: fg,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
        ),
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
    final now = DateTime.now();
    final isRecapDay = now.weekday == DateTime.sunday || now.weekday == DateTime.monday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRecapDay) ...[
          _WeeklyRecapCard(vm: vm),
          const SizedBox(height: 24),
        ],
        if (vm.isRestDay) _RestDayBanner(vm: vm) else _TodayCard(vm: vm),
        const SizedBox(height: 24),
        _WeekSection(vm: vm),
      ],
    );
  }
}

class _WeeklyRecapCard extends StatelessWidget {
  final HomeViewModel vm;
  const _WeeklyRecapCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.phase2;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(20),
            blurRadius: 20,
            spreadRadius: -5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                'WEEKLY RECAP',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            vm.completedThisWeek == 0
                ? 'Fresh week ahead. Let\'s get the first session in.'
                : 'You\'ve completed ${vm.completedThisWeek} '
                    '${vm.completedThisWeek == 1 ? 'session' : 'sessions'} this week.',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Consistency is the key to Kinesic Evolution. Keep up the momentum!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
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
    final color = context.appColors.phaseColor(phase.number);
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appColors.divider),
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
                  size: 18, color: context.appColors.textSecondary.withAlpha(180)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            blurb,
            style: tt.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: context.appColors.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              phase.number == 1
                  ? 'Weeks ${phase.startWeek}–${phase.endWeek}'
                  : 'Unlocks · Weeks ${phase.startWeek}–${phase.endWeek}',
              style: tt.labelSmall?.copyWith(
                color: context.appColors.textSecondary,
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

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.phaseColor(phase.number);
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withAlpha(22),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${phase.number}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
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
                      section == _HomeSection.workout
                          ? 'Browse this phase in detail'
                          : 'Meal plan for this phase',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (section == _HomeSection.workout) ...[
            const SizedBox(height: 14),
            Row(
              children: List.generate(5, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 4 ? 6 : 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withAlpha(15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: color.withAlpha(40)),
                      ),
                      child: Text(
                        _dayLabels[i],
                        style: tt.labelSmall?.copyWith(
                          color: color.withAlpha(180),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            'Your active phase is different. Open the Program tab to see the '
            'full schedule for Phase ${phase.number}.',
            style: tt.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
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

  static const _recoveryTips = [
    '🧘  Light stretching or yoga (15–20 min)',
    '🚶  Walk for 20–30 minutes at an easy pace',
    '🧻  Foam roll tight muscle groups',
    '💤  Prioritise 7–9 hours of sleep tonight',
    '🥤  Stay hydrated — aim for 2–3 L of water',
  ];

  @override
  Widget build(BuildContext context) {
    final day = _dayName(DateTime.now().weekday);
    // Rotate tip based on day-of-year for variety.
    final tipIndex = DateTime.now().difference(DateTime(DateTime.now().year)).inDays % _recoveryTips.length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.appColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.self_improvement,
                    color: context.appColors.textSecondary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REST — $day'.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.appColors.textSecondary,
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
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.appColors.phase4.withAlpha(12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.appColors.phase4.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE RECOVERY TIP',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.appColors.phase4,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  _recoveryTips[tipIndex],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textPrimary,
                        height: 1.4,
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

class _TodayCard extends ConsumerWidget {
  final HomeViewModel vm;
  const _TodayCard({required this.vm});

  static String _dayName(int weekday) {
    assert(weekday >= 1 && weekday <= 7);
    const n = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return n[weekday - 1];
  }

  Future<void> _confirmQuit(BuildContext context, WidgetRef ref, int workoutLogId) =>
      confirmQuitSession(context, ref, workoutLogId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = vm.todaySession!;
    final day = _dayName(DateTime.now().weekday);
    final isDone = vm.isSessionDone(session.id);
    final inProgress = vm.inProgressTodayLog;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: AppRadius.cardR,
        // Always carry a hint of gold so the day's session reads as the clear
        // focal point of the screen, with a soft lift to set it above the rest.
        border: Border.all(
          color: context.appColors.gold.withAlpha(isDone ? 70 : 45),
        ),
        boxShadow: [
          BoxShadow(
            color: context.appColors.gold.withAlpha(isDone ? 28 : 16),
            blurRadius: 24,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: context.appColors.gold.withAlpha(18),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                  bottom: BorderSide(color: context.appColors.gold.withAlpha(40))),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 14, color: context.appColors.gold),
                const SizedBox(width: 6),
                Text(
                  'TODAY — ${day.toUpperCase()}',
                  style: tt.labelSmall?.copyWith(
                    color: context.appColors.gold,
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
                      color: context.appColors.gold.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 11, color: context.appColors.gold),
                        const SizedBox(width: 4),
                        Text(
                          'DONE',
                          style: tt.labelSmall?.copyWith(
                            color: context.appColors.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (inProgress != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.appColors.phase1.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pause_circle_outline, size: 11, color: context.appColors.phase1),
                        const SizedBox(width: 4),
                        Text(
                          'IN PROGRESS',
                          style: tt.labelSmall?.copyWith(
                            color: context.appColors.phase1,
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
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _Chip(
                        icon: Icons.timer_outlined,
                        label: '~${session.estimatedMinutes} min'),
                    _Chip(
                        icon: Icons.bar_chart,
                        label:
                            '${vm.completedThisWeek}/${vm.sessionsPerWeek} this week'),
                    if (vm.totalCompletedSessions > 0)
                      _Chip(
                          icon: Icons.emoji_events_outlined,
                          label: '${vm.totalCompletedSessions} total'),
                  ],
                ),
                const SizedBox(height: 18),
                if (inProgress != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/session/${session.id}/active'),
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('RESUME'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () => _confirmQuit(context, ref, inProgress.id),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.appColors.error,
                          side: BorderSide(color: context.appColors.error),
                        ),
                        child: const Text('QUIT'),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/session/${session.id}'),
                      child: Text(isDone ? 'VIEW SESSION' : 'START SESSION'),
                    ),
                  ),
                ],
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
        Icon(icon, size: 13, color: context.appColors.textSecondary),
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
                    color: context.appColors.textSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '${vm.completedThisWeek} of ${vm.sessionsPerWeek} done',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: vm.completedThisWeek > 0
                        ? context.appColors.gold
                        : context.appColors.textSecondary,
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

          final isInProgress = session != null &&
              vm.inProgressLogBySessionId.containsKey(session.id);
          return _WeekDayTile(
            dayLabel: _dayLabels[i],
            session: session,
            isToday: isToday,
            isDone: isDone,
            isInProgress: isInProgress,
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
                      color: context.appColors.textSecondary,
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
  final bool isInProgress;
  final bool isPast;
  final VoidCallback? onTap;

  const _WeekDayTile({
    required this.dayLabel,
    required this.session,
    required this.isToday,
    required this.isDone,
    required this.isInProgress,
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
      accentColor = context.appColors.gold;
      borderColor = context.appColors.gold.withAlpha(60);
      bgColor = context.appColors.gold.withAlpha(12);
    } else if (isToday) {
      accentColor = context.appColors.gold;
      borderColor = context.appColors.gold.withAlpha(100);
      bgColor = context.appColors.surface;
    } else {
      accentColor = context.appColors.textSecondary;
      borderColor = context.appColors.divider;
      bgColor = context.appColors.surface;
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
                        ? context.appColors.gold.withAlpha(25)
                        : isToday
                            ? context.appColors.gold.withAlpha(20)
                            : context.appColors.surfaceVariant,
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
                            color: context.appColors.gold,
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
                                color: context.appColors.textPrimary,
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
                                  ?.copyWith(color: context.appColors.textSecondary),
                            ),
                          ],
                        )
                      : Text(
                          'Rest day',
                          style: tt.bodyMedium
                              ?.copyWith(color: context.appColors.textSecondary),
                        ),
                ),
                if (session != null)
                  isDone
                      ? Icon(Icons.check_circle,
                          color: context.appColors.gold, size: 20)
                      : isInProgress
                          ? Icon(Icons.pause_circle_outline,
                              color: context.appColors.phase1.withAlpha(200), size: 20)
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
        color: context.appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.appColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
