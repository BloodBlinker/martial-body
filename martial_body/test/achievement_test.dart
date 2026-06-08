// Martial Body — tests for achievement unlock logic.

import 'package:flutter_test/flutter_test.dart';
import 'package:martial_body/core/models/achievement.dart';

void main() {
  group('unlockedAchievements', () {
    test('a fresh user with nothing logged unlocks nothing', () {
      final got = unlockedAchievements(const AchievementCriteria(
        weeksCompleted: 0,
        totalSessions: 0,
        programComplete: false,
        hasPersonalRecord: false,
      ));
      expect(got, isEmpty);
    });

    test('one session unlocks First Step only', () {
      final got = unlockedAchievements(const AchievementCriteria(
        weeksCompleted: 0,
        totalSessions: 1,
        programComplete: false,
        hasPersonalRecord: false,
      ));
      expect(got, {AchievementId.firstStep});
    });

    test('mid-program user unlocks the expected cumulative set', () {
      final got = unlockedAchievements(const AchievementCriteria(
        weeksCompleted: 12,
        totalSessions: 55,
        programComplete: false,
        hasPersonalRecord: true,
      ));
      expect(
        got,
        containsAll(<AchievementId>{
          AchievementId.firstStep,
          AchievementId.firstWeek,
          AchievementId.tenSessions,
          AchievementId.recordBreaker,
          AchievementId.foundation,
          AchievementId.halfway,
          AchievementId.fiftySessions,
        }),
      );
      // Not yet: Phase 3 done, or graduation.
      expect(got.contains(AchievementId.combatReady), isFalse);
      expect(got.contains(AchievementId.graduate), isFalse);
    });

    test('program completion unlocks every achievement', () {
      final got = unlockedAchievements(const AchievementCriteria(
        weeksCompleted: 24,
        totalSessions: 120,
        programComplete: true,
        hasPersonalRecord: true,
      ));
      expect(got.length, kAchievements.length);
    });
  });
}
