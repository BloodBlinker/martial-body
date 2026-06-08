// Martial Body — widget tests for the Journey screen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:martial_body/core/models/achievement.dart';
import 'package:martial_body/core/providers/journey_provider.dart';
import 'package:martial_body/core/theme/app_colors.dart';
import 'package:martial_body/features/journey/journey_screen.dart';

// A minimal themed app shell — provides the AppColors extension without
// pulling in GoogleFonts (which would try to fetch fonts during tests).
Widget _host(List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(extensions: const [appColorsDark]),
        home: const JourneyScreen(),
      ),
    );

void main() {
  testWidgets('renders current week, phase path, and achievements mid-program',
      (tester) async {
    const state = JourneyState(
      currentWeek: 8,
      weeksCompleted: 7,
      totalSessions: 35,
      phaseNumber: 2,
      programComplete: false,
      unlocked: {
        AchievementId.firstStep,
        AchievementId.firstWeek,
        AchievementId.tenSessions,
        AchievementId.foundation,
      },
    );
    await tester.pumpWidget(_host([
      journeyProvider.overrideWith((ref) async => state),
    ]));
    await tester.pumpAndSettle();

    // Above-the-fold momentum + path.
    expect(find.text('Your Journey'), findsOneWidget);
    expect(find.text('Week 8'), findsOneWidget);
    expect(find.text('Engine Build'), findsOneWidget); // current phase title
    expect(find.text('7'), findsWidgets); // weeks-done stat

    // The achievements grid sits below the fold; scroll it into view (which
    // also builds the lazy list items) before asserting.
    await tester.scrollUntilVisible(
      find.text('Foundation Forged'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Foundation Forged'), findsOneWidget); // unlocked badge
    // Graduation node + the (still-locked) graduation badge both label "Fight Ready".
    expect(find.text('Fight Ready'), findsWidgets);
  });

  testWidgets('shows the complete state once the program is finished',
      (tester) async {
    const state = JourneyState(
      currentWeek: 24,
      weeksCompleted: 24,
      totalSessions: 120,
      phaseNumber: 4,
      programComplete: true,
      unlocked: {
        AchievementId.firstStep,
        AchievementId.firstWeek,
        AchievementId.tenSessions,
        AchievementId.recordBreaker,
        AchievementId.foundation,
        AchievementId.halfway,
        AchievementId.fiftySessions,
        AchievementId.combatReady,
        AchievementId.graduate,
      },
    );
    await tester.pumpWidget(_host([
      journeyProvider.overrideWith((ref) async => state),
    ]));
    await tester.pumpAndSettle();

    expect(find.text('Complete'), findsOneWidget);

    // Scroll the achievement grid into view ('Relentless' only exists there),
    // then confirm nothing is locked.
    await tester.scrollUntilVisible(
      find.text('Relentless'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Relentless'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsNothing);
  });
}
