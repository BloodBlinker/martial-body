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

import '../providers/database_provider.dart';
import '../theme/app_colors.dart';

/// Shared "Quit session?" confirmation dialog used by the home screen's
/// TodayCard and the session overview's StartSessionButton.
///
/// Shows a destructive-action dialog. On confirmation, deletes the workout
/// log (and its set logs) so the session is no longer shown as in-progress.
Future<void> confirmQuitSession(
  BuildContext context,
  WidgetRef ref,
  int workoutLogId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: context.appColors.surface,
      title: Text('Quit session?',
          style: TextStyle(color: context.appColors.textPrimary)),
      content: Text(
        'This will discard all progress for this session.',
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
          child: const Text('Quit'),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    await ref.read(databaseProvider).sessionDao.deleteWorkoutLog(workoutLogId);
  }
}
