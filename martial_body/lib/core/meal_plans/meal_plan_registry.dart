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
