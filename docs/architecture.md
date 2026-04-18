# Martial Body — Architecture Document

## 1. Flutter Project Directory Structure

```
martial_body/
├── lib/
│   ├── main.dart                    # App entry point, ProviderScope, DB init
│   ├── app.dart                     # MaterialApp + GoRouter setup
│   │
│   ├── core/
│   │   ├── database/
│   │   │   ├── database.dart        # Drift AppDatabase class
│   │   │   ├── database.g.dart      # Generated (build_runner)
│   │   │   ├── tables/
│   │   │   │   ├── phases.dart
│   │   │   │   ├── sessions.dart
│   │   │   │   ├── blocks.dart
│   │   │   │   ├── exercises.dart
│   │   │   │   ├── block_exercises.dart
│   │   │   │   ├── workout_logs.dart
│   │   │   │   ├── set_logs.dart
│   │   │   │   └── user_state.dart
│   │   │   └── daos/
│   │   │       ├── program_dao.dart  # Read-only program data queries
│   │   │       ├── session_dao.dart  # Workout log + set log writes
│   │   │       └── user_dao.dart     # User state read/write
│   │   │
│   │   ├── seed/
│   │   │   ├── seeder.dart          # Orchestrates full seed on first launch
│   │   │   ├── phase1_seed.dart     # Phase 1 sessions, blocks, exercises
│   │   │   ├── phase2_seed.dart
│   │   │   ├── phase3_seed.dart
│   │   │   └── phase4_seed.dart
│   │   │
│   │   ├── models/
│   │   │   ├── session_schedule.dart  # Runtime model: today's session info
│   │   │   ├── active_session.dart    # Live session state model
│   │   │   └── progress_summary.dart  # Computed progress model
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart         # MaterialTheme — dark, high-contrast
│   │   │   └── app_colors.dart        # Phase color palette + semantic colors
│   │   │
│   │   └── utils/
│   │       ├── week_calculator.dart   # program_start_date → week/phase/day
│   │       └── deload_calculator.dart # set count modifier for deload/Phase 4
│   │
│   └── features/
│       ├── onboarding/
│       │   ├── onboarding_screen.dart
│       │   └── providers/
│       │       └── onboarding_provider.dart
│       │
│       ├── home/
│       │   ├── home_screen.dart
│       │   ├── widgets/
│       │   │   ├── today_session_card.dart
│       │   │   ├── week_progress_bar.dart
│       │   │   ├── phase_badge.dart
│       │   │   └── phase_transition_card.dart
│       │   └── providers/
│       │       └── home_provider.dart
│       │
│       ├── session/
│       │   ├── session_overview_screen.dart
│       │   ├── active_session_screen.dart
│       │   ├── widgets/
│       │   │   ├── block_card.dart
│       │   │   ├── exercise_card.dart
│       │   │   ├── set_tracker.dart
│       │   │   ├── rest_timer.dart
│       │   │   ├── interval_timer.dart
│       │   │   ├── tempo_display.dart
│       │   │   └── shoulder_warning_banner.dart
│       │   └── providers/
│       │       └── active_session_provider.dart
│       │
│       ├── progress/
│       │   ├── progress_screen.dart
│       │   ├── widgets/
│       │   │   ├── session_history_list.dart
│       │   │   └── phase_progress_bar.dart
│       │   └── providers/
│       │       └── progress_provider.dart
│       │
│       └── program/
│           ├── program_screen.dart
│           ├── widgets/
│           │   ├── phase_section.dart
│           │   └── week_row.dart
│           └── providers/
│               └── program_provider.dart
│
├── test/
│   ├── core/
│   │   ├── week_calculator_test.dart
│   │   └── deload_calculator_test.dart
│   └── features/
│       └── session/
│           └── active_session_provider_test.dart
│
├── android/
│   └── app/
│       ├── build.gradle             # No play services, no firebase
│       └── src/main/
│           └── AndroidManifest.xml  # No internet permission
│
└── pubspec.yaml
```

---

## 2. pubspec.yaml

```yaml
name: martial_body
description: 24-week MMA preparation program — fully offline.
publish_to: none
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # Database — Drift with SQLite
  drift: ^2.22.0
  sqlite3_flutter_libs: ^0.5.24   # Bundles SQLite — no Google Play required
  path_provider: ^2.1.4
  path: ^1.9.0

  # State management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

  # Navigation
  go_router: ^14.6.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  drift_dev: ^2.22.0
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.1
  riverpod_lint: ^2.6.1
  custom_lint: ^0.7.5
  flutter_lints: ^4.0.0
```

**Packages explicitly NOT included:**
- firebase_core, firebase_messaging (proprietary, breaks F-Droid)
- google_sign_in (no accounts)
- in_app_purchase (no monetization)
- drift_flutter (wraps sqlite3_flutter_libs but adds extra deps — use sqlite3_flutter_libs directly)

---

## 3. Drift Database Schema

### 3.1 Table Definitions

```dart
// lib/core/database/tables/phases.dart
import 'package:drift/drift.dart';

class Phases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();           // 1–4
  TextColumn get name => text()();               // "Foundation", "Engine Build", etc.
  TextColumn get subtitle => text()();           // Full subtitle from program
  IntColumn get weeksStart => integer()();       // 1, 7, 13, 21
  IntColumn get weeksEnd => integer()();         // 6, 12, 20, 24
  RealColumn get intensityMin => real()();       // 0.60, 0.75, 0.85, 0.85
  RealColumn get intensityMax => real()();       // 0.70, 0.80, 0.90, 0.85
  TextColumn get deloadWeeks => text()();        // JSON: "[4]", "[10]", "[16,20]", "[]"
  TextColumn get overviewText => text()();       // Full overview paragraph
}

// lib/core/database/tables/sessions.dart
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get phaseId => integer().references(Phases, #id)();
  IntColumn get weekDay => integer()();          // 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri
  TextColumn get name => text()();               // "Lower Body Mobility + Unilateral Strength"
  TextColumn get focus => text()();              // "Hip restoration · VMO activation · ..."
  IntColumn get estimatedMinutes => integer()(); // 70-90
}

// lib/core/database/tables/blocks.dart
class Blocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  TextColumn get name => text()();               // "WARMUP — 12 MIN", "MAIN BLOCK", etc.
  IntColumn get blockOrder => integer()();       // 0-based ordering
  TextColumn get blockType => text()();          // warmup | main | tendon | conditioning |
                                                  // grip | core | posterior | finishing | cooldown
  TextColumn get instructions => text().nullable()(); // Special protocol text (interval details, etc.)
  IntColumn get durationMinutes => integer().nullable()();
}

// lib/core/database/tables/exercises.dart
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()();  // strength | mobility | cardio | grip | core | neck | etc.
}

// lib/core/database/tables/block_exercises.dart
class BlockExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get exerciseOrder => integer()();
  IntColumn get sets => integer().nullable()();       // null for cooldown stretches
  TextColumn get reps => text().nullable()();         // "12", "8/leg", "30–45s", "Max time", "Failure"
  TextColumn get tempo => text().nullable()();        // "3-1-1-0", "Static", "X", "Controlled", "Slow"
  IntColumn get restSeconds => integer().nullable()(); // null = not specified
  TextColumn get notes => text().nullable()();
  BoolColumn get isNew => boolean().withDefault(const Constant(false))();
}

// lib/core/database/tables/workout_logs.dart
class WorkoutLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get weekNumber => integer()();       // 1–24
  IntColumn get phaseNumber => integer()();      // 1–4
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

// lib/core/database/tables/set_logs.dart
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutLogId => integer().references(WorkoutLogs, #id)();
  IntColumn get blockExerciseId => integer().references(BlockExercises, #id)();
  IntColumn get setNumber => integer()();        // 1-based
  IntColumn get repsCompleted => integer().nullable()();
  RealColumn get weightKg => real().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

// lib/core/database/tables/user_state.dart
class UserState extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get programStartDate => dateTime()();
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
}
```

### 3.2 AppDatabase class

```dart
// lib/core/database/database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/phases.dart';
import 'tables/sessions.dart';
import 'tables/blocks.dart';
import 'tables/exercises.dart';
import 'tables/block_exercises.dart';
import 'tables/workout_logs.dart';
import 'tables/set_logs.dart';
import 'tables/user_state.dart';
import '../daos/program_dao.dart';
import '../daos/session_dao.dart';
import '../daos/user_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Phases, Sessions, Blocks, Exercises,
    BlockExercises, WorkoutLogs, SetLogs, UserState,
  ],
  daos: [ProgramDao, SessionDao, UserDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
  );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'martial_body.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
```

---

## 4. Data Seeding Strategy

The database is seeded once on first launch (detected by `user_state` table being empty). Seeding is synchronous within a transaction and takes ~100ms.

### 4.1 Seeder structure

```dart
// lib/core/seed/seeder.dart
import '../database/database.dart';

class Seeder {
  final AppDatabase db;
  Seeder(this.db);

  Future<void> seedIfEmpty() async {
    final hasData = await db.userDao.hasUserState();
    if (hasData) return;

    await db.transaction(() async {
      await _seedPhase1();
      await _seedPhase2();
      await _seedPhase3();
      await _seedPhase4();
    });
  }

  Future<void> _seedPhase1() async {
    // Insert phase
    final phaseId = await db.into(db.phases).insert(PhasesCompanion.insert(
      number: 1,
      name: 'Foundation',
      subtitle: 'Rebuild Movement, Gut & Engine',
      weeksStart: 1,
      weeksEnd: 6,
      intensityMin: 0.60,
      intensityMax: 0.70,
      deloadWeeks: '[4]',
      overviewText: 'Your body has been in irregular stress for 2–3 months...',
    ));

    // Insert Monday session
    final monId = await db.into(db.sessions).insert(SessionsCompanion.insert(
      phaseId: phaseId,
      weekDay: 1, // Monday
      name: 'Lower Body Mobility + Unilateral Strength',
      focus: 'Hip restoration · VMO activation · Arch & ankle prep · Asymmetry correction',
      estimatedMinutes: 80,
    ));

    // Insert warmup block
    final warmupId = await db.into(db.blocks).insert(BlocksCompanion.insert(
      sessionId: monId,
      name: 'WARMUP — 12 MIN',
      blockOrder: 0,
      blockType: 'warmup',
    ));

    // Seed exercises (upsert pattern — exercises shared across phases)
    final shortFootId = await _upsertExercise('Short Foot Exercise', 'mobility');
    // ... repeat for all exercises

    // Insert block_exercises
    await db.into(db.blockExercises).insert(BlockExercisesCompanion.insert(
      blockId: warmupId,
      exerciseId: shortFootId,
      exerciseOrder: 0,
      sets: const Value(3),
      reps: const Value('20s/foot'),
      tempo: const Value('Static'),
      notes: const Value('Arch activation before any loading'),
      isNew: const Value(true),
    ));
    // ... all exercises for all blocks
  }

  Future<int> _upsertExercise(String name, String category) async {
    final existing = await (db.select(db.exercises)
      ..where((e) => e.name.equals(name)))
      .getSingleOrNull();
    if (existing != null) return existing.id;
    return db.into(db.exercises).insert(
      ExercisesCompanion.insert(name: name, category: category),
    );
  }
}
```

### 4.2 Phase 4 Seeding

Phase 4 sessions reference Phase 3 templates but with a `phaseId` pointing to Phase 4. The volume reduction (−30/−40/−50%) is NOT stored in the database — it is computed at runtime based on the current week number within Phase 4.

Phase 4 Wednesday and Friday also include shadowboxing as an additional block_exercise entry starting from week 23.

---

## 5. Navigation (go_router)

```dart
// lib/app.dart
final _router = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final isOnboarded = ref.read(userStateProvider).hasValue &&
        ref.read(userStateProvider).value!.onboardingComplete;
    if (!isOnboarded && state.fullPath != '/onboarding') return '/onboarding';
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (_, __, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(
          path: '/session/:sessionId',
          builder: (_, state) => SessionOverviewScreen(
            sessionId: int.parse(state.pathParameters['sessionId']!),
          ),
          routes: [
            GoRoute(
              path: 'active',
              builder: (_, state) => ActiveSessionScreen(
                sessionId: int.parse(state.pathParameters['sessionId']!),
              ),
            ),
          ],
        ),
        GoRoute(path: '/progress', builder: (_, __) => const ProgressScreen()),
        GoRoute(path: '/program', builder: (_, __) => const ProgramScreen()),
      ],
    ),
  ],
);
```

**Navigation flow:**
- Onboarding → Home (one-time)
- Home → SessionOverview (tap Today's Session card)
- SessionOverview → ActiveSession (tap Start Session)
- ActiveSession → Home (on completion)
- Bottom nav: Home ↔ Progress ↔ Program (session is entered from home, not bottom nav)

---

## 6. Riverpod State Plan

```dart
// lib/core/database/database.dart (provider)
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

// lib/features/home/providers/home_provider.dart
@riverpod
Future<SessionSchedule?> todaySchedule(TodayScheduleRef ref) async {
  final db = ref.watch(appDatabaseProvider);
  final userState = await db.userDao.getUserState();
  if (userState == null) return null;
  
  final calculator = WeekCalculator(userState.programStartDate);
  final week = calculator.currentWeek;
  final phase = calculator.currentPhase;
  final day = DateTime.now().weekday; // 1=Mon, 7=Sun
  
  if (!calculator.isTrainingDay(day)) return null;
  
  final session = await db.programDao.getSession(phaseNumber: phase, weekDay: day);
  if (session == null) return null;
  
  return SessionSchedule(
    session: session,
    weekNumber: week,
    phaseNumber: phase,
    isDeload: calculator.isDeloadWeek(week),
    volumeModifier: calculator.volumeModifier(week, phase),
  );
}

// lib/features/session/providers/active_session_provider.dart
@riverpod
class ActiveSession extends _$ActiveSession {
  @override
  ActiveSessionState build(int sessionId) => ActiveSessionState.initial(sessionId);

  void markSetComplete(int blockExerciseId, int setNumber, {double? weightKg, int? reps}) {
    // Updates set_logs in DB, advances state
  }

  void advanceToNextExercise() { ... }
  void advanceToPreviousExercise() { ... }
  void completeSession() { ... }
}

@immutable
class ActiveSessionState {
  final int sessionId;
  final List<Block> blocks;
  final int currentBlockIndex;
  final int currentExerciseIndex;
  final Map<int, List<bool>> setCompletions; // blockExerciseId → [set1done, set2done, ...]
  final bool isComplete;
  // ...
}
```

---

## 7. Week Calculator Logic

```dart
// lib/core/utils/week_calculator.dart
class WeekCalculator {
  final DateTime programStartDate;

  WeekCalculator(this.programStartDate);

  int get currentWeek {
    final days = DateTime.now().difference(programStartDate).inDays;
    return (days ~/ 7) + 1; // 1-based
  }

  int get currentPhase {
    final w = currentWeek;
    if (w <= 6) return 1;
    if (w <= 12) return 2;
    if (w <= 20) return 3;
    return 4;
  }

  bool isDeloadWeek(int week) => const [4, 10, 16, 20].contains(week);

  bool isTrainingDay(int weekday) {
    if (currentPhase < 4) return weekday >= 1 && weekday <= 5; // Mon–Fri
    return const [1, 2, 3, 5].contains(weekday); // Mon/Tue/Wed/Fri (no Thu)
  }

  /// Returns set count multiplier for deload and Phase 4 taper.
  double volumeModifier(int week, int phase) {
    if (isDeloadWeek(week)) return 0.6; // -40%
    if (phase == 4) {
      if (week <= 22) return 0.7;  // -30%
      if (week == 23) return 0.6;  // -40%
      return 0.5;                   // -50% (week 24)
    }
    return 1.0;
  }

  /// Interval protocol for Wednesday conditioning based on week.
  String? intervalProtocol(int week) {
    if (week <= 6) return null; // LISS only
    if (week <= 8) return '6 × 20s ALL OUT / 40s walk';
    if (week <= 10) return '8 × 20s ALL OUT / 40s walk';
    if (week <= 12) return '8 × 20s ALL OUT / 35s walk';
    return '8 × 15s ALL OUT / 45s active recovery'; // Phase 3+
  }

  bool hasShadowboxing(int week) => week >= 23;
}
```

---

## 8. F-Droid Compliance

### AndroidManifest.xml — permissions to INCLUDE:
```xml
<!-- None required — fully offline app -->
```

### Permissions to EXCLUDE:
- `INTERNET` — not needed, not wanted
- `ACCESS_NETWORK_STATE` — not needed
- `RECEIVE_BOOT_COMPLETED` — not using background sync

### build.gradle (app-level):
```groovy
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.robinroy.martialbody"
        minSdkVersion 21
        targetSdkVersion 34
    }
}

dependencies {
    // NO: implementation 'com.google.android.gms:play-services-*'
    // NO: implementation 'com.google.firebase:*'
    // sqlite3_flutter_libs handles native SQLite — no Google dependency
}
```

### F-Droid Anti-Features check:
- No network calls → no ANTI-FEATURES: NonFreeNet
- No tracking → no ANTI-FEATURES: Tracking
- No non-free deps → no ANTI-FEATURES: NonFreeDep
- No ads → no ANTI-FEATURES: Ads

---

## 9. Build Commands

```bash
# 1. Create Flutter project
/home/robinroy/flutter/bin/flutter create \
  --org com.robinroy \
  --project-name martial_body \
  --platforms android \
  martial_body

# 2. Generate Drift + Riverpod code
cd martial_body
dart run build_runner build --delete-conflicting-outputs

# 3. Run tests
/home/robinroy/flutter/bin/flutter test

# 4. Build APK (F-Droid compatible — no split per ABI for simplicity)
/home/robinroy/flutter/bin/flutter build apk --release

# 5. Build Android App Bundle
/home/robinroy/flutter/bin/flutter build appbundle --release
```

---

## 10. Theme & Visual Design

**Color palette:**
- Background: `#0D0D0D` (near black)
- Surface: `#1A1A1A`
- Phase 1 accent: `#4CAF50` (green — foundation, growth)
- Phase 2 accent: `#FF9800` (orange — building fire)
- Phase 3 accent: `#F44336` (red — combat intensity)
- Phase 4 accent: `#2196F3` (blue — taper, precision)
- Deload highlight: `#FFC107` (amber)
- Text primary: `#FFFFFF`
- Text secondary: `#9E9E9E`

**Typography:** System font (Roboto on Android). No custom fonts — keeps APK small and F-Droid simple.

**Sessions under 500 lines:** All screen widgets must be broken into sub-widgets if approaching 500 lines. Feature-first organization ensures no god-files.
