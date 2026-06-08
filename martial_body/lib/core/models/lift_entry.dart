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

/// One completed, weighted set — the raw material for personal records and
/// per-exercise progression.
class LiftEntry {
  final int exerciseId;
  final String exerciseName;
  final double weightKg;
  final int reps;
  final DateTime date;

  const LiftEntry({
    required this.exerciseId,
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
    required this.date,
  });

  /// Estimated one-rep max (Epley). Lets a 5×100 beat a 3×100 even though raw
  /// weight is equal.
  double get estimatedOneRepMax => weightKg * (1 + reps / 30.0);
}

/// A per-exercise personal record summary.
class ExercisePr {
  final int exerciseId;
  final String name;
  final double maxWeightKg;
  final int repsAtMax;
  final double bestE1rmKg;

  const ExercisePr({
    required this.exerciseId,
    required this.name,
    required this.maxWeightKg,
    required this.repsAtMax,
    required this.bestE1rmKg,
  });
}

/// A single point on a per-exercise progression chart: the heaviest set of a
/// given day.
class ProgressionPoint {
  final DateTime date;
  final double weightKg;
  const ProgressionPoint({required this.date, required this.weightKg});
}
