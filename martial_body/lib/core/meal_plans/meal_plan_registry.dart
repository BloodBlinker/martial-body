import 'meal_plan.dart';
import 'phase1_meal_plan.dart';
import 'phase2_meal_plan.dart';
import 'phase3_meal_plan.dart';
import 'phase4_meal_plan.dart';

/// Registry of authored meal plans by phase number. A phase is missing from
/// this map until its plan is written — pair with
/// `kPhaseContent[n].mealPlanAvailable` to gate UI.
const kMealPlans = <int, MealPlan>{
  1: phase1MealPlan,
  2: phase2MealPlan,
  3: phase3MealPlan,
  4: phase4MealPlan,
};

MealPlan? mealPlanFor(int phaseNumber) => kMealPlans[phaseNumber];
