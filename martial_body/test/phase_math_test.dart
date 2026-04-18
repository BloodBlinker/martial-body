import 'package:flutter_test/flutter_test.dart';
import 'package:martial_body/core/program/phase_math.dart';

void main() {
  group('computeWeekNumber', () {
    test('returns 1 on the programme start date', () {
      final start = DateTime(2026, 4, 1);
      expect(computeWeekNumber(start, start), 1);
    });

    test('rolls over to week 2 on day 7', () {
      final start = DateTime(2026, 4, 1);
      expect(computeWeekNumber(start, start.add(const Duration(days: 6))), 1);
      expect(computeWeekNumber(start, start.add(const Duration(days: 7))), 2);
    });

    test('clamps to 1 when "now" is before start', () {
      final start = DateTime(2026, 4, 1);
      expect(
        computeWeekNumber(start, start.subtract(const Duration(days: 10))),
        1,
      );
    });

    test('does not cap at week 24 (caller handles programme-complete)', () {
      final start = DateTime(2026, 1, 1);
      expect(computeWeekNumber(start, start.add(const Duration(days: 7 * 24))), 25);
    });
  });

  group('phaseForWeek', () {
    test('weeks 1..6 are Phase 1 (Foundation)', () {
      for (var w = 1; w <= 6; w++) {
        expect(phaseForWeek(w).number, 1, reason: 'week $w');
      }
    });

    test('weeks 7..12 are Phase 2 (Engine Build)', () {
      for (var w = 7; w <= 12; w++) {
        expect(phaseForWeek(w).number, 2, reason: 'week $w');
      }
    });

    test('weeks 13..20 are Phase 3 (Full Combat, 8 weeks)', () {
      for (var w = 13; w <= 20; w++) {
        expect(phaseForWeek(w).number, 3, reason: 'week $w');
      }
    });

    test('weeks 21..24 are Phase 4 (MMA Transition, 4 weeks)', () {
      for (var w = 21; w <= 24; w++) {
        expect(phaseForWeek(w).number, 4, reason: 'week $w');
      }
    });

    test('out-of-range weeks fall back sensibly', () {
      expect(phaseForWeek(0).number, 1);
      expect(phaseForWeek(-3).number, 1);
      expect(phaseForWeek(99).number, 4);
    });
  });

  group('isDeloadWeek', () {
    test('seeded deloads match the programme spec', () {
      expect(isDeloadWeek(4), isTrue, reason: 'Phase 1 deload');
      expect(isDeloadWeek(10), isTrue, reason: 'Phase 2 deload');
      expect(isDeloadWeek(16), isTrue, reason: 'Phase 3 mid deload');
      expect(isDeloadWeek(20), isTrue, reason: 'Phase 3 end deload');
    });

    test('non-deload training weeks report false', () {
      for (final w in const [1, 2, 3, 5, 6, 7, 11, 14, 21, 24]) {
        expect(isDeloadWeek(w), isFalse, reason: 'week $w');
      }
    });
  });

  test('24-week programme has 6 + 6 + 8 + 4 weeks', () {
    final total = kPhases.fold<int>(0, (acc, p) => acc + p.lengthWeeks);
    expect(total, kProgramWeeks);
    expect(kPhases.map((p) => p.lengthWeeks).toList(), [6, 6, 8, 4]);
  });
}
