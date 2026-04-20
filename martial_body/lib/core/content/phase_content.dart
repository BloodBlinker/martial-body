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

import 'package:flutter/foundation.dart';

import '../program/phase_math.dart';

/// Per-phase content availability + marketing copy. The home screen renders
/// workouts and meal plans for every phase off this registry: flip a flag
/// when content lands and the existing UI picks it up — no layout changes.
///
/// Adding a new phase later requires only:
///   1. Add a `PhaseInfo` entry to [kPhases] in `phase_math.dart`.
///   2. Add a matching `PhaseContentSpec` here (start with both flags false).
///   3. When real content is ready, seed the DB for that phase and flip
///      the corresponding flag to true.
@immutable
class PhaseContentSpec {
  final int phaseNumber;

  /// True once the workout program for this phase is seeded and playable.
  final bool workoutAvailable;

  /// True once the meal plan for this phase is authored and wired up.
  final bool mealPlanAvailable;

  /// Short, one-sentence description shown on locked/coming-soon cards.
  final String workoutBlurb;
  final String mealPlanBlurb;

  const PhaseContentSpec({
    required this.phaseNumber,
    required this.workoutAvailable,
    required this.mealPlanAvailable,
    required this.workoutBlurb,
    required this.mealPlanBlurb,
  });
}

const kPhaseContent = <int, PhaseContentSpec>{
  1: PhaseContentSpec(
    phaseNumber: 1,
    workoutAvailable: true,
    mealPlanAvailable: true,
    workoutBlurb: 'Foundation strength, mobility, and aerobic base. '
        'Five sessions per week with a deload in week 4.',
    mealPlanBlurb: 'Nutrition guidance tuned to foundation-phase volume and '
        'recovery demands.',
  ),
  2: PhaseContentSpec(
    phaseNumber: 2,
    workoutAvailable: true,
    mealPlanAvailable: true,
    workoutBlurb: 'Heavier compound strength, tempo intervals, and engine '
        'building across six weeks.',
    mealPlanBlurb: 'Higher-carb fuelling around training with a steady daily '
        'protein target.',
  ),
  3: PhaseContentSpec(
    phaseNumber: 3,
    workoutAvailable: true,
    mealPlanAvailable: true,
    workoutBlurb: 'Combat-specific strength, power, sprints, and grip work '
        'across eight weeks.',
    mealPlanBlurb: 'Performance-optimized fuelling for high-intensity combat '
        'prep and recovery.',
  ),
  4: PhaseContentSpec(
    phaseNumber: 4,
    workoutAvailable: true,
    mealPlanAvailable: true,
    workoutBlurb: 'Four-day taper into MMA readiness: −30% lifting volume, '
        'conditioning maintained, shadowboxing added.',
    mealPlanBlurb: 'Fight-week nutrition strategy, hydration, and weight-'
        'management guidelines.',
  ),
};

/// Safe lookup — falls back to a placeholder spec rather than throwing so
/// the UI never crashes on data drift.
PhaseContentSpec phaseContentFor(int phaseNumber) {
  return kPhaseContent[phaseNumber] ??
      PhaseContentSpec(
        phaseNumber: phaseNumber,
        workoutAvailable: false,
        mealPlanAvailable: false,
        workoutBlurb: 'Content for phase $phaseNumber has not been added yet.',
        mealPlanBlurb: 'Content for phase $phaseNumber has not been added yet.',
      );
}

/// Convenience: every phase in the registry, in phase-number order, joined
/// with its `PhaseInfo` so callers get name / weekRange without a second
/// lookup.
List<({PhaseInfo info, PhaseContentSpec content})> allPhases() {
  return kPhases
      .map((info) => (info: info, content: phaseContentFor(info.number)))
      .toList();
}
