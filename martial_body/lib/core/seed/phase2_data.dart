import '../models/block_model.dart';
import '../models/exercise_model.dart';
import '../models/phase_model.dart';
import '../models/session_model.dart';

// ---------------------------------------------------------------------------
// Exercise definitions — reused across blocks. Names must match Phase 1 where
// an exercise recurs so the Drift upsert-by-name collapses them to a single
// row in the exercises table.
// ---------------------------------------------------------------------------

// -- Shared / warmup (reused from Phase 1)
const _shortFoot = ExerciseModel(name: 'Short Foot Exercise', category: 'mobility');
const _reverseHeelTap = ExerciseModel(name: 'Reverse Heel Tap', category: 'mobility');
const _tibialisRaise = ExerciseModel(name: 'Tibialis Anterior Raise', category: 'mobility');
const _cossackSquatBW = ExerciseModel(name: 'Cossack Squats (BW)', category: 'mobility');
const _chinTucks = ExerciseModel(name: 'Chin Tucks + Head Lift', category: 'mobility');
const _jawOpener = ExerciseModel(name: 'Jaw Opener', category: 'mobility');
const _serratusWallSlides = ExerciseModel(name: 'Serratus Wall Slides', category: 'mobility');
const _bandPullAparts = ExerciseModel(name: 'Band Pull-Aparts', category: 'mobility');
const _birdDog = ExerciseModel(name: 'Bird Dog', category: 'mobility');
const _pelvicFloorDrawIn = ExerciseModel(name: 'Pelvic Floor Draw-In', category: 'mobility');
const _worldsGreatestStretch = ExerciseModel(name: "World's Greatest Stretch", category: 'mobility');
const _tendonGlides = ExerciseModel(name: 'Tendon Glides', category: 'mobility');
const _bandFingerExtensions = ExerciseModel(name: 'Band Finger Extensions', category: 'mobility');
const _bandedClamshell = ExerciseModel(name: 'Banded Clamshell', category: 'mobility');
const _seatedHipIRER = ExerciseModel(name: 'Seated Hip IR/ER', category: 'mobility');
const _pubicCrunch = ExerciseModel(name: 'Pubic Crunch — Pyramidalis', category: 'core');
const _armCirclesShadow = ExerciseModel(name: 'Arm Circles + Shadowboxing', category: 'mobility');
const _bandDislocations = ExerciseModel(name: 'Band Dislocations', category: 'mobility');

// -- New / progressions introduced in Phase 2
const _pogoJumps = ExerciseModel(name: 'Pogo Jumps', category: 'mobility');
const _copenhagenPlank = ExerciseModel(name: 'Copenhagen Plank', category: 'core');
const _plyoPushUps = ExerciseModel(name: 'Plyo Push-Ups', category: 'strength');
const _jumpRopeEasy = ExerciseModel(name: 'Jump Rope — easy', category: 'cardio');
const _broadJumps = ExerciseModel(name: 'Broad Jumps', category: 'strength');
const _cervicalHolds = ExerciseModel(name: 'Cervical Holds', category: 'neck');

// -- Monday main / tendon
const _highBarBackSquat = ExerciseModel(name: 'High Bar Back Squat', category: 'strength');
const _dbBulgarianSplitSquat = ExerciseModel(name: 'DB Bulgarian Split Squat', category: 'strength');
const _legExtensionVMO = ExerciseModel(name: 'Leg Extension (VMO bias)', category: 'strength');
const _seatedAdductor = ExerciseModel(name: 'Seated Adductor Machine', category: 'strength');
const _heavyDBFarmersWalk = ExerciseModel(name: "Heavy DB Farmer's Walk", category: 'conditioning');
const _isoWallSitSingleLeg = ExerciseModel(name: 'Isometric Wall Sit — Single Leg', category: 'tendon');
const _standingCalfRaiseSlow = ExerciseModel(name: 'Standing Calf Raise — slow', category: 'tendon');
const _footDoming = ExerciseModel(name: 'Foot Doming Exercise', category: 'tendon');
const _nordicCurl = ExerciseModel(name: 'Nordic Curl', category: 'strength');

// -- Tuesday main / neck
const _inclineDBPress = ExerciseModel(name: 'Incline DB Press', category: 'strength');
const _dbFloorPress = ExerciseModel(name: 'DB Floor Press', category: 'strength');
const _isoPushUpHold = ExerciseModel(name: 'Isometric Push-Up Hold', category: 'tendon');
const _cableWoodchoppers = ExerciseModel(name: 'Cable Woodchoppers', category: 'core');
const _lowToHighCableFly = ExerciseModel(name: 'Low-to-High Cable Fly', category: 'strength');
const _heavyDBShrugs = ExerciseModel(name: 'Heavy DB Shrugs — 3s pause', category: 'neck');
const _neckExtension = ExerciseModel(name: 'Neck Extension — Plate/Towel', category: 'neck');
const _neckFlexion = ExerciseModel(name: 'Neck Flexion — Plate/Towel', category: 'neck');
const _cableLateralRaise = ExerciseModel(name: 'Cable Lateral Raise', category: 'strength');

// -- Wednesday conditioning / posterior
const _sprintIntervals = ExerciseModel(name: 'Sprint Intervals — Jump Rope / Run', category: 'cardio');
const _heavyLoadedCarry = ExerciseModel(name: 'Heavy Loaded Carry — DB or Barbell', category: 'conditioning');
const _rdl = ExerciseModel(name: 'RDL — DB or Barbell', category: 'strength');
const _isoGluteBridge = ExerciseModel(name: 'Isometric Glute Bridge', category: 'tendon');
const _pallofPress = ExerciseModel(name: 'Pallof Press', category: 'core');

// -- Thursday main / grip
const _weightedPullUps = ExerciseModel(name: 'Weighted Pull-Ups', category: 'strength');
const _isoDeadHang = ExerciseModel(name: 'Isometric Dead Hang', category: 'grip');
const _dbRDL = ExerciseModel(name: 'DB RDL', category: 'strength');
const _chestSupportedRow = ExerciseModel(name: 'Chest-Supported DB Row', category: 'strength');
const _overheadDBShrugs = ExerciseModel(name: 'Overhead DB Shrugs', category: 'strength');
const _towelWringing = ExerciseModel(name: 'Towel Wringing / Rice Bucket', category: 'grip');
const _palmarisBrevisSqueeze = ExerciseModel(name: 'Palmaris Brevis Squeeze', category: 'grip');
const _dbPronation = ExerciseModel(name: 'Dumbbell Pronation', category: 'grip');
const _dbSupination = ExerciseModel(name: 'Dumbbell Supination', category: 'grip');
const _fatGripzHolds = ExerciseModel(name: 'Fat Gripz Holds / Towel Hang', category: 'grip');

// -- Friday main / core / finishing
const _cossackSquatLoaded = ExerciseModel(name: 'Cossack Squat — Light Load', category: 'strength');
const _seatedDBOHP = ExerciseModel(name: 'Seated DB OHP', category: 'strength');
const _dbHammerCurls = ExerciseModel(name: 'DB Hammer Curls', category: 'strength');
const _overheadCableTriceps = ExerciseModel(name: 'Overhead Cable Triceps Ext', category: 'strength');
const _unilateralFarmersWalk = ExerciseModel(name: "Unilateral Farmer's Walk", category: 'core');
const _pufferFish = ExerciseModel(name: 'Puffer Fish — 360° brace', category: 'core');
const _abWheel = ExerciseModel(name: 'Ab Wheel Rollout', category: 'core');
const _rearDeltCableFly = ExerciseModel(name: 'Rear Delt Cable Fly', category: 'strength');
const _cableCrunch = ExerciseModel(name: 'Cable Crunch', category: 'core');
const _hangingKneeRaise = ExerciseModel(name: 'Hanging Knee Raise', category: 'core');

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
// Monday — Lower Body Power + Full Knee & Foot Armor
// ---------------------------------------------------------------------------

const _monWarmupExercises = [
  BlockExerciseModel(
    exercise: _shortFoot,
    exerciseOrder: 0,
    sets: 3,
    reps: '20s/foot',
    tempo: 'Static',
    notes: 'Non-negotiable arch prep',
  ),
  BlockExerciseModel(
    exercise: _reverseHeelTap,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    notes: 'Tib anterior + ankle stability',
  ),
  BlockExerciseModel(
    exercise: _tibialisRaise,
    exerciseOrder: 2,
    sets: 2,
    reps: '25',
    tempo: '2-1-2-0',
    notes: 'Against wall — shin armor',
  ),
  BlockExerciseModel(
    exercise: _pogoJumps,
    exerciseOrder: 3,
    sets: 3,
    reps: '20s',
    tempo: 'Rapid',
    notes: 'CNS potentiation — elastic ankle stiffness',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _cossackSquatBW,
    exerciseOrder: 4,
    sets: 2,
    reps: '8/side',
    tempo: '2-1-1-0',
    notes: 'Hip mobility',
  ),
  BlockExerciseModel(
    exercise: _copenhagenPlank,
    exerciseOrder: 5,
    sets: 2,
    reps: '20s/side',
    tempo: 'Static',
    notes: 'Adductor / groin activation',
    isNew: true,
  ),
];

const _monMainExercises = [
  BlockExerciseModel(
    exercise: _highBarBackSquat,
    exerciseOrder: 0,
    sets: 4,
    reps: '6–8',
    tempo: '3-1-X-1',
    notes: 'Working weight. 3-rep technique sets first.',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _dbBulgarianSplitSquat,
    exerciseOrder: 1,
    sets: 3,
    reps: '8/leg',
    tempo: '3-2-X-0',
    notes: 'Load increases from Phase 1. Weak leg first.',
  ),
  BlockExerciseModel(
    exercise: _legExtensionVMO,
    exerciseOrder: 2,
    sets: 3,
    reps: '12–15',
    tempo: '2-1-2-1',
    notes: 'Terminal extension. Mid load now.',
  ),
  BlockExerciseModel(
    exercise: _seatedAdductor,
    exerciseOrder: 3,
    sets: 3,
    reps: '15',
    tempo: '2-1-1-0',
    notes: 'Groin integrity',
  ),
  BlockExerciseModel(
    exercise: _heavyDBFarmersWalk,
    exerciseOrder: 4,
    sets: 4,
    reps: '40m',
    tempo: 'Continuous',
    notes: 'Loaded carry — trunk + foot stability',
    isNew: true,
  ),
];

const _monTendonExercises = [
  BlockExerciseModel(
    exercise: _isoWallSitSingleLeg,
    exerciseOrder: 0,
    sets: 3,
    reps: '45–60s',
    tempo: 'Static',
    notes: 'Progress to weighted vest if easy',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _standingCalfRaiseSlow,
    exerciseOrder: 1,
    sets: 4,
    reps: '12–15',
    tempo: '2-1-2-2',
    notes: 'Achilles tendon — slow eccentric key',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _footDoming,
    exerciseOrder: 2,
    sets: 2,
    reps: '15',
    tempo: '1-1-1-1',
    notes: 'Maintain from Phase 1',
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 3,
    sets: 3,
    reps: '5–8',
    tempo: '4-0-1-0',
    notes: 'Hamstring — key injury prevention',
  ),
];

final _monCooldownExercises = [
  _cooldown('90-90 Hip Stretch', '2 min/side', 0),
  _cooldown('Couch Stretch', '90s/side', 1),
  _cooldown('Pigeon Pose', '90s/side', 2),
];

final phase2Monday = SessionModel(
  phaseNumber: 2,
  weekDay: 1,
  name: 'Lower Body Power + Full Knee & Foot Armor',
  focus: 'Strength loading increases · Explosive intro · Full foot/arch protocol · VMO bias',
  estimatedMinutes: 85,
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
      name: 'TENDON & ARMOR BLOCK',
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
// Tuesday — Upper Body Power + Iron Chin Protocol
// ---------------------------------------------------------------------------

const _tueWarmupExercises = [
  BlockExerciseModel(
    exercise: _chinTucks,
    exerciseOrder: 0,
    sets: 3,
    reps: '10 (5s hold)',
    tempo: 'Controlled',
    notes: 'Cervical deep flexors',
  ),
  BlockExerciseModel(
    exercise: _jawOpener,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Slow',
    notes: 'TMJ prep',
  ),
  BlockExerciseModel(
    exercise: _serratusWallSlides,
    exerciseOrder: 2,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-0',
    notes: 'Scapular control',
  ),
  BlockExerciseModel(
    exercise: _cervicalHolds,
    exerciseOrder: 3,
    sets: 1,
    reps: '10s x 4 directions',
    tempo: 'Static',
    notes: 'Front / back / left / right',
  ),
  BlockExerciseModel(
    exercise: _bandPullAparts,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-0',
    notes: 'Rotator cuff activation',
  ),
  BlockExerciseModel(
    exercise: _plyoPushUps,
    exerciseOrder: 5,
    sets: 3,
    reps: '5',
    tempo: 'X',
    notes: 'CNS upper body potentiation',
    isNew: true,
  ),
];

const _tueMainExercises = [
  BlockExerciseModel(
    exercise: _inclineDBPress,
    exerciseOrder: 0,
    sets: 4,
    reps: '8',
    tempo: '2-1-X-0',
    notes: 'Bilateral reintroduced. Stop if shoulder reacts.',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _dbFloorPress,
    exerciseOrder: 1,
    sets: 3,
    reps: '10',
    tempo: '2-1-X-0',
    notes: 'Shoulder-safe ROM. Load increases from Phase 1.',
  ),
  BlockExerciseModel(
    exercise: _isoPushUpHold,
    exerciseOrder: 2,
    sets: 3,
    reps: '30–45s',
    tempo: 'Static',
    notes: 'Longer holds than Phase 1',
  ),
  BlockExerciseModel(
    exercise: _cableWoodchoppers,
    exerciseOrder: 3,
    sets: 3,
    reps: '8/side',
    tempo: '1-0-X-0',
    notes: 'Begin adding explosive intent',
  ),
  BlockExerciseModel(
    exercise: _lowToHighCableFly,
    exerciseOrder: 4,
    sets: 3,
    reps: '12–15',
    tempo: '2-1-2-1',
    notes: 'Lower pec + anterior delt',
    isNew: true,
  ),
];

const _tueTendonNeckExercises = [
  BlockExerciseModel(
    exercise: _heavyDBShrugs,
    exerciseOrder: 0,
    sets: 4,
    reps: '12',
    tempo: '2-0-X-3',
    notes: 'Trap thickness. Now goes heavier.',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _neckExtension,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    notes: 'Plate or harness — controlled full ROM',
  ),
  BlockExerciseModel(
    exercise: _neckFlexion,
    exerciseOrder: 2,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    notes: 'Front of neck — load progresses',
  ),
  BlockExerciseModel(
    exercise: _cableLateralRaise,
    exerciseOrder: 3,
    sets: 4,
    reps: '15–20',
    tempo: '2-1-2-1',
    notes: 'Shoulder width + rotator cuff longevity',
    isNew: true,
  ),
];

final _tueCooldownExercises = [
  _cooldown('Crucifixion Stretch', '2×60s', 0),
  _cooldown("Child's Pose", '90s', 1),
  _cooldown('Doorway Chest Stretch', '60s/side', 2),
];

final phase2Tuesday = SessionModel(
  phaseNumber: 2,
  weekDay: 2,
  name: 'Upper Body Power + Iron Chin Protocol',
  focus: 'Bilateral pressing returns cautiously · Full neck protocol · Shoulder durability',
  estimatedMinutes: 85,
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
      instructions:
          'LEFT SHOULDER — RE-ASSESS: bilateral pressing is reintroduced at sub-maximal loads. Stop immediately on any discomfort and regress to single-arm DB press.',
      exercises: _tueMainExercises,
    ),
    const BlockModel(
      name: 'TENDON & NECK BLOCK',
      blockOrder: 2,
      blockType: BlockType.tendon,
      exercises: _tueTendonNeckExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 3,
      blockType: BlockType.cooldown,
      exercises: _tueCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Wednesday — The Engine — Intervals Begin + Posterior Chain
// ---------------------------------------------------------------------------

const _wedWarmupExercises = [
  BlockExerciseModel(
    exercise: _birdDog,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side (5s hold)',
    tempo: 'Controlled',
    notes: 'Lumbar prep before interval work',
  ),
  BlockExerciseModel(
    exercise: _pelvicFloorDrawIn,
    exerciseOrder: 1,
    sets: 3,
    reps: '10 (5s hold)',
    tempo: 'Static',
    notes: 'IAP prep',
  ),
  BlockExerciseModel(
    exercise: _jumpRopeEasy,
    exerciseOrder: 2,
    sets: 1,
    reps: '3 min',
    tempo: 'Moderate',
    notes: 'Progressive HR ramp',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _worldsGreatestStretch,
    exerciseOrder: 3,
    sets: 2,
    reps: '5/side',
    tempo: 'Slow',
    notes: 'Full chain',
  ),
];

const _wedConditioningExercises = [
  BlockExerciseModel(
    exercise: _sprintIntervals,
    exerciseOrder: 0,
    reps: 'Per week protocol',
    tempo: 'ALL OUT',
    notes: 'Rest fully between rounds. This must be maximal.',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _heavyLoadedCarry,
    exerciseOrder: 1,
    sets: 4,
    reps: '40m',
    tempo: 'Continuous',
    notes: "Farmer's walk or front rack carry. Start 4–5 min after intervals.",
    isNew: true,
  ),
];

const _wedPosteriorExercises = [
  BlockExerciseModel(
    exercise: _rdl,
    exerciseOrder: 0,
    sets: 4,
    reps: '8–10',
    tempo: '3-1-1-1',
    notes: 'Load progresses from Phase 1',
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 1,
    sets: 3,
    reps: '5–8',
    tempo: '4-0-1-0',
    notes: 'Remove band assistance if used in Phase 1',
  ),
  BlockExerciseModel(
    exercise: _isoGluteBridge,
    exerciseOrder: 2,
    sets: 3,
    reps: '45–60s',
    tempo: 'Static',
    notes: 'Single-leg option if bilateral feels easy',
  ),
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 3,
    sets: 3,
    reps: '10/side',
    tempo: '1-5-1-0',
    notes: 'Load increases from Phase 1',
  ),
];

final _wedCooldownExercises = [
  _cooldown('Cat-Cow', '2×15', 0),
  _cooldown('Deep Squat Hold', '2 min', 1),
  _cooldown('Supine Figure-4 Stretch', '90s/side', 2),
];

final phase2Wednesday = SessionModel(
  phaseNumber: 2,
  weekDay: 3,
  name: 'The Engine — Intervals Begin + Posterior Chain',
  focus: 'HIIT intervals introduced · Loaded conditioning · RDL & Nordic maintained · Breathing protocol',
  estimatedMinutes: 85,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 10 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 10,
      exercises: _wedWarmupExercises,
    ),
    const BlockModel(
      name: 'CONDITIONING BLOCK — INTERVALS NOW ACTIVE',
      blockOrder: 1,
      blockType: BlockType.conditioning,
      instructions:
          'Phase 2 Conditioning Protocol (jump rope or running):\n'
          '• Weeks 7–8: 6 rounds × 20s ALL OUT / 40s walk\n'
          '• Weeks 9–10: 8 rounds × 20s ALL OUT / 40s walk\n'
          '• Weeks 11–12: 8 rounds × 20s ALL OUT / 35s walk (rest reduces, not work)\n'
          'After intervals, rest 4–5 min, then perform the loaded carry.',
      exercises: _wedConditioningExercises,
    ),
    const BlockModel(
      name: 'POSTERIOR CHAIN BLOCK',
      blockOrder: 2,
      blockType: BlockType.posterior,
      instructions:
          'BREATHING PROTOCOL: Inhale during the eccentric. Brace and hold at the concentric transition. Exhale at the top. Every rep, every exercise.',
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
// Thursday — Posterior Chain, Pull + Advanced Grip Protocol
// ---------------------------------------------------------------------------

const _thuWarmupExercises = [
  BlockExerciseModel(
    exercise: _tendonGlides,
    exerciseOrder: 0,
    sets: 1,
    reps: '2 min',
    tempo: 'Slow',
    notes: 'All positions',
  ),
  BlockExerciseModel(
    exercise: _bandFingerExtensions,
    exerciseOrder: 1,
    sets: 3,
    reps: '20',
    tempo: 'Controlled',
    notes: 'Forearm balance',
  ),
  BlockExerciseModel(
    exercise: _broadJumps,
    exerciseOrder: 2,
    sets: 3,
    reps: '4',
    tempo: 'X',
    notes: 'Posterior chain CNS activation',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _birdDog,
    exerciseOrder: 3,
    sets: 2,
    reps: '8/side (5s hold)',
    tempo: 'Controlled',
    notes: 'Lumbar activation',
  ),
];

const _thuMainExercises = [
  BlockExerciseModel(
    exercise: _weightedPullUps,
    exerciseOrder: 0,
    sets: 4,
    reps: '5–7',
    tempo: '2-1-X-0',
    notes: 'Add load this phase. Pause at top.',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _isoDeadHang,
    exerciseOrder: 1,
    sets: 3,
    reps: 'Max',
    tempo: 'Static',
    notes: 'Goal: 45–90s by end of Phase 2',
  ),
  BlockExerciseModel(
    exercise: _dbRDL,
    exerciseOrder: 2,
    sets: 4,
    reps: '8–10',
    tempo: '3-1-1-0',
    notes: 'Added to Thursday — posterior chain frequency',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _chestSupportedRow,
    exerciseOrder: 3,
    sets: 3,
    reps: '10',
    tempo: '2-1-X-1',
    notes: 'Mid-back. Focus on scapular retraction.',
  ),
  BlockExerciseModel(
    exercise: _overheadDBShrugs,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-0-2-1',
    notes: 'Rotator cuff + upper trap at overhead angle',
    isNew: true,
  ),
];

const _thuGripExercises = [
  BlockExerciseModel(
    exercise: _towelWringing,
    exerciseOrder: 0,
    sets: 3,
    reps: '60s',
    tempo: 'Continuous',
    notes: 'Forearm endurance — grappling prep',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _palmarisBrevisSqueeze,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: '1-1-1-1',
    notes: 'Inner palm grip closure',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _dbPronation,
    exerciseOrder: 2,
    sets: 2,
    reps: '12',
    tempo: '2-0-2-0',
    notes: 'Load increases from Phase 1',
  ),
  BlockExerciseModel(
    exercise: _dbSupination,
    exerciseOrder: 3,
    sets: 2,
    reps: '12',
    tempo: '2-0-2-0',
    notes: 'Supinator integrity',
  ),
  BlockExerciseModel(
    exercise: _fatGripzHolds,
    exerciseOrder: 4,
    sets: 3,
    reps: 'Max time',
    tempo: 'Static',
    notes: 'Max time — grip endurance',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 5,
    sets: 3,
    reps: '5–8',
    tempo: '4-0-1-0',
    notes: 'Second weekly exposure — hamstring',
  ),
];

final _thuCooldownExercises = [
  _cooldown('Seated Forward Fold', '2 min', 0),
  _cooldown('Dead Hang (passive)', '2×60s', 1),
  _cooldown('Lat Stretch on Rack', '60s/side', 2),
];

final phase2Thursday = SessionModel(
  phaseNumber: 2,
  weekDay: 4,
  name: 'Posterior Chain, Pull + Advanced Grip Protocol',
  focus: 'Heavier pulling · Full grip/forearm system · Overhead shrug intro · Wrist drills',
  estimatedMinutes: 80,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 10 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 10,
      exercises: _thuWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN BLOCK',
      blockOrder: 1,
      blockType: BlockType.main,
      exercises: _thuMainExercises,
    ),
    const BlockModel(
      name: 'GRIP & FOREARM ARMOR BLOCK',
      blockOrder: 2,
      blockType: BlockType.grip,
      exercises: _thuGripExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 3,
      blockType: BlockType.cooldown,
      exercises: _thuCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Friday — Core Circuit + Mobility + Functional Finishing
// ---------------------------------------------------------------------------

const _friWarmupExercises = [
  BlockExerciseModel(
    exercise: _bandedClamshell,
    exerciseOrder: 0,
    sets: 3,
    reps: '15/side',
    tempo: '2-1-1-0',
    notes: 'Glute med activation',
  ),
  BlockExerciseModel(
    exercise: _seatedHipIRER,
    exerciseOrder: 1,
    sets: 2,
    reps: '15 each way',
    tempo: 'Slow',
    notes: 'Hip capsule mobility',
  ),
  BlockExerciseModel(
    exercise: _pubicCrunch,
    exerciseOrder: 2,
    sets: 3,
    reps: '10',
    tempo: '2-1-2-1',
    notes: 'Pelvic floor integration',
  ),
  BlockExerciseModel(
    exercise: _armCirclesShadow,
    exerciseOrder: 3,
    sets: 1,
    reps: '3 min',
    tempo: 'Fluid',
    notes: 'Shoulder mobility',
  ),
  BlockExerciseModel(
    exercise: _bandDislocations,
    exerciseOrder: 4,
    sets: 2,
    reps: '15',
    tempo: 'Slow',
    notes: 'Thoracic mobility',
  ),
];

const _friMainExercises = [
  BlockExerciseModel(
    exercise: _cossackSquatLoaded,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side',
    tempo: '2-1-1-1',
    notes: 'Add light load now',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _seatedDBOHP,
    exerciseOrder: 1,
    sets: 3,
    reps: '10',
    tempo: '2-1-1-1',
    notes: 'Seated = shoulder-safer angle',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _dbHammerCurls,
    exerciseOrder: 2,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-0',
    notes: 'Load increases',
  ),
  BlockExerciseModel(
    exercise: _overheadCableTriceps,
    exerciseOrder: 3,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-1',
    notes: 'Long head stretch',
  ),
];

const _friCoreExercises = [
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 0,
    sets: 4,
    reps: '10/side',
    tempo: '1-5-1-0',
    notes: 'Load increases',
  ),
  BlockExerciseModel(
    exercise: _cableWoodchoppers,
    exerciseOrder: 1,
    sets: 3,
    reps: '12/side',
    tempo: '2-1-2-1',
    notes: 'Full ROM, controlled',
  ),
  BlockExerciseModel(
    exercise: _unilateralFarmersWalk,
    exerciseOrder: 2,
    sets: 3,
    reps: '40m/side',
    tempo: 'Continuous',
    notes: 'Anti-lateral flexion core',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _pufferFish,
    exerciseOrder: 3,
    sets: 3,
    reps: '30s',
    tempo: 'Static',
    notes: '360° brace — full circumferential IAP',
  ),
  BlockExerciseModel(
    exercise: _abWheel,
    exerciseOrder: 4,
    sets: 3,
    reps: '10–12',
    tempo: '3-1-X-0',
    notes: 'Full rollout if possible now',
  ),
];

const _friFinishingExercises = [
  BlockExerciseModel(
    exercise: _cableLateralRaise,
    exerciseOrder: 0,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'Shoulder width',
  ),
  BlockExerciseModel(
    exercise: _rearDeltCableFly,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'Rear delt + rotator cuff balance',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _cableCrunch,
    exerciseOrder: 2,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'Ab endurance',
    isNew: true,
  ),
  BlockExerciseModel(
    exercise: _hangingKneeRaise,
    exerciseOrder: 3,
    sets: 3,
    reps: '12',
    tempo: '2-1-1-0',
    notes: 'Core finisher',
  ),
];

final _friCooldownExercises = [
  _cooldown('Foam Roll — quads, lats, upper back', '5 min', 0),
  _cooldown('Static neck stretch', '30s/side', 1),
  _cooldown('90-90 Hip Stretch', '2 min/side', 2),
  _cooldown('Pigeon Pose', '90s/side', 3),
];

final phase2Friday = SessionModel(
  phaseNumber: 2,
  weekDay: 5,
  name: 'Core Circuit + Mobility + Functional Finishing',
  focus: 'Pelvic stability · Anti-rotation · Hip mobility · Shoulder aesthetics · Finishing circuit',
  estimatedMinutes: 85,
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
      name: 'CORE & PELVIC FLOOR BLOCK',
      blockOrder: 2,
      blockType: BlockType.core,
      exercises: _friCoreExercises,
    ),
    const BlockModel(
      name: 'FINISHING CIRCUIT — 3 ROUNDS',
      blockOrder: 3,
      blockType: BlockType.finishing,
      instructions:
          '3 rounds. No rest within a round. 90s rest between rounds.',
      exercises: _friFinishingExercises,
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 4,
      blockType: BlockType.cooldown,
      exercises: _friCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Phase 2 — top-level definition
// ---------------------------------------------------------------------------

const phase2 = PhaseModel(
  number: 2,
  name: 'Engine Build',
  subtitle: 'Aerobic & Anaerobic Development',
  weeksStart: 7,
  weeksEnd: 12,
  intensityMin: 0.75,
  intensityMax: 0.80,
  deloadWeeks: [10],
  overviewText:
      'Your aerobic base is now established and your movement quality is significantly better. '
      'Phase 2 introduces intervals, circuit conditioning, and heavier strength loading. The '
      'conditioning block becomes the centrepiece — jump rope HIIT, loaded circuits, and barbell '
      'work replace pure steady-state. Body fat loss accelerates. Left shoulder: re-assess; if '
      'stable and pain-free, cautious bilateral pressing begins at sub-maximal loads.',
);

/// All 5 sessions for Phase 2 (Mon–Fri). Same sessions repeat for weeks 7–12
/// (deload modifier is applied at runtime by WeekCalculator, not here).
final phase2Sessions = [
  phase2Monday,
  phase2Tuesday,
  phase2Wednesday,
  phase2Thursday,
  phase2Friday,
];
