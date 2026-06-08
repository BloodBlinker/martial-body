// Martial Body — 24-week MMA preparation trainer
// Tests for completion-anchored scheduling miss math + personal records.

import 'package:flutter_test/flutter_test.dart';
import 'package:martial_body/core/models/lift_entry.dart';
import 'package:martial_body/core/program/schedule.dart';
import 'package:martial_body/core/providers/records_provider.dart';

void main() {
  // Reference week: Mon 2026-06-08 … Fri 2026-06-12, next Mon 2026-06-15.
  final mon = DateTime(2026, 6, 8);
  final tue = DateTime(2026, 6, 9);
  final wed = DateTime(2026, 6, 10);
  final thu = DateTime(2026, 6, 11);
  final fri = DateTime(2026, 6, 12);
  final nextMon = DateTime(2026, 6, 15);

  group('missedWeekdays', () {
    test('Mon✓ Tue✗ Wed✓ Thu✗ → 2 misses by Friday (week fails)', () {
      final misses = missedWeekdays(
        anchor: mon,
        completedDates: {mon, wed},
        cutoff: fri, // Mon–Thu have elapsed
      );
      expect(misses, 2);
    });

    test('same scenario shows only 1 miss while it is still Thursday', () {
      final misses = missedWeekdays(
        anchor: mon,
        completedDates: {mon, wed},
        cutoff: thu, // only Mon, Tue elapsed
      );
      expect(misses, 1);
    });

    test('today is never counted as a miss yet', () {
      // Mon done, it is now Tue — Tue (today) must not count.
      final misses = missedWeekdays(
        anchor: mon,
        completedDates: {mon},
        cutoff: tue,
      );
      expect(misses, 0);
    });

    test('one missed Friday after a full Mon–Thu still passes (≤1 miss)', () {
      final misses = missedWeekdays(
        anchor: mon,
        completedDates: {mon, tue, wed, thu},
        cutoff: nextMon, // whole week elapsed
      );
      expect(misses, 1);
    });

    test('weekends never count toward misses', () {
      // Did the full week; evaluate well into the next week.
      final misses = missedWeekdays(
        anchor: mon,
        completedDates: {mon, tue, wed, thu, fri},
        cutoff: DateTime(2026, 6, 17),
      );
      expect(misses, 0);
    });

    test('a brand-new Wednesday start does not count Mon/Tue before it', () {
      final misses = missedWeekdays(
        anchor: wed, // installed Wednesday
        completedDates: {wed, thu, fri},
        cutoff: nextMon,
      );
      expect(misses, 0);
    });
  });

  group('mondayOf', () {
    test('maps any weekday to its Monday', () {
      expect(mondayOf(thu), mon);
      expect(mondayOf(DateTime(2026, 6, 14)), mon); // Sunday → same week Monday
      expect(mondayOf(nextMon), nextMon);
    });
  });

  group('computePersonalRecords', () {
    test('picks heaviest weight and best estimated 1RM per exercise', () {
      final lifts = [
        LiftEntry(exerciseId: 1, exerciseName: 'Squat', weightKg: 100, reps: 5, date: mon),
        LiftEntry(exerciseId: 1, exerciseName: 'Squat', weightKg: 110, reps: 1, date: wed),
        LiftEntry(exerciseId: 2, exerciseName: 'Press', weightKg: 40, reps: 8, date: mon),
      ];
      final prs = computePersonalRecords(lifts);
      final squat = prs.firstWhere((p) => p.exerciseId == 1);
      expect(squat.maxWeightKg, 110);
      expect(squat.repsAtMax, 1);
      // 100×5 → e1RM ≈ 116.7 beats 110×1 → 110.
      expect(squat.bestE1rmKg, closeTo(116.67, 0.1));
      // Sorted by best e1RM desc → Squat first.
      expect(prs.first.exerciseId, 1);
    });
  });
}
