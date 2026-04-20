// Martial Body — 24-week MMA preparation trainer
// Copyright (C) 2026 Robin Roy <robinroy3107@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/// All health calculations derived from user profile biometric data.
class HealthMetrics {
  final double bmi;
  final String bmiCategory;
  final double bmr; // Mifflin-St Jeor (kcal/day at rest)
  final double tdee; // BMR × 1.55 (moderate activity)
  final double idealWeightMin; // Devine formula lower bound
  final double idealWeightMax; // Devine formula upper bound
  final double bodyFatPercent; // Deurenberg estimate
  final double leanBodyMass; // kg
  final int proteinTargetG; // 2 g/kg lean body mass
  final int maxHeartRate; // 220 − age

  const HealthMetrics({
    required this.bmi,
    required this.bmiCategory,
    required this.bmr,
    required this.tdee,
    required this.idealWeightMin,
    required this.idealWeightMax,
    required this.bodyFatPercent,
    required this.leanBodyMass,
    required this.proteinTargetG,
    required this.maxHeartRate,
  });

  /// Returns null when required fields (age, sex, weight, height) are missing.
  static HealthMetrics? compute({
    required int? age,
    required String? sex, // 'male' | 'female'
    required double? weightKg,
    required double? heightCm,
  }) {
    if (age == null || sex == null || weightKg == null || heightCm == null) {
      return null;
    }
    if (weightKg <= 0 || heightCm <= 0 || age <= 0) return null;

    final heightM = heightCm / 100.0;
    final isMale = sex.toLowerCase() == 'male';

    // BMI
    final bmi = weightKg / (heightM * heightM);
    final bmiCategory = _bmiCategory(bmi);

    // Mifflin-St Jeor BMR
    final bmr = isMale
        ? (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5
        : (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;

    // TDEE — moderate activity (1.55)
    final tdee = bmr * 1.55;

    // Devine ideal weight (kg) — base + increment per cm above 152.4 cm
    final double devineBase = isMale ? 50.0 : 45.5;
    final extraCm = (heightCm - 152.4).clamp(0.0, double.infinity);
    final devineIdeal = devineBase + 0.9 * extraCm;
    final idealWeightMin = devineIdeal * 0.9;
    final idealWeightMax = devineIdeal * 1.1;

    // Deurenberg body fat % estimate, clamped to a physiological range so that
    // lean-body-mass and protein targets stay internally consistent with the
    // body-fat figure we surface to the user.
    final rawBodyFat =
        (1.20 * bmi) + (0.23 * age) - (10.8 * (isMale ? 1.0 : 0.0)) - 5.4;
    final bodyFatPercent = rawBodyFat.clamp(3.0, 50.0);

    final leanBodyMass = weightKg * (1 - bodyFatPercent / 100);
    final proteinTargetG = (leanBodyMass * 2).round();
    final maxHeartRate = 220 - age;

    return HealthMetrics(
      bmi: bmi,
      bmiCategory: bmiCategory,
      bmr: bmr,
      tdee: tdee,
      idealWeightMin: idealWeightMin,
      idealWeightMax: idealWeightMax,
      bodyFatPercent: bodyFatPercent,
      leanBodyMass: leanBodyMass,
      proteinTargetG: proteinTargetG,
      maxHeartRate: maxHeartRate,
    );
  }

  static String _bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }
}
