import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/database.dart';
import 'core/providers/database_provider.dart';
import 'core/seed/seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  // Seed program structure (phases, sessions, blocks, exercises).
  await Seeder(db).seedIfEmpty();

  // user_state is intentionally NOT created here. Its presence is the
  // "has onboarded" flag used by the splash screen: missing row → route to
  // /intro, otherwise → /home. The intro screen creates the row with
  // today's date when the user taps "Start Training", so Week 1 starts
  // when they actually begin rather than on app install.

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MartialBodyApp(),
    ),
  );
}
