import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

// Overridden in main.dart with the real AppDatabase instance before runApp.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main');
});
