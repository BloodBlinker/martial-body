import 'package:flutter/foundation.dart';

/// Static meal-plan data model. Meal plans are reference content (the user
/// reads them, does not edit or log them), so they live as const Dart data
/// rather than in the database. Registered in [kMealPlans] by phase number.
///
/// Adding a new phase's plan: build a const [MealPlan], add it to
/// `kMealPlans`, flip `kPhaseContent[n].mealPlanAvailable` to true.
@immutable
class MealPlan {
  final int phaseNumber;
  final List<Meal> meals;
  final List<PrepNote> prepNotes;
  final MacroTotals totals;

  /// Optional note shown on deload weeks (e.g. week 4 of Phase 1).
  final String? deloadAdjustment;

  const MealPlan({
    required this.phaseNumber,
    required this.meals,
    required this.prepNotes,
    required this.totals,
    this.deloadAdjustment,
  });
}

@immutable
class Meal {
  final String name; // "Breakfast", "Lunch", etc.
  final String? timeLabel; // "7:30 AM"
  final String? subtitle; // "Pre-Workout Fuel"
  final List<MealItem> items;

  const Meal({
    required this.name,
    this.timeLabel,
    this.subtitle,
    required this.items,
  });
}

@immutable
class MealItem {
  final String name;
  final String amount; // e.g. "120g dry", "3 eggs"
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int calories;

  const MealItem({
    required this.name,
    required this.amount,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.calories,
  });
}

@immutable
class PrepNote {
  final String category; // "OATS — BREAKFAST"
  final String body;

  const PrepNote({required this.category, required this.body});
}

@immutable
class MacroTotals {
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int calories;

  const MacroTotals({
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.calories,
  });
}
