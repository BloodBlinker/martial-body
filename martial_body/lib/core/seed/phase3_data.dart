import '../models/block_model.dart';
import '../models/exercise_model.dart';
import '../models/phase_model.dart';
import '../models/session_model.dart';

// ---------------------------------------------------------------------------
// Exercise definitions — names match Phase 1/2 where the exercise recurs so
// the Drift upsert-by-name collapses them to a single row.
// ---------------------------------------------------------------------------

// -- Shared / warmup (reused from Phase 1/2)
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
const _tendonGlides = ExerciseModel(name: 'Tendon Glides', category: 'mobility');
const _bandFingerExtensions = ExerciseModel(name: 'Band Finger Extensions', category: 'mobility');
const _broadJumps = ExerciseModel(name: 'Broad Jumps', category: 'strength');
const _bandedClamshell = ExerciseModel(name: 'Banded Clamshell', category: 'mobility');
const _seatedHipIRER = ExerciseModel(name: 'Seated Hip IR/ER', category: 'mobility');
const _pubicCrunch = ExerciseModel(name: 'Pubic Crunch — Pyramidalis', category: 'core');
const _armCirclesShadow = ExerciseModel(name: 'Arm Circles + Shadowboxing', category: 'mobility');
const _bandDislocations = ExerciseModel(name: 'Band Dislocations', category: 'mobility');

// -- Monday main / tendon
const _dbJumpSquats = ExerciseModel(name: 'DB Jump Squats', category: 'strength');
const _dbBulgarianSplitSquat = ExerciseModel(name: 'DB Bulgarian Split Squat', category: 'strength');
const _legExtensionVMO = ExerciseModel(name: 'Leg Extension (VMO bias)', category: 'strength');
const _seatedAdductor = ExerciseModel(name: 'Seated Adductor Machine', category: 'strength');
const _heavyDBFarmersWalk = ExerciseModel(name: "Heavy DB Farmer's Walk", category: 'conditioning');
const _isoWallSitSingleLeg = ExerciseModel(name: 'Isometric Wall Sit — Single Leg', category: 'tendon');
const _standingCalfRaiseSlow = ExerciseModel(name: 'Standing Calf Raise — slow', category: 'tendon');
const _footDoming = ExerciseModel(name: 'Foot Doming Exercise', category: 'tendon');
const _toeCurlsTowel = ExerciseModel(name: 'Toe Curls — Towel', category: 'tendon');

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
const _heavySledPush = ExerciseModel(name: 'Heavy Sled Push / Reverse Drag', category: 'conditioning');
const _rdlBarbell = ExerciseModel(name: 'RDL — Barbell', category: 'strength');
const _nordicCurl = ExerciseModel(name: 'Nordic Curl', category: 'strength');
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
const _cossackSquatLoadedHeavy =
    ExerciseModel(name: 'Cossack Squat — Loaded', category: 'strength');
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
// Monday — Lower Body Explosive Power + Full Joint Armor
// ---------------------------------------------------------------------------

const _monWarmupExercises = [
  BlockExerciseModel(
    exercise: _shortFoot,
    exerciseOrder: 0,
    sets: 3,
    reps: '20s/foot',
    tempo: 'Static',
    notes: 'Full arch activation',
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
    notes: 'Shin armor before loading',
  ),
  BlockExerciseModel(
    exercise: _pogoJumps,
    exerciseOrder: 3,
    sets: 3,
    reps: '20s',
    tempo: 'Rapid',
    notes: 'Achilles elastic loading — CNS prep',
  ),
  BlockExerciseModel(
    exercise: _cossackSquatBW,
    exerciseOrder: 4,
    sets: 2,
    reps: '8/side',
    tempo: '2-1-1-0',
    notes: 'Hip mobility — light',
  ),
  BlockExerciseModel(
    exercise: _copenhagenPlank,
    exerciseOrder: 5,
    sets: 2,
    reps: '20s/side',
    tempo: 'Static',
    notes: 'Adductor / groin',
  ),
];

const _monMainExercises = [
  BlockExerciseModel(
    exercise: _dbJumpSquats,
    exerciseOrder: 0,
    sets: 4,
    reps: '5',
    tempo: '1-0-X-0',
    restSeconds: 90,
    notes: 'Land soft. Reset each rep.',
  ),
  BlockExerciseModel(
    exercise: _dbBulgarianSplitSquat,
    exerciseOrder: 1,
    sets: 3,
    reps: '6–8/leg',
    tempo: '2-1-X-0',
    restSeconds: 90,
    notes: 'Heavier than Phase 2. Weak leg first.',
  ),
  BlockExerciseModel(
    exercise: _legExtensionVMO,
    exerciseOrder: 2,
    sets: 3,
    reps: '12–15',
    tempo: '2-1-2-1',
    restSeconds: 75,
    notes: 'Working load.',
  ),
  BlockExerciseModel(
    exercise: _seatedAdductor,
    exerciseOrder: 3,
    sets: 3,
    reps: '15',
    tempo: '2-1-1-0',
    restSeconds: 60,
  ),
  BlockExerciseModel(
    exercise: _heavyDBFarmersWalk,
    exerciseOrder: 4,
    sets: 4,
    reps: '40m',
    tempo: 'Continuous',
    restSeconds: 60,
    notes: 'Heavy. Brace trunk.',
  ),
];

const _monTendonExercises = [
  BlockExerciseModel(
    exercise: _isoWallSitSingleLeg,
    exerciseOrder: 0,
    sets: 3,
    reps: 'Failure',
    tempo: 'Static',
    restSeconds: 60,
    notes: 'Weighted if possible.',
  ),
  BlockExerciseModel(
    exercise: _standingCalfRaiseSlow,
    exerciseOrder: 1,
    sets: 4,
    reps: '12–15',
    tempo: '2-1-2-2',
    restSeconds: 75,
    notes: 'Slow eccentric — Achilles.',
  ),
  BlockExerciseModel(
    exercise: _footDoming,
    exerciseOrder: 2,
    sets: 2,
    reps: '15',
    tempo: '1-1-1-1',
  ),
  BlockExerciseModel(
    exercise: _toeCurlsTowel,
    exerciseOrder: 3,
    sets: 3,
    reps: '10',
    tempo: '1-1-1-1',
    restSeconds: 45,
  ),
];

final _monCooldownExercises = [
  _cooldown('90-90 Hip Stretch', '2 min/side', 0),
  _cooldown('Couch Stretch', '90s/side', 1),
  _cooldown('Pigeon Pose', '90s/side', 2),
];

final phase3Monday = SessionModel(
  phaseNumber: 3,
  weekDay: 1,
  name: 'Lower Body Explosive Power + Full Joint Armor',
  focus:
      'Rate of force development · Knee bulletproofing · Full foot/arch protocol · Anaerobic output',
  estimatedMinutes: 90,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 15 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 15,
      exercises: _monWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN COMBAT BLOCK',
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
// Tuesday — Upper Body Power + Full Iron Chin Protocol
// ---------------------------------------------------------------------------

const _tueWarmupExercises = [
  BlockExerciseModel(
    exercise: _chinTucks,
    exerciseOrder: 0,
    sets: 3,
    reps: '10 (5s hold)',
    tempo: 'Controlled',
    notes: 'Deep cervical flexors',
  ),
  BlockExerciseModel(
    exercise: _jawOpener,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Slow',
    notes: 'TMJ',
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
    reps: '10s × 4 directions',
    tempo: 'Static',
    notes: 'Front / back / left / right',
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
    notes: 'Clapping — upper CNS potentiation',
  ),
];

const _tueMainExercises = [
  BlockExerciseModel(
    exercise: _inclineDBPress,
    exerciseOrder: 0,
    sets: 4,
    reps: '6–8',
    tempo: '2-1-X-0',
    restSeconds: 120,
    notes: 'Working weight. Full ROM.',
  ),
  BlockExerciseModel(
    exercise: _dbFloorPress,
    exerciseOrder: 1,
    sets: 3,
    reps: '8–10',
    tempo: '2-1-X-0',
    restSeconds: 90,
  ),
  BlockExerciseModel(
    exercise: _isoPushUpHold,
    exerciseOrder: 2,
    sets: 3,
    reps: 'Failure',
    tempo: 'Static',
    restSeconds: 60,
    notes: 'Extended from Phase 2.',
  ),
  BlockExerciseModel(
    exercise: _cableWoodchoppers,
    exerciseOrder: 3,
    sets: 3,
    reps: '8/side',
    tempo: '1-0-X-0',
    restSeconds: 60,
    notes: 'Violent intent now.',
  ),
  BlockExerciseModel(
    exercise: _lowToHighCableFly,
    exerciseOrder: 4,
    sets: 3,
    reps: '12–15',
    tempo: '2-1-2-1',
    restSeconds: 75,
    notes: 'Uppercut mechanics.',
  ),
];

const _tueTendonNeckExercises = [
  BlockExerciseModel(
    exercise: _heavyDBShrugs,
    exerciseOrder: 0,
    sets: 4,
    reps: '12',
    tempo: '2-0-X-3',
    restSeconds: 60,
    notes: 'Heavy. Trap thickness.',
  ),
  BlockExerciseModel(
    exercise: _neckExtension,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    restSeconds: 60,
    notes: 'Heavier load.',
  ),
  BlockExerciseModel(
    exercise: _neckFlexion,
    exerciseOrder: 2,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    restSeconds: 60,
  ),
  BlockExerciseModel(
    exercise: _cableLateralRaise,
    exerciseOrder: 3,
    sets: 4,
    reps: '15–20',
    tempo: '2-1-2-1',
    restSeconds: 60,
    notes: 'Full shoulder protocol.',
  ),
];

final _tueCooldownExercises = [
  _cooldown('Crucifixion Stretch', '2×60s', 0),
  _cooldown("Child's Pose", '90s', 1),
];

final phase3Tuesday = SessionModel(
  phaseNumber: 3,
  weekDay: 2,
  name: 'Upper Body Power + Full Iron Chin Protocol',
  focus:
      'Pushing velocity · Full neck protocol · Shoulder durability · Rotator cuff volume',
  estimatedMinutes: 90,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 12 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 12,
      exercises: _tueWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN COMBAT BLOCK',
      blockOrder: 1,
      blockType: BlockType.main,
      exercises: _tueMainExercises,
    ),
    const BlockModel(
      name: 'TENDON & ARMOR BLOCK',
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
// Wednesday — The Engine — Full Sprint Protocol + Posterior Chain
// ---------------------------------------------------------------------------

const _wedWarmupExercises = [
  BlockExerciseModel(
    exercise: _birdDog,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side (5s hold)',
    tempo: 'Controlled',
    notes: 'Lumbar stability',
  ),
  BlockExerciseModel(
    exercise: _pelvicFloorDrawIn,
    exerciseOrder: 1,
    sets: 4,
    reps: '10 (5s hold)',
    tempo: 'Static',
    notes: 'Core pressurisation prep',
  ),
  BlockExerciseModel(
    exercise: _jumpRopeEasy,
    exerciseOrder: 2,
    sets: 1,
    reps: '3 min',
    tempo: 'Moderate',
    notes: 'Progressive HR ramp',
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
    sets: 8,
    reps: '15s',
    tempo: 'ALL OUT',
    notes: '45s active recovery between rounds.',
  ),
  BlockExerciseModel(
    exercise: _heavySledPush,
    exerciseOrder: 1,
    sets: 4,
    reps: '30m',
    tempo: 'Maximal',
    restSeconds: 60,
    notes: 'If no sled: heavy barbell push on floor.',
  ),
];

const _wedPosteriorExercises = [
  BlockExerciseModel(
    exercise: _rdlBarbell,
    exerciseOrder: 0,
    sets: 4,
    reps: '8–10',
    tempo: '3-1-1-1',
    restSeconds: 120,
    notes: 'Heavy loading phase.',
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 1,
    sets: 3,
    reps: '5–8',
    tempo: '4-0-1-0',
    restSeconds: 90,
    notes: 'No band. Controlled descent only.',
  ),
  BlockExerciseModel(
    exercise: _isoGluteBridge,
    exerciseOrder: 2,
    sets: 3,
    reps: '45–60s',
    tempo: 'Static',
    restSeconds: 60,
    notes: 'Single-leg option.',
  ),
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 3,
    sets: 3,
    reps: '10/side',
    tempo: '1-5-1-0',
    restSeconds: 45,
    notes: 'Load at working level.',
  ),
];

final _wedCooldownExercises = [
  _cooldown('Cat-Cow', '2×15', 0),
  _cooldown('Deep Squat Hold', '2 min', 1),
];

final phase3Wednesday = SessionModel(
  phaseNumber: 3,
  weekDay: 3,
  name: 'The Engine — Full Sprint Protocol + Posterior Chain',
  focus:
      '8×15s ALL OUT intervals · Sled / loaded carry · RDL · Nordic · Full breathing integration',
  estimatedMinutes: 90,
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
          'Full Sprint Protocol — do NOT modify:\n'
          '8 rounds × 15s ALL OUT / 45s active recovery (walk or slow jog).\n'
          'Tool: Jump rope (preferred) · outdoor sprints · stair runs — no treadmill.\n'
          'After full rest (≈5 min), proceed to the heavy sled / loaded carry.',
      exercises: _wedConditioningExercises,
    ),
    const BlockModel(
      name: 'POSTERIOR CHAIN BLOCK',
      blockOrder: 2,
      blockType: BlockType.posterior,
      instructions:
          'BREATHING PROTOCOL: Inhale the eccentric. Brace at the transition. Exhale at the top. Every rep, every exercise in this block.',
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
// Thursday — Posterior Chain, Pulling + Full Grappling Armor
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
  ),
  BlockExerciseModel(
    exercise: _broadJumps,
    exerciseOrder: 2,
    sets: 3,
    reps: '4',
    tempo: 'X',
    notes: 'Posterior CNS activation',
  ),
  BlockExerciseModel(
    exercise: _birdDog,
    exerciseOrder: 3,
    sets: 2,
    reps: '8/side (5s hold)',
    tempo: 'Controlled',
  ),
];

const _thuMainExercises = [
  BlockExerciseModel(
    exercise: _weightedPullUps,
    exerciseOrder: 0,
    sets: 4,
    reps: '5–7',
    tempo: '2-1-X-0',
    restSeconds: 120,
    notes: 'Heavy. Pause at top.',
  ),
  BlockExerciseModel(
    exercise: _isoDeadHang,
    exerciseOrder: 1,
    sets: 3,
    reps: 'Max',
    tempo: 'Static',
    restSeconds: 90,
    notes: 'Goal: 60–120s.',
  ),
  BlockExerciseModel(
    exercise: _dbRDL,
    exerciseOrder: 2,
    sets: 4,
    reps: '8–10',
    tempo: '3-1-1-0',
    restSeconds: 120,
    notes: 'Working weight.',
  ),
  BlockExerciseModel(
    exercise: _chestSupportedRow,
    exerciseOrder: 3,
    sets: 3,
    reps: '8–10',
    tempo: '2-1-X-1',
    restSeconds: 90,
    notes: 'Scapular retraction.',
  ),
  BlockExerciseModel(
    exercise: _overheadDBShrugs,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-0-2-1',
    restSeconds: 75,
    notes: 'Overhead angle — rotator cuff.',
  ),
];

const _thuGripExercises = [
  BlockExerciseModel(
    exercise: _towelWringing,
    exerciseOrder: 0,
    sets: 3,
    reps: '60s',
    tempo: 'Continuous',
    restSeconds: 60,
    notes: 'Grappling endurance.',
  ),
  BlockExerciseModel(
    exercise: _palmarisBrevisSqueeze,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: '1-1-1-1',
    restSeconds: 45,
  ),
  BlockExerciseModel(
    exercise: _dbPronation,
    exerciseOrder: 2,
    sets: 2,
    reps: '12',
    tempo: '2-0-2-0',
    restSeconds: 45,
    notes: 'Working load.',
  ),
  BlockExerciseModel(
    exercise: _dbSupination,
    exerciseOrder: 3,
    sets: 2,
    reps: '12',
    tempo: '2-0-2-0',
    restSeconds: 45,
  ),
  BlockExerciseModel(
    exercise: _fatGripzHolds,
    exerciseOrder: 4,
    sets: 3,
    reps: 'Max',
    tempo: 'Static',
    restSeconds: 60,
    notes: 'Max time.',
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 5,
    sets: 3,
    reps: '5–8',
    tempo: '4-0-1-0',
    restSeconds: 90,
    notes: 'Second weekly exposure.',
  ),
];

final _thuCooldownExercises = [
  _cooldown('Seated Forward Fold', '2 min', 0),
  _cooldown('Dead Hang (passive)', '2×60s', 1),
  _cooldown('Lat Stretch on Rack', '60s/side', 2),
];

final phase3Thursday = SessionModel(
  phaseNumber: 3,
  weekDay: 4,
  name: 'Posterior Chain, Pulling + Full Grappling Armor',
  focus:
      'Weighted pull-ups · Full grip system · Wrist drills · Back thickness · Nordic second exposure',
  estimatedMinutes: 90,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 10 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 10,
      exercises: _thuWarmupExercises,
    ),
    const BlockModel(
      name: 'MAIN COMBAT BLOCK',
      blockOrder: 1,
      blockType: BlockType.main,
      exercises: _thuMainExercises,
    ),
    const BlockModel(
      name: 'FULL GRIP & FOREARM ARMOR BLOCK',
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
// Friday — Core, Mobility + Functional Finishing Circuit
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
    notes: 'Hip capsule',
  ),
  BlockExerciseModel(
    exercise: _pubicCrunch,
    exerciseOrder: 2,
    sets: 3,
    reps: '10',
    tempo: '2-1-2-1',
    notes: 'Pelvic floor',
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
    exercise: _cossackSquatLoadedHeavy,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side',
    tempo: '2-1-1-1',
    restSeconds: 90,
    notes: 'Heavier than Phase 2.',
  ),
  BlockExerciseModel(
    exercise: _seatedDBOHP,
    exerciseOrder: 1,
    sets: 3,
    reps: '8–10',
    tempo: '2-1-1-1',
    restSeconds: 90,
  ),
  BlockExerciseModel(
    exercise: _dbHammerCurls,
    exerciseOrder: 2,
    sets: 3,
    reps: '10–12',
    tempo: '2-1-2-0',
    restSeconds: 60,
  ),
  BlockExerciseModel(
    exercise: _overheadCableTriceps,
    exerciseOrder: 3,
    sets: 3,
    reps: '10–12',
    tempo: '2-1-2-1',
    restSeconds: 60,
  ),
];

const _friCoreExercises = [
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 0,
    sets: 4,
    reps: '10/side',
    tempo: '1-5-1-0',
    restSeconds: 60,
    notes: 'Working load.',
  ),
  BlockExerciseModel(
    exercise: _cableWoodchoppers,
    exerciseOrder: 1,
    sets: 3,
    reps: '12/side',
    tempo: '2-1-2-1',
    restSeconds: 75,
  ),
  BlockExerciseModel(
    exercise: _unilateralFarmersWalk,
    exerciseOrder: 2,
    sets: 3,
    reps: '40m/side',
    tempo: 'Continuous',
    restSeconds: 60,
    notes: 'Heavy. Anti-lateral flexion.',
  ),
  BlockExerciseModel(
    exercise: _pufferFish,
    exerciseOrder: 3,
    sets: 3,
    reps: '30s',
    tempo: 'Static',
    restSeconds: 45,
  ),
  BlockExerciseModel(
    exercise: _abWheel,
    exerciseOrder: 4,
    sets: 3,
    reps: '10–12',
    tempo: '3-1-X-0',
    restSeconds: 60,
    notes: 'Full rollout.',
  ),
];

const _friFinishingExercises = [
  BlockExerciseModel(
    exercise: _cableLateralRaise,
    exerciseOrder: 0,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
  ),
  BlockExerciseModel(
    exercise: _rearDeltCableFly,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
  ),
  BlockExerciseModel(
    exercise: _cableCrunch,
    exerciseOrder: 2,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
  ),
  BlockExerciseModel(
    exercise: _hangingKneeRaise,
    exerciseOrder: 3,
    sets: 3,
    reps: '12',
    tempo: '2-1-1-0',
    notes: 'Ab wheel substitute OK.',
  ),
];

final _friCooldownExercises = [
  _cooldown('Foam Roll — quads, lats, upper back', '5 min', 0),
  _cooldown('Static neck stretch', '30s/side', 1),
  _cooldown('90-90 Hip Stretch', '2 min/side', 2),
  _cooldown('Pigeon Pose', '90s/side', 3),
];

final phase3Friday = SessionModel(
  phaseNumber: 3,
  weekDay: 5,
  name: 'Core, Mobility + Functional Finishing Circuit',
  focus:
      'Pelvic stability · Full core system · Shoulder circuit · Closing the week right',
  estimatedMinutes: 90,
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
// Phase 3 — top-level definition
// ---------------------------------------------------------------------------

const phase3 = PhaseModel(
  number: 3,
  name: 'Full Enhanced Combat',
  subtitle: 'Full Program Runs as Designed',
  weeksStart: 13,
  weeksEnd: 20,
  intensityMin: 0.85,
  intensityMax: 0.90,
  deloadWeeks: [16, 20],
  overviewText:
      'The full enhanced merged program runs as written. Your aerobic base now supports '
      'sprint intervals, joints have been prepared across 12 weeks, and explosive power work '
      '(jump squats, plyo push-ups, broad jumps) is added in full. The entire tendon armor '
      'block operates as designed. All loading is at working intensity — 85–90% of perceived '
      'max. Deloads at weeks 16 and 20. Body composition should be visibly changed by week 16.',
);

/// All 5 sessions for Phase 3 (Mon–Fri). Same sessions repeat for weeks 13–20
/// (deload modifier is applied at runtime by WeekCalculator, not here).
final phase3Sessions = [
  phase3Monday,
  phase3Tuesday,
  phase3Wednesday,
  phase3Thursday,
  phase3Friday,
];
