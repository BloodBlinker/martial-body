import 'package:flutter_test/flutter_test.dart';
import 'package:martial_body/core/models/health_metrics.dart';

void main() {
  group('HealthMetrics.compute', () {
    test('returns null when any required field is missing', () {
      expect(
        HealthMetrics.compute(age: null, sex: 'male', weightKg: 80, heightCm: 180),
        isNull,
      );
      expect(
        HealthMetrics.compute(age: 30, sex: null, weightKg: 80, heightCm: 180),
        isNull,
      );
      expect(
        HealthMetrics.compute(age: 30, sex: 'male', weightKg: null, heightCm: 180),
        isNull,
      );
      expect(
        HealthMetrics.compute(age: 30, sex: 'male', weightKg: 80, heightCm: null),
        isNull,
      );
    });

    test('returns null for non-positive inputs', () {
      expect(
        HealthMetrics.compute(age: 0, sex: 'male', weightKg: 80, heightCm: 180),
        isNull,
      );
      expect(
        HealthMetrics.compute(age: 30, sex: 'male', weightKg: 0, heightCm: 180),
        isNull,
      );
      expect(
        HealthMetrics.compute(age: 30, sex: 'male', weightKg: 80, heightCm: 0),
        isNull,
      );
    });

    test('golden numbers for a 30y male, 80kg, 180cm', () {
      final m = HealthMetrics.compute(
        age: 30, sex: 'male', weightKg: 80, heightCm: 180,
      )!;
      // BMI = 80 / 1.8^2 = 24.691…
      expect(m.bmi, closeTo(24.69, 0.01));
      expect(m.bmiCategory, 'Normal');
      // Mifflin-St Jeor male: 10*80 + 6.25*180 - 5*30 + 5 = 1780
      expect(m.bmr, closeTo(1780, 0.5));
      expect(m.tdee, closeTo(1780 * 1.55, 0.5));
      // Devine male: 50 + 0.9 * (180 - 152.4) = 74.84
      expect(m.idealWeightMin, closeTo(74.84 * 0.9, 0.01));
      expect(m.idealWeightMax, closeTo(74.84 * 1.1, 0.01));
      expect(m.maxHeartRate, 190);
      // Deurenberg male: 1.2*BMI + 0.23*age - 10.8 - 5.4
      // = 1.2*24.6914 + 6.9 - 10.8 - 5.4 ≈ 20.33
      expect(m.bodyFatPercent, closeTo(20.33, 0.1));
      // LBM uses the (clamped) body fat, which equals raw here.
      expect(m.leanBodyMass, closeTo(80 * (1 - m.bodyFatPercent / 100), 0.01));
      expect(m.proteinTargetG, (m.leanBodyMass * 2).round());
    });

    test('leanBodyMass stays consistent with clamped body fat', () {
      // Extreme inputs push raw Deurenberg below 3%. The displayed body fat
      // should be clamped to 3, and leanBodyMass must be computed from that
      // same clamped value (not the raw one).
      final m = HealthMetrics.compute(
        age: 18, sex: 'male', weightKg: 60, heightCm: 200,
      )!;
      expect(m.bodyFatPercent, greaterThanOrEqualTo(3.0));
      expect(m.bodyFatPercent, lessThanOrEqualTo(50.0));
      expect(m.leanBodyMass, closeTo(60 * (1 - m.bodyFatPercent / 100), 0.01));
    });

    test('female branch uses -161 BMR constant and 45.5 Devine base', () {
      final m = HealthMetrics.compute(
        age: 30, sex: 'female', weightKg: 65, heightCm: 165,
      )!;
      // BMR female: 10*65 + 6.25*165 - 5*30 - 161 = 1370.25
      expect(m.bmr, closeTo(1370.25, 0.5));
      // Devine female: 45.5 + 0.9*(165-152.4) = 56.84
      expect(m.idealWeightMin, closeTo(56.84 * 0.9, 0.01));
    });
  });
}
