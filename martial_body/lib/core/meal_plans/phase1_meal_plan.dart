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

/// Phase 1 (Foundation) meal plan. Targets: 174g protein, 288g carbs, 60g fat,
/// 2380 kcal. Week 4 is a deload — see [MealPlan.deloadAdjustment].
const phase1MealPlan = MealPlan(
  phaseNumber: 1,
  totals: MacroTotals(proteinG: 174, carbsG: 288, fatG: 60, calories: 2380),
  deloadAdjustment:
      'Reduce oats at both meals by 20g each. Skip peanuts. Eat 2 eggs '
      'at breakfast instead of 3.',
  meals: [
    Meal(
      name: 'Breakfast',
      timeLabel: '7:30 AM',
      items: [
        MealItem(
          name: 'Rolled Oats (cooked, no sugar)',
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
          name: 'Curd / Low-fat Dahi',
          amount: '100g',
          proteinG: 4,
          carbsG: 3,
          fatG: 2,
          calories: 46,
        ),
      ],
    ),
    Meal(
      name: 'Lunch',
      timeLabel: '1:00 PM',
      subtitle: 'Pre-Workout Fuel',
      items: [
        MealItem(
          name: 'Chicken Breast (grilled, no oil)',
          amount: '100g cooked',
          proteinG: 31,
          carbsG: 0,
          fatG: 4,
          calories: 160,
        ),
        MealItem(
          name: 'Oats (savory — onion/salt)',
          amount: '60g dry',
          proteinG: 8,
          carbsG: 40,
          fatG: 5,
          calories: 233,
        ),
        MealItem(
          name: 'Chickpea Mix (pressure-cooked)',
          amount: '80g dry',
          proteinG: 16,
          carbsG: 49,
          fatG: 5,
          calories: 301,
        ),
        MealItem(
          name: 'Green Gram Whole (boiled)',
          amount: '50g dry',
          proteinG: 12,
          carbsG: 38,
          fatG: 0,
          calories: 200,
        ),
        MealItem(
          name: 'Cabbage + Carrot + Onion (stir-fry)',
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
          name: 'Indian Mackerel / Sardines (grilled)',
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
          name: 'Mung Dal (soaked & boiled)',
          amount: '55g dry',
          proteinG: 13,
          carbsG: 33,
          fatG: 1,
          calories: 193,
        ),
        MealItem(
          name: 'Beetroot (boiled)',
          amount: '150g',
          proteinG: 2,
          carbsG: 14,
          fatG: 0,
          calories: 64,
        ),
        MealItem(
          name: 'Spinach + Beans (sautéed, minimal oil)',
          amount: '100g mix',
          proteinG: 3,
          carbsG: 7,
          fatG: 0,
          calories: 40,
        ),
      ],
    ),
    Meal(
      name: 'Additional',
      items: [
        MealItem(
          name: 'Peanuts (roasted, unsalted)',
          amount: '20g',
          proteinG: 5,
          carbsG: 3,
          fatG: 10,
          calories: 122,
        ),
      ],
    ),
  ],
  prepNotes: [
    PrepNote(
      category: 'OATS — BREAKFAST',
      body: 'Cook 120g dry oats in water. No milk, no sugar. Add a pinch of '
          'salt and turmeric. If power is cut in the morning, soak oats the '
          'night before — they cook in 5 minutes.',
    ),
    PrepNote(
      category: 'OATS — LUNCH',
      body: 'Cook 60g dry oats as a savory base with sautéed onion and salt, '
          'or form into oats roti.',
    ),
    PrepNote(
      category: 'EGGS',
      body: 'Hard-boil in batches of 6 every 2 days. Store in fridge. Do not '
          'fry.',
    ),
    PrepNote(
      category: 'CHICKEN',
      body: 'Grill or steam. No oil. Marinate with ginger, garlic, and '
          'turmeric only.',
    ),
    PrepNote(
      category: 'FISH',
      body: 'Steam, grill, or pressure-cook with turmeric and ginger. Cook '
          'fresh.',
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
      category: 'CURD',
      body: 'Use homemade or low-fat curd. No sugar. Best at breakfast.',
    ),
    PrepNote(
      category: 'PEANUTS',
      body: 'Dry-roasted only. Measure 20g precisely — calorie-dense.',
    ),
  ],
);
