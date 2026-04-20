import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';

/// Produces a user-readable CSV of every completed set, joined with exercise
/// name + week/phase metadata so the file stands alone outside the app.
///
/// Written to a temp file because share_plus expects a path. The file is
/// overwritten on each export (single fixed name) so the cache doesn't grow
/// over the lifetime of the program.
class CsvExporter {
  final AppDatabase db;
  CsvExporter(this.db);

  /// Returns the absolute path of the written CSV.
  Future<String> exportAll() async {
    final logs = await db.sessionDao.getAllLogs();
    final sets = await db.sessionDao.getAllCompletedSetLogs();

    // In-memory lookups so the CSV build is O(N) instead of per-row queries.
    final logsById = {for (final l in logs) l.id: l};

    // Resolve blockExerciseId → exercise name via program tables.
    final beRows = await db.select(db.blockExercises).get();
    final exRows = await db.select(db.exercises).get();
    final exById = {for (final e in exRows) e.id: e};
    final exIdByBe = {for (final be in beRows) be.id: be.exerciseId};

    final buf = StringBuffer();
    buf.writeln(
      'date,week,phase,session_id,exercise,set_number,weight_kg,reps,completed_at',
    );
    for (final s in sets) {
      final log = logsById[s.workoutLogId];
      if (log == null) continue;
      final exId = exIdByBe[s.blockExerciseId];
      final exName = exId == null ? '' : (exById[exId]?.name ?? '');
      buf.writeln([
        _iso(log.date),
        log.weekNumber,
        log.phaseNumber,
        log.sessionId,
        _csvEscape(exName),
        s.setNumber,
        s.weightKg ?? '',
        s.repsCompleted ?? '',
        s.completedAt != null ? _iso(s.completedAt!) : '',
      ].join(','));
    }

    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'martial_body_log.csv'));
    await file.writeAsString(buf.toString());
    return file.path;
  }

  static String _iso(DateTime d) => d.toIso8601String();

  static String _csvEscape(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }
}
