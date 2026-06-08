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
import '../../core/models/home_view_model.dart';
import '../../core/providers/analytics_provider.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/home_provider.dart';
import '../../core/providers/journey_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/theme/app_colors.dart';

/// Shown on the Home tab once all 24 weeks are complete. Congratulates the
/// user and offers two paths: reset to Week 1 (wipes progress, keeps profile)
/// or continue to review their results.
class ProgramCompleteScreen extends ConsumerWidget {
  final HomeViewModel vm;
  const ProgramCompleteScreen({super.key, required this.vm});

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: Text('Start over?',
            style: TextStyle(color: context.appColors.textPrimary)),
        content: Text(
          'This permanently deletes all your logged progress and bodyweight '
          'history, and restarts the program at Week 1. Your profile is kept. '
          'Continue?',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: context.appColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final db = ref.read(databaseProvider);
    await db.sessionDao.deleteAllLogs();
    await db.userDao.deleteAllWeights();
    // Anchor Week 1 to today — a brand-new run starts immediately.
    await db.userDao.resetSchedule(DateTime.now());
    ref.invalidate(homeProvider);
    ref.invalidate(analyticsProvider);
    ref.invalidate(progressProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final gold = context.appColors.gold;
    final unlockedCount =
        ref.watch(journeyProvider).valueOrNull?.unlocked.length ??
            kAchievements.length;

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: gold.withAlpha(28),
                      shape: BoxShape.circle,
                      border: Border.all(color: gold.withAlpha(120), width: 2),
                    ),
                    child: Icon(Icons.military_tech, color: gold, size: 52),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PROGRAM COMPLETE',
                    textAlign: TextAlign.center,
                    style: tt.labelMedium?.copyWith(
                      color: gold,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your body is prepared for combat training.',
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You completed all 24 weeks of the Martial Body program. '
                    'Step into the cage — your coach can focus on technique, '
                    'not conditioning.',
                    textAlign: TextAlign.center,
                    style: tt.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: context.appColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.appColors.divider),
                    ),
                    child: Row(
                      children: [
                        _Stat(value: '24', label: 'Weeks'),
                        _Divider(),
                        _Stat(
                            value: '${vm.totalCompletedSessions}',
                            label: 'Sessions'),
                        _Divider(),
                        _Stat(
                            value: '$unlockedCount/${kAchievements.length}',
                            label: 'Badges'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: context.appColors.background,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: () => _reset(context, ref),
                    child: const Text('RESET & START FROM BEGINNING'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: () => context.go('/journey'),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('VIEW YOUR JOURNEY'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/progress'),
                    child: const Text('CONTINUE'),
                  ),
                ],
              ),
            ),
          ),
        ),
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
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: context.appColors.gold,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.appColors.textSecondary,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: context.appColors.divider);
  }
}
