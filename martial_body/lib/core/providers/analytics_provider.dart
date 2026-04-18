import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../models/weekly_stats.dart';
import 'database_provider.dart';

/// Computes per-week analytics from WorkoutLog + SetLog data.
///
/// Uses two queries (all workout logs, all completed set logs) and joins in
/// memory instead of per-workout SetLog lookups — avoids ~120 round trips on
/// a full 24-week program.
final analyticsProvider = FutureProvider<List<WeeklyStats>>((ref) async {
  final db = ref.watch(databaseProvider);
  return _buildWeeklyStats(db);
});

Future<List<WeeklyStats>> _buildWeeklyStats(AppDatabase db) async {
  final allLogs = await db.sessionDao.watchAllLogs().first;
  if (allLogs.isEmpty) return [];

  final completedLogs = allLogs.where((l) => l.completed).toList();
  if (completedLogs.isEmpty) return [];

  // Fetch every completed set log once, then group by workoutLogId.
  final allCompletedSets = await db.sessionDao.getAllCompletedSetLogs();
  final Map<int, List<SetLog>> setsByWorkout = {};
  for (final s in allCompletedSets) {
    setsByWorkout.putIfAbsent(s.workoutLogId, () => []).add(s);
  }

  // Group completed logs by week number
  final Map<int, List<WorkoutLog>> byWeek = {};
  for (final log in completedLogs) {
    byWeek.putIfAbsent(log.weekNumber, () => []).add(log);
  }

  final List<WeeklyStats> result = [];

  for (final entry in byWeek.entries) {
    final weekNum = entry.key;
    final weekLogs = entry.value;

    double totalVolume = 0.0;
    int durationSum = 0;
    int durationCount = 0;

    for (final log in weekLogs) {
      if (log.startedAt != null && log.completedAt != null) {
        durationSum += log.completedAt!.difference(log.startedAt!).inMinutes;
        durationCount++;
      }
      final sets = setsByWorkout[log.id] ?? const <SetLog>[];
      for (final s in sets) {
        if (s.weightKg != null && s.repsCompleted != null) {
          totalVolume += s.weightKg! * s.repsCompleted!;
        }
      }
    }

    result.add(WeeklyStats(
      weekNumber: weekNum,
      sessionsCompleted: weekLogs.length,
      totalVolumeKg: totalVolume,
      avgDurationMinutes: durationCount > 0 ? durationSum ~/ durationCount : null,
    ));
  }

  result.sort((a, b) => a.weekNumber.compareTo(b.weekNumber));
  return result;
}
