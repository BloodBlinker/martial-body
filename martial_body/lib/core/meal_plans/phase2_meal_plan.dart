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

/// Phase 2 (Engine Build) meal plan. Targets: 188g protein, 308g carbs, 63g fat,
/// 2568 kcal. Week 10 is a deload — see [MealPlan.deloadAdjustment].
const phase2MealPlan = MealPlan(
  phaseNumber: 2,
  totals: MacroTotals(proteinG: 188, carbsG: 308, fatG: 63, calories: 2568),
  deloadAdjustment:
      'Remove peanuts from dinner. Reduce lunch oats by 20g. Reduce '
      'chickpeas by 20g dry.',
  meals: [
    Meal(
      name: 'Breakfast',
      timeLabel: '7:30 AM',
      items: [
        MealItem(
          name: 'Rolled Oats (cooked)',
          amount: '120g dry',
          proteinG: 16,
          carbsG: 80,
          fatG: 8,
          calories: 464,
        ),
        MealItem(
          name: 'Whole Eggs (hard-boiled)',
          amount: '3 eggs',
          proteinG: 21,
          carbsG: 2,
          fatG: 17,
          calories: 241,
        ),
        MealItem(
          name: 'Curd (low fat)',
          amount: '150g',
          proteinG: 6,
          carbsG: 4,
          fatG: 2,
          calories: 62,
        ),
        MealItem(
          name: 'Spinach (wilted, no oil)',
          amount: '80g',
          proteinG: 2,
          carbsG: 3,
          fatG: 0,
          calories: 20,
        ),
      ],
    ),
    Meal(
      name: 'Lunch',
      timeLabel: '1:00 PM',
      subtitle: 'Pre-Workout Fuel',
      items: [
        MealItem(
          name: 'Chicken Breast (grilled)',
          amount: '120g cooked',
          proteinG: 37,
          carbsG: 0,
          fatG: 4,
          calories: 184,
        ),
        MealItem(
          name: 'Oats (savory preparation)',
          amount: '70g dry',
          proteinG: 9,
          carbsG: 47,
          fatG: 5,
          calories: 274,
        ),
        MealItem(
          name: 'Chickpea Mix (pressure-cooked)',
          amount: '85g dry',
          proteinG: 17,
          carbsG: 52,
          fatG: 5,
          calories: 321,
        ),
        MealItem(
          name: 'Green Gram Whole (boiled)',
          amount: '60g dry',
          proteinG: 14,
          carbsG: 46,
          fatG: 0,
          calories: 240,
        ),
        MealItem(
          name: 'Cabbage + Carrot (stir-fry)',
          amount: '150g mix',
          proteinG: 2,
          carbsG: 11,
          fatG: 1,
          calories: 61,
        ),
      ],
    ),
    Meal(
      name: 'Dinner',
      timeLabel: '8:30 PM',
      subtitle: 'Post-Workout',
      items: [
        MealItem(
          name: 'Mackerel / Sardines (grilled)',
          amount: '130g',
          proteinG: 25,
          carbsG: 0,
          fatG: 7,
          calories: 159,
        ),
        MealItem(
          name: 'Soya Chunks (dry, rehydrated)',
          amount: '30g dry',
          proteinG: 16,
          carbsG: 8,
          fatG: 0,
          calories: 96,
        ),
        MealItem(
          name: 'Mung Dal (boiled)',
          amount: '55g dry',
          proteinG: 13,
          carbsG: 33,
          fatG: 1,
          calories: 193,
        ),
        MealItem(
          name: 'Beetroot (boiled)',
          amount: '100g',
          proteinG: 2,
          carbsG: 10,
          fatG: 0,
          calories: 48,
        ),
        MealItem(
          name: 'Onion + Beans (sautéed)',
          amount: '100g mix',
          proteinG: 2,
          carbsG: 8,
          fatG: 1,
          calories: 53,
        ),
      ],
    ),
    Meal(
      name: 'Additional',
      items: [
        MealItem(
          name: 'Peanuts (roasted, unsalted)',
          amount: '25g',
          proteinG: 6,
          carbsG: 4,
          fatG: 12,
          calories: 152,
        ),
      ],
    ),
  ],
  prepNotes: [
    PrepNote(
      category: 'WEDNESDAY SPRINT DAY',
      body: 'Add 20g dry oats to lunch (+77 kcal, +13g carbs) on Wednesdays '
          'only. Sprint intervals require full glycogen — this is mandatory.',
    ),
    PrepNote(
      category: 'POST-WORKOUT TIMING',
      body: 'Dinner within 60 minutes of finishing training. Wednesday and '
          'Thursday nights are the most important recovery windows of the '
          'week — do not skip or reduce dinner after interval days.',
    ),
    PrepNote(
      category: 'HYDRATION',
      body: '3.5 litres daily. 4 litres on Wednesday. Add a pinch of rock '
          'salt to one litre on heavy sweat days (Kerala summers and '
          'pre-monsoon).',
    ),
    PrepNote(
      category: 'CHICKEN',
      body: 'Grill or steam. No oil. Marinate with ginger, garlic, and '
          'turmeric only.',
    ),
    PrepNote(
      category: 'FISH SUBSTITUTE',
      body: 'In monsoon if mackerel is unavailable or expensive, substitute '
          'sardines (mathi), tilapia, or pomfret at the same gram weight. '
          'Nutrition profile is equivalent.',
    ),
    PrepNote(
      category: 'LEGUMES',
      body: 'Pressure-cook all. Soak chickpeas and green gram for 8 hours '
          'before cooking. Moong dal for 4 hours.',
    ),
    PrepNote(
      category: 'SOYA CHUNKS',
      body: 'Rehydrate in hot water for 15 minutes. Squeeze dry. Stir-fry '
          'with a maximum of half teaspoon oil.',
    ),
    PrepNote(
      category: 'SPINACH AT BREAKFAST',
      body: 'Added in Phase 2 (80g) for nitrates and micronutrient density. '
          'Wilt in a dry pan — no oil needed.',
    ),
    PrepNote(
      category: 'PEANUTS',
      body: 'Dry-roasted only. Measure 25g precisely — calorie-dense.',
    ),
  ],
);
