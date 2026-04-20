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

/// Phase 3 (Full Combat Program) meal plan. Targets: 212g protein, 344g carbs,
/// 73g fat, 2897 kcal. Weeks 16 and 20 are deloads — see
/// [MealPlan.deloadAdjustment].
const phase3MealPlan = MealPlan(
  phaseNumber: 3,
  totals: MacroTotals(proteinG: 212, carbsG: 344, fatG: 73, calories: 2897),
  deloadAdjustment:
      'Target ~2,400 kcal. Reduce oats at both meals by 30g each, drop '
      'chickpeas by 20g dry, skip peanuts. Keep all fish, chicken, eggs, '
      'soya, dal, and green gram unchanged.',
  meals: [
    Meal(
      name: 'Breakfast',
      timeLabel: '7:30 AM',
      items: [
        MealItem(
          name: 'Rolled Oats (cooked)',
          amount: '140g dry',
          proteinG: 18,
          carbsG: 93,
          fatG: 9,
          calories: 537,
        ),
        MealItem(
          name: 'Whole Eggs (hard-boiled)',
          amount: '4 eggs',
          proteinG: 28,
          carbsG: 2,
          fatG: 22,
          calories: 318,
        ),
        MealItem(
          name: 'Curd (low fat)',
          amount: '150g',
          proteinG: 6,
          carbsG: 4,
          fatG: 2,
          calories: 62,
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
          amount: '130g cooked',
          proteinG: 40,
          carbsG: 0,
          fatG: 5,
          calories: 205,
        ),
        MealItem(
          name: 'Oats (savory preparation)',
          amount: '80g dry',
          proteinG: 10,
          carbsG: 54,
          fatG: 6,
          calories: 306,
        ),
        MealItem(
          name: 'Chickpea Mix (boiled)',
          amount: '90g dry',
          proteinG: 18,
          carbsG: 55,
          fatG: 5,
          calories: 337,
        ),
        MealItem(
          name: 'Green Gram Whole (boiled)',
          amount: '70g dry',
          proteinG: 16,
          carbsG: 54,
          fatG: 0,
          calories: 280,
        ),
        MealItem(
          name: 'Cabbage + Carrot + Beans (sauté)',
          amount: '200g mix',
          proteinG: 3,
          carbsG: 14,
          fatG: 1,
          calories: 77,
        ),
        MealItem(
          name: 'Beetroot (boiled, pre-training boost)',
          amount: '100g',
          proteinG: 2,
          carbsG: 10,
          fatG: 0,
          calories: 48,
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
          amount: '160g',
          proteinG: 30,
          carbsG: 0,
          fatG: 9,
          calories: 201,
        ),
        MealItem(
          name: 'Soya Chunks (dry, rehydrated)',
          amount: '35g dry',
          proteinG: 18,
          carbsG: 10,
          fatG: 0,
          calories: 112,
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
          name: 'Spinach + Onion (sautéed)',
          amount: '120g mix',
          proteinG: 3,
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
      category: '4 EGGS AT BREAKFAST',
      body: 'The extra egg supports anabolic hormone levels during peak '
          'training. Pre-boil the night before.',
    ),
    PrepNote(
      category: 'BEETROOT AT LUNCH',
      body: 'On Monday (jump squats) and Wednesday (sprints), eat the full '
          '100g at lunch for nitrate-driven power gains within 2–3 hours. '
          'On Thursday and Friday, beetroot can be moved to dinner instead.',
    ),
    PrepNote(
      category: 'SPRINT WEDNESDAYS',
      body: 'Lunch must be eaten by 1:30 PM at the latest. No food between '
          'lunch and training. Add 20g dry oats to lunch on Monday and '
          'Wednesday.',
    ),
    PrepNote(
      category: 'FULL LUNCH',
      body: 'Lunch reaches ~1,200 kcal — this is intentional to fuel '
          'explosive training. Eat it completely. Do not under-eat out of '
          'prior habit.',
    ),
    PrepNote(
      category: 'SOYA CHUNKS FIRST',
      body: 'Increased to 35g dry. Eat it first at dinner — rapid protein '
          'absorption starts immediately post-session while fish and dal '
          'provide slower, sustained release.',
    ),
    PrepNote(
      category: 'DELOAD WEEKS 16 & 20',
      body: 'Target ~2,400 kcal. Reduce oats by 30g each meal, drop '
          'chickpeas by 20g dry, skip peanuts. Keep all proteins unchanged.',
    ),
    PrepNote(
      category: 'PROGRESS CHECK',
      body: 'At Week 16, estimate body fat visually or by waist tape. '
          'Target: 18–20% body fat.',
    ),
    PrepNote(
      category: 'WEEK 20 DELOAD',
      body: 'This deload transitions you into Phase 4. Keep it strict — the '
          'freshness you carry into Phase 4 determines how well your taper '
          'works.',
    ),
  ],
);
