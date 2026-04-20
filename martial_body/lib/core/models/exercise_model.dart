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

/// A named exercise in the exercise library (shared across phases).
class ExerciseModel {
  final String name;
  final String category; // strength | mobility | cardio | grip | core | neck | etc.

  const ExerciseModel({
    required this.name,
    required this.category,
  });
}

/// One exercise slot inside a block, with all prescribed parameters.
class BlockExerciseModel {
  final ExerciseModel exercise;
  final int exerciseOrder; // 0-based
  final int? sets; // null for cooldown stretches
  final String? reps; // "12", "8/leg", "30–45s", "Max time", "Failure"
  final String? tempo; // "3-1-1-0", "Static", "X", "Controlled", "Slow"
  final int? restSeconds; // null = not specified
  final String? notes;
  final bool isNew; // first appearance in this phase

  const BlockExerciseModel({
    required this.exercise,
    required this.exerciseOrder,
    this.sets,
    this.reps,
    this.tempo,
    this.restSeconds,
    this.notes,
    this.isNew = false,
  });
}
