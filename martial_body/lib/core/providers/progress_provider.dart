import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import 'database_provider.dart';

final progressProvider = StreamProvider<List<WorkoutLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.sessionDao.watchAllLogs();
});
