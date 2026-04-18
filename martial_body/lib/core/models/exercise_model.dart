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
