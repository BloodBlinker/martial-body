# Martial Body

A 24-week MMA preparation programme delivered as an offline-first Flutter app.

The programme is split into four phases (Foundation → Engine Build → Full
Combat → MMA Transition), five training days per week plus active-recovery
weekends, and seeded deload weeks. Every exercise, block, and weekly structure
is held in an on-device SQLite database so the app is fully usable on a flight,
in a gym basement, or anywhere else without a connection.

## Tech stack

- Flutter / Dart (SDK >=3.3.0)
- [`drift`](https://pub.dev/packages/drift) 2.22 — SQLite with typed DAOs
- [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) 2.6 — state
- [`go_router`](https://pub.dev/packages/go_router) 14.6 — navigation
- [`fl_chart`](https://pub.dev/packages/fl_chart) 0.68 — progress charts
- `sqlite3_flutter_libs` for bundled SQLite

## Running locally

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regenerate drift
flutter run
```

First launch seeds the programme tables and stores "today" as the user's
week-1 start date. Progress, programme, and profile screens are driven off
the seeded data and the user's workout logs.

## Project layout

```
lib/
  app.dart                     MaterialApp.router + bottom-nav shell
  main.dart                    bootstrap: database, seeder, providers
  core/
    database/                  drift schema, tables, DAOs, migrations
    models/                    UI-facing view models (HealthMetrics, etc.)
    program/phase_math.dart    single source of truth for phase boundaries
    providers/                 Riverpod providers (home, session, analytics…)
    seed/                      phase_1 data + seeder
    theme/                     dark colour palette + ThemeData
  features/
    home/                      Today dashboard
    session/                   Session overview + active logging
    progress/                  Charts, analytics
    program/                   24-week calendar
    profile/                   Biometric form + derived health metrics
```

## Testing

```bash
flutter test
```

Key invariants covered (see [P3-32](martial_body/test/)):

- `HealthMetrics.compute` golden numbers (BMI, BMR, Devine, Deurenberg)
- `phase_math` boundaries for every week 1–24, including deloads
- DAO round-trips for workout logs and set logs
