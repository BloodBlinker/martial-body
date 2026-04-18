import 'exercise_model.dart';

/// Type of block within a session.
enum BlockType {
  warmup,
  main,
  tendon,
  conditioning,
  grip,
  core,
  posterior,
  finishing,
  cooldown,
}

/// A named block within a session (e.g. "WARMUP — 12 MIN", "MAIN BLOCK").
class BlockModel {
  final String name;
  final int blockOrder; // 0-based
  final BlockType blockType;
  final String? instructions; // special protocol text (interval details, breathing notes, etc.)
  final int? durationMinutes;
  final List<BlockExerciseModel> exercises;

  const BlockModel({
    required this.name,
    required this.blockOrder,
    required this.blockType,
    this.instructions,
    this.durationMinutes,
    required this.exercises,
  });
}
