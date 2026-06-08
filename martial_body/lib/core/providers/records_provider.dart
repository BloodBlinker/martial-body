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

import '../database/database.dart';
import '../models/lift_entry.dart';
import 'database_provider.dart';

/// Per-exercise personal records, derived from every completed weighted set.
/// Sorted by heaviest estimated 1RM first.
final personalRecordsProvider =
    FutureProvider.autoDispose<List<ExercisePr>>((ref) async {
  final db = ref.watch(databaseProvider);
  final lifts = await db.sessionDao.getCompletedLifts();
  return computePersonalRecords(lifts);
});

/// Map of exerciseId → heaviest weight ever lifted (kg). Used in-session to
/// flag a new PR the moment a heavier set is logged.
final maxWeightByExerciseProvider =
    FutureProvider.autoDispose<Map<int, double>>((ref) async {
  final db = ref.watch(databaseProvider);
  final lifts = await db.sessionDao.getCompletedLifts();
  final out = <int, double>{};
  for (final l in lifts) {
    final cur = out[l.exerciseId];
    if (cur == null || l.weightKg > cur) out[l.exerciseId] = l.weightKg;
  }
  return out;
});

/// Heaviest set per day for one exercise, oldest first — the progression chart.
final exerciseProgressionProvider =
    FutureProvider.autoDispose.family<List<ProgressionPoint>, int>((ref, exerciseId) async {
  final db = ref.watch(databaseProvider);
  final lifts = await db.sessionDao.getCompletedLifts();
  final byDay = <DateTime, double>{};
  for (final l in lifts.where((l) => l.exerciseId == exerciseId)) {
    final day = DateTime(l.date.year, l.date.month, l.date.day);
    final cur = byDay[day];
    if (cur == null || l.weightKg > cur) byDay[day] = l.weightKg;
  }
  final points = byDay.entries
      .map((e) => ProgressionPoint(date: e.key, weightKg: e.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return points;
});

/// All logged bodyweight entries, oldest first.
final bodyweightProvider = StreamProvider<List<UserWeight>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.userDao.watchAllWeights();
});

/// Pure reducer over [lifts] → one [ExercisePr] per exercise.
List<ExercisePr> computePersonalRecords(List<LiftEntry> lifts) {
  final byExercise = <int, List<LiftEntry>>{};
  for (final l in lifts) {
    byExercise.putIfAbsent(l.exerciseId, () => []).add(l);
  }
  final records = <ExercisePr>[];
  for (final entry in byExercise.entries) {
    final sets = entry.value;
    LiftEntry heaviest = sets.first;
    LiftEntry bestE1rm = sets.first;
    for (final s in sets) {
      if (s.weightKg > heaviest.weightKg) heaviest = s;
      if (s.estimatedOneRepMax > bestE1rm.estimatedOneRepMax) bestE1rm = s;
    }
    records.add(ExercisePr(
      exerciseId: entry.key,
      name: heaviest.exerciseName,
      maxWeightKg: heaviest.weightKg,
      repsAtMax: heaviest.reps,
      bestE1rmKg: bestE1rm.estimatedOneRepMax,
    ));
  }
  records.sort((a, b) => b.bestE1rmKg.compareTo(a.bestE1rmKg));
  return records;
}
