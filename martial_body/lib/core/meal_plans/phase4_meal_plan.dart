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

/// Phase 4 (MMA Transition) meal plan. Targets: 195g protein, 325g carbs,
/// 65g fat, 2673 kcal. Near-maintenance fuelling during the taper — do not
/// under-eat.
const phase4MealPlan = MealPlan(
  phaseNumber: 4,
  totals: MacroTotals(proteinG: 195, carbsG: 325, fatG: 65, calories: 2673),
  deloadAdjustment:
      'Week 24: add 20g dry oats to breakfast on all training days. If you '
      'feel depleted at any point, eat the peanuts regardless of rest-day '
      'reductions.',
  meals: [
    Meal(
      name: 'Breakfast',
      timeLabel: '7:30 AM',
      items: [
        MealItem(
          name: 'Rolled Oats (cooked)',
          amount: '130g dry',
          proteinG: 17,
          carbsG: 87,
          fatG: 9,
          calories: 501,
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
          name: 'Spinach (wilted)',
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
          name: 'Oats (savory base)',
          amount: '75g dry',
          proteinG: 10,
          carbsG: 50,
          fatG: 5,
          calories: 293,
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
          amount: '65g dry',
          proteinG: 15,
          carbsG: 49,
          fatG: 0,
          calories: 256,
        ),
        MealItem(
          name: 'Cabbage + Carrot + Onion (sauté)',
          amount: '150g mix',
          proteinG: 2,
          carbsG: 11,
          fatG: 1,
          calories: 57,
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
          amount: '140g',
          proteinG: 27,
          carbsG: 0,
          fatG: 8,
          calories: 176,
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
          amount: '60g dry',
          proteinG: 14,
          carbsG: 36,
          fatG: 1,
          calories: 209,
        ),
        MealItem(
          name: 'Beetroot (boiled)',
          amount: '120g',
          proteinG: 2,
          carbsG: 11,
          fatG: 0,
          calories: 52,
        ),
        MealItem(
          name: 'Beans + Onion (sautéed)',
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
          name: 'Peanuts (roasted)',
          amount: '25g',
          proteinG: 7,
          carbsG: 4,
          fatG: 12,
          calories: 152,
        ),
      ],
    ),
  ],
  prepNotes: [
    PrepNote(
      category: 'DO NOT UNDER-EAT',
      body: 'The most common taper mistake. Eating less to look leaner will '
          'leave you slow and foggy on MMA Day 1. Eat every meal completely.',
    ),
    PrepNote(
      category: 'SHADOWBOXING (Wk 23–24, Tue & Fri)',
      body: 'Eat lunch at 1 PM as normal. No meal changes needed — '
          'shadowboxing is skill work, not a high-intensity caloric session.',
    ),
    PrepNote(
      category: 'CURD AT BREAKFAST',
      body: '150g curd provides slow-release casein protein and live '
          'probiotics. Important for gut health and digestion stability '
          'before the major environment change of an MMA gym.',
    ),
    PrepNote(
      category: 'WEEK 24 FINAL WEEK',
      body: 'Add 20g dry oats to breakfast on training days. You should '
          'feel energised and light. If you feel depleted, eat the peanuts '
          'regardless of rest-day reductions.',
    ),
    PrepNote(
      category: 'AVOID NEW FOODS',
      body: 'Do not introduce any new food, supplement, or cooking style in '
          'Phase 4. Gut stability before MMA Day 1 matters more than any '
          'marginal nutritional gain.',
    ),
    PrepNote(
      category: 'SLEEP',
      body: '8+ hours every night. Six months of structural adaptation '
          'consolidates during deep sleep. Without it, you carry fatigue '
          'into your first session.',
    ),
    PrepNote(
      category: 'EXPECTED END STATE',
      body: 'Starting at 83 kg, 26% body fat — expected finish: 78–80 kg, '
          '15–18% body fat. You will be leaner, stronger, more mobile, and '
          'more conditioned than you have ever been.',
    ),
  ],
);
