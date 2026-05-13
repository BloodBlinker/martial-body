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

import '../../core/models/session_detail.dart';
import '../../core/providers/home_provider.dart';
import '../../core/providers/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/confirm_quit_dialog.dart';

class SessionOverviewScreen extends ConsumerWidget {
  final int sessionId;

  /// When true, hides the START button — the screen is a read-only preview
  /// reached from the Program tab (user browsing other phases / other days).
  final bool preview;

  const SessionOverviewScreen({
    super.key,
    required this.sessionId,
    this.preview = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sessionDetailProvider(sessionId));
    return async.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(child: CircularProgressIndicator(color: context.appColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(child: Text('Error: $e', style: TextStyle(color: context.appColors.textSecondary))),
      ),
      data: (detail) => _SessionBody(
        detail: detail,
        sessionId: sessionId,
        preview: preview,
      ),
    );
  }
}

class _SessionBody extends StatelessWidget {
  final SessionDetail detail;
  final int sessionId;
  final bool preview;

  const _SessionBody({
    required this.detail,
    required this.sessionId,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    // Tuesday's shoulder protocol lives on the MAIN block's instructions
    // (data-driven, seeded in phase1_data.dart). No top-of-screen banner here
    // — it was showing the warning twice.
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Column(
        children: [
          _SessionHeader(detail: detail),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, preview ? 24 : 120),
              children: [
                ...detail.blocks.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BlockCard(block: b, phaseNumber: detail.phase.number),
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: preview ? null : _StartSessionButton(sessionId: sessionId),
    );
  }
}

// ---------------------------------------------------------------------------

class _SessionHeader extends StatelessWidget {
  final SessionDetail detail;
  const _SessionHeader({required this.detail});

  static const _dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    final day = detail.session.weekDay >= 1 && detail.session.weekDay <= 5
        ? _dayNames[detail.session.weekDay - 1]
        : 'Day ${detail.session.weekDay}';
    final phaseColor = context.appColors.phaseColor(detail.phase.number);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 8, 16),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go('/home'),
              icon: Icon(Icons.arrow_back, color: context.appColors.textPrimary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$day · PHASE ${detail.phase.number}'.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: phaseColor,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail.session.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: context.appColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 14, color: context.appColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '~${detail.session.estimatedMinutes} min',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BlockCard extends StatelessWidget {
  final BlockDetail block;
  final int phaseNumber;

  const _BlockCard({required this.block, required this.phaseNumber});

  @override
  Widget build(BuildContext context) {
    final icon = _iconFor(block.block.blockType);
    final iconColor = _colorFor(block.block.blockType, phaseNumber);

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  block.block.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (block.block.instructions != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                block.block.instructions!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                      height: 1.5,
                    ),
              ),
            ),
          if (block.exercises.isEmpty && block.block.instructions == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                'See instructions above',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
              ),
            ),
          ...block.exercises.asMap().entries.map((entry) {
            final isLast = entry.key == block.exercises.length - 1;
            return _buildExerciseRow(context, entry.value, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(BuildContext context, BlockExerciseDetail be, bool isLast) {
    final be_ = be.blockExercise;
    final detail = [
      if (be_.sets != null && be_.reps != null) '${be_.sets} × ${be_.reps}',
      if (be_.sets != null && be_.reps == null) '${be_.sets} sets',
      if (be_.sets == null && be_.reps != null) be_.reps!,
    ].join('');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  be.exercise.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (detail.isNotEmpty)
                    Text(
                      detail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.appColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  if (be_.tempo != null)
                    Text(
                      be_.tempo!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.appColors.textSecondary,
                            fontFamily: 'monospace',
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16),
      ],
    );
  }

  IconData _iconFor(String blockType) {
    switch (blockType) {
      case 'warmup':
        return Icons.air;
      case 'main':
        return Icons.fitness_center;
      case 'tendon':
        return Icons.shield_outlined;
      case 'conditioning':
        return Icons.directions_run;
      case 'grip':
        return Icons.back_hand_outlined;
      case 'core':
        return Icons.sports_martial_arts;
      case 'posterior':
        return Icons.accessibility_new;
      case 'finishing':
        return Icons.sports;
      case 'cooldown':
        return Icons.self_improvement;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _colorFor(String blockType, int phaseNumber) {
    final phaseColor = AppColors.phaseColor(phaseNumber);
    switch (blockType) {
      case 'warmup':
        return AppColors.textSecondary;
      case 'main':
        return phaseColor;
      case 'tendon':
        return AppColors.deload;
      case 'conditioning':
        return AppColors.phase2;
      case 'grip':
        return AppColors.phase3;
      case 'core':
        return AppColors.phase2;
      case 'posterior':
        return phaseColor;
      case 'cooldown':
        return AppColors.phase4;
      default:
        return AppColors.textSecondary;
    }
  }
}

// ---------------------------------------------------------------------------

class _StartSessionButton extends ConsumerWidget {
  final int sessionId;
  const _StartSessionButton({required this.sessionId});

  Future<void> _confirmQuit(BuildContext context, WidgetRef ref, int workoutLogId) =>
      confirmQuitSession(context, ref, workoutLogId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);
    final vm = homeAsync.valueOrNull;
    final inProgressLog = vm?.inProgressLogBySessionId[sessionId];
    final hasInProgress = inProgressLog != null;
    final isDone = vm?.isSessionDone(sessionId) ?? false;

    return Container(
      color: context.appColors.background,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: hasInProgress
          ? Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/session/$sessionId/active'),
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: const Text('RESUME SESSION'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () => _confirmQuit(context, ref, inProgressLog.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.appColors.error,
                      side: BorderSide(color: context.appColors.error),
                    ),
                    child: const Text('QUIT'),
                  ),
                ),
              ],
            )
          : isDone
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/session/$sessionId/active'),
                        icon: const Icon(Icons.replay, size: 20),
                        label: const Text('REDO SESSION'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/session/$sessionId/active'),
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: const Text('START SESSION'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
    );
  }
}
