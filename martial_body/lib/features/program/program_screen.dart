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

import '../../core/models/home_view_model.dart';
import '../../core/program/phase_math.dart';
import '../../core/providers/home_provider.dart';
import '../../core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Per-tab presentation (colour + labels) layered on top of the shared phase
// structure in phase_math.dart. Week ranges and deload weeks come from there
// so Home and Program can never disagree.

class _PhaseDisplay {
  final PhaseInfo info;
  final String subtitle;
  final Color color;
  final List<String> dayLabels;

  const _PhaseDisplay({
    required this.info,
    required this.subtitle,
    required this.color,
    required this.dayLabels,
  });

  int get number => info.number;
  int get startWeek => info.startWeek;
  int get endWeek => info.endWeek;
  Set<int> get deloadWeeks => info.deloadWeeks;
  String get name => info.name;

  String get weekRange => 'Weeks $startWeek–$endWeek';
}

const _kPhaseDisplay = <_PhaseDisplay>[
  _PhaseDisplay(
    info: PhaseInfo(
      number: 1,
      name: 'Foundation',
      startWeek: 1,
      endWeek: 6,
      deloadWeeks: {4},
    ),
    subtitle: 'Foundation',
    color: AppColors.phase1,
    // NOTE: Day labels here are presentational only. When Phase 2+ seed data
    // lands, prefer deriving them from the DB session names to avoid drift.
    dayLabels: ['Mob+Str', 'Push+Neck', 'Post Chain', 'Pull+Grip', 'Core+Mob'],
  ),
  _PhaseDisplay(
    info: PhaseInfo(
      number: 2,
      name: 'Engine Build',
      startWeek: 7,
      endWeek: 12,
      deloadWeeks: {10},
    ),
    subtitle: 'Engine Build',
    color: AppColors.phase2,
    dayLabels: ['Lower', 'Upper', 'Intervals', 'Pull', 'Circuit'],
  ),
  _PhaseDisplay(
    info: PhaseInfo(
      number: 3,
      name: 'Full Combat',
      startWeek: 13,
      endWeek: 20,
      deloadWeeks: {16, 20},
    ),
    subtitle: 'Full Combat',
    color: AppColors.phase3,
    dayLabels: ['Combat Str', 'Power', 'Sprints', 'Pull+Grip', 'Circuit'],
  ),
  _PhaseDisplay(
    info: PhaseInfo(
      number: 4,
      name: 'MMA Transition',
      startWeek: 21,
      endWeek: 24,
      deloadWeeks: {},
    ),
    subtitle: 'MMA Transition',
    color: AppColors.phase4,
    dayLabels: ['Mon', 'Tue', 'Wed', 'Fri'],
  ),
];

// ---------------------------------------------------------------------------

class ProgramScreen extends ConsumerStatefulWidget {
  const ProgramScreen({super.key});

  @override
  ConsumerState<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends ConsumerState<ProgramScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  // Once we've jumped to the user's current phase on first-meaningful-data,
  // never force the tab again — otherwise any rebuild yanks them back.
  bool _didSyncOnce = false;
  ProviderSubscription<AsyncValue<HomeViewModel>>? _sub;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // One-shot: jump the tab to the user's current phase the first time
    // homeProvider produces a value. After that, leave the tab alone so the
    // user can freely browse other phases without being snapped back.
    _sub = ref.listenManual<AsyncValue<HomeViewModel>>(
      homeProvider,
      (prev, next) {
        if (_didSyncOnce) return;
        next.whenData((vm) {
          _didSyncOnce = true;
          if (!mounted) return;
          final phaseIndex = _kPhaseDisplay.indexWhere(
            (p) => vm.weekNumber >= p.startWeek && vm.weekNumber <= p.endWeek,
          );
          final target = phaseIndex < 0 ? 0 : phaseIndex;
          if (_tabController.index != target) _tabController.animateTo(target);
        });
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _sub?.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);
    final currentWeek = homeAsync.value?.weekNumber ?? 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            _PhaseTabs(controller: _tabController),
            const SizedBox(height: 4),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _kPhaseDisplay
                    .map((phase) => _PhaseTabContent(
                          phase: phase,
                          currentWeek: currentWeek,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Program',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.phase1Muted,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.phase1.withAlpha(80)),
            ),
            child: Text(
              '24 Weeks',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.phase1,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _PhaseTabs extends StatefulWidget {
  final TabController controller;
  const _PhaseTabs({required this.controller});

  @override
  State<_PhaseTabs> createState() => _PhaseTabsState();
}

class _PhaseTabsState extends State<_PhaseTabs> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final labels =
        _kPhaseDisplay.map((p) => 'Phase ${p.number}').toList();
    final colors = _kPhaseDisplay.map((p) => p.color).toList();
    final idx = widget.controller.index;

    return TabBar(
      controller: widget.controller,
      isScrollable: false,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
      dividerColor: AppColors.divider,
      indicatorColor: colors[idx],
      labelColor: colors[idx],
      tabs: List.generate(4, (i) {
        final selected = i == idx;
        return Tab(
          child: Text(
            labels[i],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? colors[i] : AppColors.textSecondary,
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------

class _PhaseTabContent extends StatelessWidget {
  final _PhaseDisplay phase;
  final int currentWeek;

  const _PhaseTabContent({
    required this.phase,
    required this.currentWeek,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _PhaseHeader(phase: phase, currentWeek: currentWeek),
        const SizedBox(height: 16),
        _WeekColumnHeaders(is4Day: phase.number == 4),
        const SizedBox(height: 8),
        ...List.generate(phase.endWeek - phase.startWeek + 1, (i) {
          final week = phase.startWeek + i;
          final isCurrent = week == currentWeek;
          final isComplete = week < currentWeek;
          final isDeload = phase.deloadWeeks.contains(week);
          return _WeekRow(
            week: week,
            dayLabels: phase.dayLabels,
            phaseColor: phase.color,
            isCurrent: isCurrent,
            isComplete: isComplete,
            isDeload: isDeload,
            is4Day: phase.number == 4,
          );
        }),
      ],
    );
  }
}

class _PhaseHeader extends StatelessWidget {
  final _PhaseDisplay phase;
  final int currentWeek;

  const _PhaseHeader({required this.phase, required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    final isActivePhase =
        currentWeek >= phase.startWeek && currentWeek <= phase.endWeek;
    final borderColor =
        isActivePhase ? phase.color : phase.color.withAlpha(50);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/program/phase/${phase.number}'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isActivePhase ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: phase.color.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${phase.number}',
                    style: TextStyle(
                      color: phase.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phase.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      phase.weekRange,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                phase.color.withAlpha(isActivePhase ? 255 : 140),
                          ),
                    ),
                  ],
                ),
              ),
              if (isActivePhase)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: phase.color.withAlpha(25),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: phase.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                          letterSpacing: 1.0,
                        ),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right,
                  color: phase.color.withAlpha(isActivePhase ? 220 : 120)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekColumnHeaders extends StatelessWidget {
  final bool is4Day;
  const _WeekColumnHeaders({required this.is4Day});

  @override
  Widget build(BuildContext context) {
    final headers =
        is4Day ? ['Mon', 'Tue', 'Wed', 'Fri'] : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    return Row(
      children: [
        const SizedBox(width: 52),
        ...headers.map(
          (h) => Expanded(
            child: Text(
              h,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _WeekRow extends StatelessWidget {
  final int week;
  final List<String> dayLabels;
  final Color phaseColor;
  final bool isCurrent;
  final bool isComplete;
  final bool isDeload;
  final bool is4Day;

  const _WeekRow({
    required this.week,
    required this.dayLabels,
    required this.phaseColor,
    required this.isCurrent,
    required this.isComplete,
    required this.isDeload,
    required this.is4Day,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color rowBg;

    if (isCurrent && isDeload) {
      rowBg = AppColors.deloadMuted;
      borderColor = AppColors.deload;
    } else if (isCurrent) {
      rowBg = AppColors.surface;
      borderColor = phaseColor;
    } else if (isDeload) {
      rowBg = AppColors.deloadMuted;
      borderColor = AppColors.deload.withAlpha(80);
    } else if (isComplete) {
      rowBg = AppColors.surfaceVariant;
      borderColor = AppColors.divider;
    } else {
      rowBg = AppColors.surface;
      borderColor = AppColors.divider;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wk $week',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isCurrent
                            ? phaseColor
                            : isDeload
                                ? AppColors.deload
                                : AppColors.textSecondary,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                ),
                if (isDeload)
                  Text(
                    'DELOAD',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.deload,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  )
                else if (isCurrent)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                      color: phaseColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ...dayLabels.map(
            (d) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                decoration: BoxDecoration(
                  color: isComplete
                      ? phaseColor.withAlpha(25)
                      : isCurrent
                          ? phaseColor.withAlpha(15)
                          : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  d,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        color: isComplete
                            ? phaseColor
                            : isCurrent
                                ? phaseColor.withAlpha(200)
                                : AppColors.textSecondary,
                        height: 1.2,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          if (is4Day && dayLabels.length < 5)
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
