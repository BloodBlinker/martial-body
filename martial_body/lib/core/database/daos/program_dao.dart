import 'package:drift/drift.dart';
import '../database.dart';
import '../../models/session_detail.dart';

part 'program_dao.g.dart';

@DriftAccessor(tables: [Phases, Sessions, Blocks, Exercises, BlockExercises])
class ProgramDao extends DatabaseAccessor<AppDatabase> with _$ProgramDaoMixin {
  ProgramDao(super.db);

  // ---------------------------------------------------------------------------
  // Inserts (used by seeder)
  // ---------------------------------------------------------------------------

  Future<int> insertPhase(PhasesCompanion companion) =>
      into(phases).insert(companion);

  Future<int> insertSession(SessionsCompanion companion) =>
      into(sessions).insert(companion);

  Future<int> insertBlock(BlocksCompanion companion) =>
      into(blocks).insert(companion);

  /// Insert exercise, or return existing id if name already exists.
  Future<int> upsertExercise(ExercisesCompanion companion) async {
    final existing = await (select(exercises)
          ..where((e) => e.name.equals(companion.name.value)))
        .getSingleOrNull();
    if (existing != null) return existing.id;
    return into(exercises).insert(companion);
  }

  Future<void> insertBlockExercise(BlockExercisesCompanion companion) =>
      into(blockExercises).insert(companion);

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  Future<Phase?> getPhaseByNumber(int number) =>
      (select(phases)..where((p) => p.number.equals(number))).getSingleOrNull();

  Future<Phase?> getPhaseById(int id) =>
      (select(phases)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<Session?> getSessionById(int id) =>
      (select(sessions)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<Session?> getSessionForDay(int phaseNumber, int weekDay) async {
    final phase = await getPhaseByNumber(phaseNumber);
    if (phase == null) return null;
    return (select(sessions)
          ..where(
              (s) => s.phaseId.equals(phase.id) & s.weekDay.equals(weekDay)))
        .getSingleOrNull();
  }

  Future<List<Session>> getSessionsForPhase(int phaseNumber) async {
    final phase = await getPhaseByNumber(phaseNumber);
    if (phase == null) return [];
    return (select(sessions)
          ..where((s) => s.phaseId.equals(phase.id))
          ..orderBy([(s) => OrderingTerm.asc(s.weekDay)]))
        .get();
  }

  Future<List<Block>> getBlocksForSession(int sessionId) =>
      (select(blocks)
            ..where((b) => b.sessionId.equals(sessionId))
            ..orderBy([(b) => OrderingTerm.asc(b.blockOrder)]))
          .get();

  Future<List<BlockExerciseDetail>> getBlockExercisesWithExercise(
      int blockId) async {
    final query = (select(blockExercises)
          ..where((be) => be.blockId.equals(blockId))
          ..orderBy([(be) => OrderingTerm.asc(be.exerciseOrder)]))
        .join([
      innerJoin(exercises, exercises.id.equalsExp(blockExercises.exerciseId)),
    ]);

    final results = await query.get();
    return results
        .map((row) => BlockExerciseDetail(
              blockExercise: row.readTable(blockExercises),
              exercise: row.readTable(exercises),
            ))
        .toList();
  }
}
