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

import '../models/block_model.dart';
import '../models/exercise_model.dart';
import '../models/phase_model.dart';
import '../models/session_model.dart';

// ---------------------------------------------------------------------------
// Phase 4 is a 4-day taper (Mon/Tue/Wed/Fri — no Thursday lifting). Volume
// drops ~30% vs Phase 3; intensity stays at 85%. Session length is 60–70 min.
// Exercise names match Phase 3 so the Drift upsert-by-name collapses them
// onto the same exercises table rows.
// ---------------------------------------------------------------------------

// -- Shared / warmup (reused from earlier phases)
const _shortFoot = ExerciseModel(name: 'Short Foot Exercise', category: 'mobility');
const _reverseHeelTap = ExerciseModel(name: 'Reverse Heel Tap', category: 'mobility');
const _tibialisRaise = ExerciseModel(name: 'Tibialis Anterior Raise', category: 'mobility');
const _pogoJumps = ExerciseModel(name: 'Pogo Jumps', category: 'mobility');
const _cossackSquatBW = ExerciseModel(name: 'Cossack Squats (BW)', category: 'mobility');
const _copenhagenPlank = ExerciseModel(name: 'Copenhagen Plank', category: 'core');
const _chinTucks = ExerciseModel(name: 'Chin Tucks + Head Lift', category: 'mobility');
const _jawOpener = ExerciseModel(name: 'Jaw Opener', category: 'mobility');
const _serratusWallSlides = ExerciseModel(name: 'Serratus Wall Slides', category: 'mobility');
const _cervicalHolds = ExerciseModel(name: 'Cervical Holds', category: 'neck');
const _bandPullAparts = ExerciseModel(name: 'Band Pull-Aparts', category: 'mobility');
const _plyoPushUps = ExerciseModel(name: 'Plyo Push-Ups', category: 'strength');
const _birdDog = ExerciseModel(name: 'Bird Dog', category: 'mobility');
const _pelvicFloorDrawIn = ExerciseModel(name: 'Pelvic Floor Draw-In', category: 'mobility');
const _jumpRopeEasy = ExerciseModel(name: 'Jump Rope — easy', category: 'cardio');
const _worldsGreatestStretch = ExerciseModel(name: "World's Greatest Stretch", category: 'mobility');
const _bandedClamshell = ExerciseModel(name: 'Banded Clamshell', category: 'mobility');
const _seatedHipIRER = ExerciseModel(name: 'Seated Hip IR/ER', category: 'mobility');
const _pubicCrunch = ExerciseModel(name: 'Pubic Crunch — Pyramidalis', category: 'core');
const _armCirclesShadow = ExerciseModel(name: 'Arm Circles + Shadowboxing', category: 'mobility');
const _bandDislocations = ExerciseModel(name: 'Band Dislocations', category: 'mobility');

// -- Monday main / tendon
const _dbJumpSquats = ExerciseModel(name: 'DB Jump Squats', category: 'strength');
const _dbBulgarianSplitSquat = ExerciseModel(name: 'DB Bulgarian Split Squat', category: 'strength');
const _heavyDBFarmersWalk = ExerciseModel(name: "Heavy DB Farmer's Walk", category: 'conditioning');
const _isoWallSitSingleLeg = ExerciseModel(name: 'Isometric Wall Sit — Single Leg', category: 'tendon');
const _standingCalfRaiseSlow = ExerciseModel(name: 'Standing Calf Raise — slow', category: 'tendon');

// -- Tuesday main / neck
const _inclineDBPress = ExerciseModel(name: 'Incline DB Press', category: 'strength');
const _dbFloorPress = ExerciseModel(name: 'DB Floor Press', category: 'strength');
const _cableWoodchoppers = ExerciseModel(name: 'Cable Woodchoppers', category: 'core');
const _heavyDBShrugs = ExerciseModel(name: 'Heavy DB Shrugs — 3s pause', category: 'neck');
const _neckExtension = ExerciseModel(name: 'Neck Extension — Plate/Towel', category: 'neck');
const _neckFlexion = ExerciseModel(name: 'Neck Flexion — Plate/Towel', category: 'neck');
const _cableLateralRaise = ExerciseModel(name: 'Cable Lateral Raise', category: 'strength');
const _shadowboxing = ExerciseModel(name: 'Shadowboxing — Footwork & Stance', category: 'conditioning');

// -- Wednesday conditioning / posterior
const _sprintIntervals = ExerciseModel(name: 'Sprint Intervals — Jump Rope / Run', category: 'cardio');
const _heavyLoadedCarry = ExerciseModel(name: 'Heavy Loaded Carry — DB or Barbell', category: 'conditioning');
const _rdl = ExerciseModel(name: 'RDL — DB or Barbell', category: 'strength');
const _nordicCurl = ExerciseModel(name: 'Nordic Curl', category: 'strength');
const _pallofPress = ExerciseModel(name: 'Pallof Press', category: 'core');

// -- Friday main / core / finishing
const _cossackSquatLoaded =
    ExerciseModel(name: 'Cossack Squat — Loaded', category: 'strength');
const _seatedDBOHP = ExerciseModel(name: 'Seated DB OHP', category: 'strength');
const _unilateralFarmersWalk = ExerciseModel(name: "Unilateral Farmer's Walk", category: 'core');
const _abWheel = ExerciseModel(name: 'Ab Wheel Rollout', category: 'core');
const _hangingKneeRaise = ExerciseModel(name: 'Hanging Knee Raise', category: 'core');
const _rearDeltCableFly = ExerciseModel(name: 'Rear Delt Cable Fly', category: 'strength');
const _cableCrunch = ExerciseModel(name: 'Cable Crunch', category: 'core');
const _mobilitySession =
    ExerciseModel(name: 'Full Mobility Session', category: 'mobility');

// ---------------------------------------------------------------------------
// Cooldown helper (static stretches — no sets/reps, self-paced)
// ---------------------------------------------------------------------------

BlockExerciseModel _cooldown(String name, String duration, int order) =>
    BlockExerciseModel(
      exercise: ExerciseModel(name: name, category: 'mobility'),
      exerciseOrder: order,
      reps: duration,
      tempo: 'Static',
    );

// ---------------------------------------------------------------------------
// Monday — Lower Body — Reduced Volume
// ---------------------------------------------------------------------------

const _monWarmupExercises = [
  BlockExerciseModel(
    exercise: _shortFoot,
    exerciseOrder: 0,
    sets: 3,
    reps: '20s/foot',
    tempo: 'Static',
  ),
  BlockExerciseModel(
    exercise: _reverseHeelTap,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
  ),
  BlockExerciseModel(
    exercise: _tibialisRaise,
    exerciseOrder: 2,
    sets: 2,
    reps: '25',
    tempo: '2-1-2-0',
  ),
  BlockExerciseModel(
    exercise: _pogoJumps,
    exerciseOrder: 3,
    sets: 3,
    reps: '20s',
    tempo: 'Rapid',
  ),
  BlockExerciseModel(
    exercise: _cossackSquatBW,
    exerciseOrder: 4,
    sets: 2,
    reps: '8/side',
    tempo: '2-1-1-0',
  ),
  BlockExerciseModel(
    exercise: _copenhagenPlank,
    exerciseOrder: 5,
    sets: 2,
    reps: '20s/side',
    tempo: 'Static',
  ),
];

const _monMainExercises = [
  BlockExerciseModel(
    exercise: _dbJumpSquats,
    exerciseOrder: 0,
    sets: 3,
    reps: '5',
    tempo: '1-0-X-0',
    restSeconds: 90,
    notes: '−1 set vs Phase 3. Land soft.',
  ),
  BlockExerciseModel(
    exercise: _dbBulgarianSplitSquat,
    exerciseOrder: 1,
    sets: 2,
    reps: '8/leg',
    tempo: '2-1-X-0',
    restSeconds: 90,
    notes: '−1 set. Weak leg first.',
  ),
  BlockExerciseModel(
    exercise: _heavyDBFarmersWalk,
    exerciseOrder: 2,
    sets: 3,
    reps: '40m',
    tempo: 'Continuous',
    restSeconds: 60,
    notes: '−1 set.',
  ),
];

const _monTendonExercises = [
  BlockExerciseModel(
    exercise: _isoWallSitSingleLeg,
    exerciseOrder: 0,
    sets: 2,
    reps: 'Failure',
    tempo: 'Static',
    restSeconds: 60,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _standingCalfRaiseSlow,
    exerciseOrder: 1,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-2',
    restSeconds: 60,
    notes: 'Maintain.',
  ),
];

final _monCooldownExercises = [
  _cooldown('90-90 Hip Stretch', '2 min/side', 0),
  _cooldown('Couch Stretch', '90s/side', 1),
];

final phase4Monday = SessionModel(
  phaseNumber: 4,
  weekDay: 1,
  name: 'Lower Body — Reduced Volume',
  focus:
      'Main compound movements only · Drop isolation work · Keep armor block',
  estimatedMinutes: 65,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 12 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 12,
      exercises: _monWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN BLOCK',
      blockOrder: 1,
      blockType: BlockType.main,
      exercises: _monMainExercises,
    ),
    const BlockModel(
      name: 'ARMOR BLOCK',
      blockOrder: 2,
      blockType: BlockType.tendon,
      exercises: _monTendonExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 3,
      blockType: BlockType.cooldown,
      exercises: _monCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Tuesday — Upper Body — Reduced Volume + Shadowboxing (Wk 23–24)
// ---------------------------------------------------------------------------

const _tueWarmupExercises = [
  BlockExerciseModel(
    exercise: _chinTucks,
    exerciseOrder: 0,
    sets: 3,
    reps: '10 (5s hold)',
    tempo: 'Controlled',
  ),
  BlockExerciseModel(
    exercise: _jawOpener,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Slow',
  ),
  BlockExerciseModel(
    exercise: _serratusWallSlides,
    exerciseOrder: 2,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-0',
  ),
  BlockExerciseModel(
    exercise: _cervicalHolds,
    exerciseOrder: 3,
    sets: 1,
    reps: '10s × 4 directions',
    tempo: 'Static',
  ),
  BlockExerciseModel(
    exercise: _bandPullAparts,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-0',
  ),
  BlockExerciseModel(
    exercise: _plyoPushUps,
    exerciseOrder: 5,
    sets: 3,
    reps: '5',
    tempo: 'X',
  ),
];

const _tueMainExercises = [
  BlockExerciseModel(
    exercise: _inclineDBPress,
    exerciseOrder: 0,
    sets: 3,
    reps: '8',
    tempo: '2-1-X-0',
    restSeconds: 120,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _dbFloorPress,
    exerciseOrder: 1,
    sets: 2,
    reps: '10',
    tempo: '2-1-X-0',
    restSeconds: 90,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _cableWoodchoppers,
    exerciseOrder: 2,
    sets: 2,
    reps: '8/side',
    tempo: '1-0-X-0',
    restSeconds: 60,
    notes: '−1 set.',
  ),
];

const _tueNeckExercises = [
  BlockExerciseModel(
    exercise: _heavyDBShrugs,
    exerciseOrder: 0,
    sets: 3,
    reps: '12',
    tempo: '2-0-X-3',
    restSeconds: 60,
    notes: 'Maintain — chin protection critical.',
  ),
  BlockExerciseModel(
    exercise: _neckExtension,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    restSeconds: 60,
    notes: 'Maintain.',
  ),
  BlockExerciseModel(
    exercise: _neckFlexion,
    exerciseOrder: 2,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    restSeconds: 60,
    notes: 'Maintain.',
  ),
  BlockExerciseModel(
    exercise: _cableLateralRaise,
    exerciseOrder: 3,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
    restSeconds: 60,
    notes: '−1 set.',
  ),
];

const _tueShadowboxingExercises = [
  BlockExerciseModel(
    exercise: _shadowboxing,
    exerciseOrder: 0,
    sets: 1,
    reps: '15 min',
    tempo: 'Fluid',
    notes: 'Basic stance, jab-cross, footwork only.',
  ),
];

final _tueCooldownExercises = [
  _cooldown('Crucifixion Stretch', '2×60s', 0),
  _cooldown("Child's Pose", '90s', 1),
];

final phase4Tuesday = SessionModel(
  phaseNumber: 4,
  weekDay: 2,
  name: 'Upper Body — Reduced Volume + Shadowboxing',
  focus:
      'Keep pressing and neck work · Drop isolation volume · Add shadowboxing',
  estimatedMinutes: 70,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 12 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 12,
      exercises: _tueWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN BLOCK',
      blockOrder: 1,
      blockType: BlockType.main,
      exercises: _tueMainExercises,
    ),
    const BlockModel(
      name: 'NECK & SHOULDER BLOCK',
      blockOrder: 2,
      blockType: BlockType.tendon,
      exercises: _tueNeckExercises,
    ),
    const BlockModel(
      name: 'SHADOWBOXING — WEEKS 23–24 ONLY',
      blockOrder: 3,
      blockType: BlockType.finishing,
      instructions:
          'Add from Week 23 onward. Self-led: basic stance, jab-cross, lateral footwork. Stay relaxed — this is skill grease, not conditioning.',
      exercises: _tueShadowboxingExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 4,
      blockType: BlockType.cooldown,
      exercises: _tueCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Wednesday — The Engine — Conditioning Maintained in Full
// ---------------------------------------------------------------------------

const _wedWarmupExercises = [
  BlockExerciseModel(
    exercise: _birdDog,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side (5s hold)',
    tempo: 'Controlled',
  ),
  BlockExerciseModel(
    exercise: _pelvicFloorDrawIn,
    exerciseOrder: 1,
    sets: 4,
    reps: '10 (5s hold)',
    tempo: 'Static',
  ),
  BlockExerciseModel(
    exercise: _jumpRopeEasy,
    exerciseOrder: 2,
    sets: 1,
    reps: '3 min',
    tempo: 'Moderate',
  ),
  BlockExerciseModel(
    exercise: _worldsGreatestStretch,
    exerciseOrder: 3,
    sets: 2,
    reps: '5/side',
    tempo: 'Slow',
  ),
];

const _wedConditioningExercises = [
  BlockExerciseModel(
    exercise: _sprintIntervals,
    exerciseOrder: 0,
    sets: 8,
    reps: '15s',
    tempo: 'ALL OUT',
    notes: '45s recovery. DO NOT reduce this.',
  ),
  BlockExerciseModel(
    exercise: _heavyLoadedCarry,
    exerciseOrder: 1,
    sets: 3,
    reps: '40m',
    tempo: 'Continuous',
    restSeconds: 60,
    notes: '−1 set only.',
  ),
];

const _wedPosteriorExercises = [
  BlockExerciseModel(
    exercise: _rdl,
    exerciseOrder: 0,
    sets: 3,
    reps: '8–10',
    tempo: '3-1-1-1',
    restSeconds: 120,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 1,
    sets: 2,
    reps: '5–8',
    tempo: '4-0-1-0',
    restSeconds: 90,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 2,
    sets: 2,
    reps: '10/side',
    tempo: '1-5-1-0',
    restSeconds: 45,
    notes: '−1 set.',
  ),
];

final _wedCooldownExercises = [
  _cooldown('Cat-Cow', '2×15', 0),
  _cooldown('Deep Squat Hold', '2 min', 1),
];

final phase4Wednesday = SessionModel(
  phaseNumber: 4,
  weekDay: 3,
  name: 'The Engine — Conditioning Maintained',
  focus:
      'Sprint intervals do NOT reduce · Posterior chain maintained · Carry drops by one set',
  estimatedMinutes: 70,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 10 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 10,
      exercises: _wedWarmupExercises,
    ),
    const BlockModel(
      name: 'CONDITIONING BLOCK — FULL PROTOCOL',
      blockOrder: 1,
      blockType: BlockType.conditioning,
      instructions:
          'Sprint intervals stay at full volume — 8 × 15s ALL OUT / 45s recovery. The taper drops lifting volume, not conditioning.\n'
          'After ≈5 min rest, continue to the loaded carry.',
      exercises: _wedConditioningExercises,
    ),
    const BlockModel(
      name: 'POSTERIOR CHAIN BLOCK',
      blockOrder: 2,
      blockType: BlockType.posterior,
      exercises: _wedPosteriorExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 3,
      blockType: BlockType.cooldown,
      exercises: _wedCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Friday — Core + Full Mobility + Final Finishing
// ---------------------------------------------------------------------------

const _friWarmupExercises = [
  BlockExerciseModel(
    exercise: _bandedClamshell,
    exerciseOrder: 0,
    sets: 3,
    reps: '15/side',
    tempo: '2-1-1-0',
  ),
  BlockExerciseModel(
    exercise: _seatedHipIRER,
    exerciseOrder: 1,
    sets: 2,
    reps: '15 each',
    tempo: 'Slow',
  ),
  BlockExerciseModel(
    exercise: _pubicCrunch,
    exerciseOrder: 2,
    sets: 3,
    reps: '10',
    tempo: '2-1-2-1',
  ),
  BlockExerciseModel(
    exercise: _armCirclesShadow,
    exerciseOrder: 3,
    sets: 1,
    reps: '3 min',
    tempo: 'Fluid',
  ),
  BlockExerciseModel(
    exercise: _bandDislocations,
    exerciseOrder: 4,
    sets: 2,
    reps: '15',
    tempo: 'Slow',
  ),
];

const _friMainExercises = [
  BlockExerciseModel(
    exercise: _cossackSquatLoaded,
    exerciseOrder: 0,
    sets: 2,
    reps: '8/side',
    tempo: '2-1-1-1',
    restSeconds: 90,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _seatedDBOHP,
    exerciseOrder: 1,
    sets: 2,
    reps: '10',
    tempo: '2-1-1-1',
    restSeconds: 90,
    notes: '−1 set.',
  ),
];

const _friCoreExercises = [
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 0,
    sets: 3,
    reps: '10/side',
    tempo: '1-5-1-0',
    restSeconds: 60,
    notes: 'Maintain.',
  ),
  BlockExerciseModel(
    exercise: _unilateralFarmersWalk,
    exerciseOrder: 1,
    sets: 2,
    reps: '40m/side',
    tempo: 'Continuous',
    restSeconds: 60,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _abWheel,
    exerciseOrder: 2,
    sets: 2,
    reps: '10–12',
    tempo: '3-1-X-0',
    restSeconds: 60,
    notes: '−1 set.',
  ),
  BlockExerciseModel(
    exercise: _hangingKneeRaise,
    exerciseOrder: 3,
    sets: 2,
    reps: '10–12',
    tempo: '2-1-1-0',
    restSeconds: 60,
    notes: '−1 set.',
  ),
];

const _friFinishingExercises = [
  BlockExerciseModel(
    exercise: _cableLateralRaise,
    exerciseOrder: 0,
    sets: 2,
    reps: '15',
    tempo: '2-1-2-1',
  ),
  BlockExerciseModel(
    exercise: _rearDeltCableFly,
    exerciseOrder: 1,
    sets: 2,
    reps: '15',
    tempo: '2-1-2-1',
  ),
  BlockExerciseModel(
    exercise: _cableCrunch,
    exerciseOrder: 2,
    sets: 2,
    reps: '15',
    tempo: '2-1-2-1',
  ),
];

const _friMobilityExercises = [
  BlockExerciseModel(
    exercise: _mobilitySession,
    exerciseOrder: 0,
    sets: 1,
    reps: '20 min',
    tempo: 'Slow',
    notes: 'Pigeon · 90-90 · foam roll · thoracic rotations.',
  ),
];

const _friShadowboxingExercises = [
  BlockExerciseModel(
    exercise: _shadowboxing,
    exerciseOrder: 0,
    sets: 1,
    reps: '15 min',
    tempo: 'Fluid',
    notes: 'Footwork · basic combos · stance work.',
  ),
];

final _friCooldownExercises = [
  _cooldown('Foam Roll — quads, lats, upper back', '5 min', 0),
  _cooldown('Static neck stretch', '30s/side', 1),
];

final phase4Friday = SessionModel(
  phaseNumber: 4,
  weekDay: 5,
  name: 'Core + Full Mobility + Final Finishing',
  focus:
      'Full mobility session · Core maintained · Shadowboxing added Wk 23–24',
  estimatedMinutes: 70,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 12 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 12,
      exercises: _friWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN BLOCK',
      blockOrder: 1,
      blockType: BlockType.main,
      exercises: _friMainExercises,
    ),
    const BlockModel(
      name: 'CORE BLOCK',
      blockOrder: 2,
      blockType: BlockType.core,
      exercises: _friCoreExercises,
    ),
    const BlockModel(
      name: 'FINISHING CIRCUIT — 2 ROUNDS',
      blockOrder: 3,
      blockType: BlockType.finishing,
      instructions:
          '2 rounds (dropped from 3 in Phase 3). No rest within a round. 90s rest between rounds.',
      exercises: _friFinishingExercises,
    ),
    const BlockModel(
      name: 'FULL MOBILITY SESSION — 20 MIN',
      blockOrder: 4,
      blockType: BlockType.cooldown,
      instructions:
          'Self-guided 20-minute mobility flow. Rotate through pigeon, 90-90, couch stretch, foam roll (quads/lats/upper back), and thoracic openers. This is recovery, not a workout.',
      exercises: _friMobilityExercises,
    ),
    const BlockModel(
      name: 'SHADOWBOXING — WEEKS 23–24 ONLY',
      blockOrder: 5,
      blockType: BlockType.finishing,
      instructions:
          'Add from Week 23 onward. Footwork, basic combos, stance work. Stay loose.',
      exercises: _friShadowboxingExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 6,
      blockType: BlockType.cooldown,
      exercises: _friCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Phase 4 — top-level definition
// ---------------------------------------------------------------------------

const phase4 = PhaseModel(
  number: 4,
  name: 'MMA Transition',
  subtitle: 'Peak Conditioning, Reduce Fatigue',
  weeksStart: 21,
  weeksEnd: 24,
  intensityMin: 0.85,
  intensityMax: 0.85,
  deloadWeeks: [],
  overviewText:
      'Four weeks before entering your MMA gym, training shifts into a taper. Volume drops by '
      'approximately 30% but intensity is maintained — you do not train easier, you train less. '
      'Sessions shorten to 60–70 minutes. Thursday lifting is dropped (4-day split); conditioning '
      'stays at full volume. The goal: arrive on day one feeling athletic, mobile, conditioned, '
      'and fresh. Weeks 21–22: −30% volume. Week 23: −40% volume + shadowboxing on Tue/Fri. '
      'Week 24: −50% volume with daily shadowboxing.',
);

/// Phase 4 runs Mon/Tue/Wed/Fri — Thursday lifting is dropped for the taper.
final phase4Sessions = [
  phase4Monday,
  phase4Tuesday,
  phase4Wednesday,
  phase4Friday,
];
