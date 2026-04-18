/// Aggregated per-week analytics derived from WorkoutLog + SetLog data.
class WeeklyStats {
  final int weekNumber;
  final int sessionsCompleted;
  final double totalVolumeKg; // sum of weight × reps for all completed sets
  final int? avgDurationMinutes; // null if no startedAt/completedAt data

  const WeeklyStats({
    required this.weekNumber,
    required this.sessionsCompleted,
    required this.totalVolumeKg,
    this.avgDurationMinutes,
  });
}
