import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/phase_content.dart';
import '../../core/database/database.dart';
import '../../core/program/phase_math.dart';
import '../../core/providers/database_provider.dart';
import '../../core/theme/app_colors.dart';

/// Mon–Fri sessions for a single phase. Reached by tapping the phase tile on
/// the Program screen. Sessions are read-only previews — tapping a session
/// opens the overview with the START button suppressed.
class PhaseDetailScreen extends ConsumerWidget {
  final int phaseNumber;

  const PhaseDetailScreen({super.key, required this.phaseNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phaseInfo = kPhases.firstWhere(
      (p) => p.number == phaseNumber,
      orElse: () => kPhases.first,
    );
    final spec = phaseContentFor(phaseNumber);
    final phaseColor = AppColors.phaseColor(phaseNumber);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.canPop() ? context.pop() : context.go('/program'),
        ),
        title: Text(
          'Phase $phaseNumber',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: phaseColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _PhaseSummary(info: phaseInfo, phaseColor: phaseColor),
            const SizedBox(height: 20),
            if (!spec.workoutAvailable)
              _ComingSoonCard(blurb: spec.workoutBlurb, phaseColor: phaseColor)
            else
              _SessionsList(phaseNumber: phaseNumber, phaseColor: phaseColor),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _PhaseSummary extends StatelessWidget {
  final PhaseInfo info;
  final Color phaseColor;

  const _PhaseSummary({required this.info, required this.phaseColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: phaseColor.withAlpha(90)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Weeks ${info.startWeek}–${info.endWeek}'
            '${info.deloadWeeks.isEmpty ? '' : '  ·  Deload: week${info.deloadWeeks.length == 1 ? '' : 's'} '
                '${info.deloadWeeks.toList().join(', ')}'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: phaseColor,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SessionsList extends ConsumerWidget {
  final int phaseNumber;
  final Color phaseColor;

  const _SessionsList({required this.phaseNumber, required this.phaseColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_phaseSessionsProvider(phaseNumber));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      ),
      error: (e, _) => Text(
        'Error: $e',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Text(
            'No sessions seeded for this phase yet.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          );
        }
        return Column(
          children: [
            for (var i = 0; i < sessions.length; i++) ...[
              _SessionTile(session: sessions[i], phaseColor: phaseColor),
              if (i != sessions.length - 1) const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

class _SessionTile extends StatelessWidget {
  final Session session;
  final Color phaseColor;

  const _SessionTile({required this.session, required this.phaseColor});

  static const _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  String get _dayLabel => session.weekDay >= 1 && session.weekDay <= 5
      ? _dayNames[session.weekDay - 1]
      : 'Day ${session.weekDay}';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/session/${session.id}?preview=1'),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: phaseColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _dayLabel.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        color: phaseColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.focus,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '~${session.estimatedMinutes} min',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ComingSoonCard extends StatelessWidget {
  final String blurb;
  final Color phaseColor;

  const _ComingSoonCard({required this.blurb, required this.phaseColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, size: 18, color: phaseColor),
              const SizedBox(width: 8),
              Text(
                'Workout · coming soon',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: phaseColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            blurb,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

final _phaseSessionsProvider =
    FutureProvider.family<List<Session>, int>((ref, phaseNumber) async {
  final db = ref.watch(databaseProvider);
  return db.programDao.getSessionsForPhase(phaseNumber);
});
