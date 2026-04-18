import '../database/database.dart';

class BlockExerciseDetail {
  final BlockExercise blockExercise;
  final Exercise exercise;

  const BlockExerciseDetail({
    required this.blockExercise,
    required this.exercise,
  });
}

class BlockDetail {
  final Block block;
  final List<BlockExerciseDetail> exercises;

  const BlockDetail({
    required this.block,
    required this.exercises,
  });
}

class SessionDetail {
  final Session session;
  final Phase phase;
  final List<BlockDetail> blocks;

  const SessionDetail({
    required this.session,
    required this.phase,
    required this.blocks,
  });
}
