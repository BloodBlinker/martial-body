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
