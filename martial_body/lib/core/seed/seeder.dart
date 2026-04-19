import 'dart:convert';
import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/phase_model.dart';
import '../models/session_model.dart';
import 'phase1_data.dart';
import 'phase2_data.dart';
import 'phase3_data.dart';
import 'phase4_data.dart';

/// Seeds the program structure (phases, sessions, blocks, exercises) for every
/// phase that has content authored. User state (program start date) is managed
/// separately in main.dart so each install starts from the real first-launch
/// date, not a hardcoded value.
///
/// Seeding is idempotent per-phase: on app upgrade, newly authored phases are
/// inserted without disturbing existing ones.
class Seeder {
  final AppDatabase _db;

  Seeder(this._db);

  Future<void> seedIfEmpty() async {
    await _seedPhaseIfMissing(phase1, phase1Sessions);
    await _seedPhaseIfMissing(phase2, phase2Sessions);
    await _seedPhaseIfMissing(phase3, phase3Sessions);
    await _seedPhaseIfMissing(phase4, phase4Sessions);
  }

  Future<void> _seedPhaseIfMissing(
    PhaseModel phase,
    List<SessionModel> sessions,
  ) async {
    final existing = await _db.programDao.getPhaseByNumber(phase.number);
    if (existing != null) return;

    // Atomic per-phase: if the process is killed mid-seed, nothing is
    // committed, so the next launch re-runs this phase instead of continuing
    // from a partial state that fails the getPhaseByNumber check but is
    // missing sessions.
    await _db.transaction(() async {
      final phaseId = await _db.programDao.insertPhase(PhasesCompanion.insert(
        number: phase.number,
        name: phase.name,
        subtitle: phase.subtitle,
        weeksStart: phase.weeksStart,
        weeksEnd: phase.weeksEnd,
        intensityMin: phase.intensityMin,
        intensityMax: phase.intensityMax,
        deloadWeeks: jsonEncode(phase.deloadWeeks),
        overviewText: phase.overviewText,
      ));

      for (final session in sessions) {
        final sessionId =
            await _db.programDao.insertSession(SessionsCompanion.insert(
          phaseId: phaseId,
          weekDay: session.weekDay,
          name: session.name,
          focus: session.focus,
          estimatedMinutes: session.estimatedMinutes,
        ));

        for (final block in session.blocks) {
          final blockId =
              await _db.programDao.insertBlock(BlocksCompanion.insert(
            sessionId: sessionId,
            name: block.name,
            blockOrder: block.blockOrder,
            blockType: block.blockType.name,
            instructions: Value(block.instructions),
            durationMinutes: Value(block.durationMinutes),
          ));

          for (final be in block.exercises) {
            final exerciseId = await _db.programDao
                .upsertExercise(ExercisesCompanion.insert(
              name: be.exercise.name,
              category: be.exercise.category,
            ));

            await _db.programDao
                .insertBlockExercise(BlockExercisesCompanion.insert(
              blockId: blockId,
              exerciseId: exerciseId,
              exerciseOrder: be.exerciseOrder,
              sets: Value(be.sets),
              reps: Value(be.reps),
              tempo: Value(be.tempo),
              restSeconds: Value(be.restSeconds),
              notes: Value(be.notes),
              isNew: Value(be.isNew),
            ));
          }
        }
      }
    });
  }
}
