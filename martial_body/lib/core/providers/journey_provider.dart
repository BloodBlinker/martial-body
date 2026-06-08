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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/achievement.dart';
import '../program/phase_math.dart';
import 'database_provider.dart';

/// A snapshot of the user's position on the 24-week journey plus which
/// achievements they've earned. Completion-anchored: a week only counts as
/// "completed" once it has been successfully cleared, so [weeksCompleted]
/// advances exactly as fast as real progress.
class JourneyState {
  final int currentWeek; // 1..24
  final int weeksCompleted; // 0..24
  final int totalSessions;
  final int phaseNumber; // 1..4
  final bool programComplete;
  final Set<AchievementId> unlocked;

  const JourneyState({
    required this.currentWeek,
    required this.weeksCompleted,
    required this.totalSessions,
    required this.phaseNumber,
    required this.programComplete,
    required this.unlocked,
  });

  double get fractionComplete => (weeksCompleted / kProgramWeeks).clamp(0.0, 1.0);
}

final journeyProvider = FutureProvider.autoDispose<JourneyState>((ref) async {
  final db = ref.watch(databaseProvider);
  final st = await db.userDao.getUserState();
  final rawWeek = st?.currentWeek ?? 1;
  final programComplete = st?.programComplete ?? false;

  final logs = await db.sessionDao.getAllLogs();
  final totalSessions = logs.where((l) => l.completed).length;
  final hasPr = (await db.sessionDao.getCompletedLifts()).isNotEmpty;

  final weeksCompleted =
      (programComplete ? kProgramWeeks : (rawWeek - 1)).clamp(0, kProgramWeeks);
  final currentWeek = rawWeek.clamp(1, kProgramWeeks);

  final criteria = AchievementCriteria(
    weeksCompleted: weeksCompleted,
    totalSessions: totalSessions,
    programComplete: programComplete,
    hasPersonalRecord: hasPr,
  );

  return JourneyState(
    currentWeek: currentWeek,
    weeksCompleted: weeksCompleted,
    totalSessions: totalSessions,
    phaseNumber: phaseForWeek(currentWeek).number,
    programComplete: programComplete,
    unlocked: unlockedAchievements(criteria),
  );
});
