import '../models/block_model.dart';
import '../models/exercise_model.dart';
import '../models/phase_model.dart';
import '../models/session_model.dart';

// ---------------------------------------------------------------------------
// Exercise definitions — reused across blocks
// ---------------------------------------------------------------------------

// -- Mobility / warmup
const _shortFoot = ExerciseModel(name: 'Short Foot Exercise', category: 'mobility');
const _reverseHeelTap = ExerciseModel(name: 'Reverse Heel Tap', category: 'mobility');
const _tibialisRaise = ExerciseModel(name: 'Tibialis Anterior Raise', category: 'mobility');
const _catCow = ExerciseModel(name: 'Cat-Cow Stretch', category: 'mobility');
const _cossackSquatBW = ExerciseModel(name: 'Cossack Squats (BW)', category: 'mobility');
const _gluteBridgeBW = ExerciseModel(name: 'Glute Bridge (BW)', category: 'mobility');

// -- Monday main
const _gobletSquat = ExerciseModel(name: 'Goblet Squat', category: 'strength');
const _bulgarianSplitSquat = ExerciseModel(name: 'Bulgarian Split Squat (BW or light DB)', category: 'strength');
const _legPress = ExerciseModel(name: 'Leg Press', category: 'strength');
const _legExtension = ExerciseModel(name: 'Leg Extension (VMO)', category: 'strength');
const _seatedAdductor = ExerciseModel(name: 'Seated Adductor Machine', category: 'strength');
const _singleLegCalfRaise = ExerciseModel(name: 'Single-Leg Calf Raise', category: 'strength');

// -- Monday tendon
const _isoWallSit = ExerciseModel(name: 'Isometric Wall Sit', category: 'tendon');
const _footDoming = ExerciseModel(name: 'Foot Doming Exercise', category: 'tendon');
const _toeCurls = ExerciseModel(name: 'Toe Curls — Towel', category: 'tendon');

// -- Tuesday warmup
const _chinTucks = ExerciseModel(name: 'Chin Tucks + Head Lift', category: 'mobility');
const _jawOpener = ExerciseModel(name: 'Jaw Opener', category: 'mobility');
const _serratusWallSlides = ExerciseModel(name: 'Serratus Wall Slides', category: 'mobility');
const _cervicalFlexionHold = ExerciseModel(name: 'Cervical Flexion Hold', category: 'mobility');
const _bandPullAparts = ExerciseModel(name: 'Band Pull-Aparts', category: 'mobility');
const _armCirclesLarge = ExerciseModel(name: 'Arm Circles — Large', category: 'mobility');

// -- Tuesday main
const _singleArmDBChestPress = ExerciseModel(name: 'Single-Arm DB Chest Press', category: 'strength');
const _dbFloorPress = ExerciseModel(name: 'DB Floor Press', category: 'strength');
const _isoPushUpHold = ExerciseModel(name: 'Isometric Push-Up Hold', category: 'tendon');
const _cableWoodchoppers = ExerciseModel(name: 'Cable Woodchoppers', category: 'core');
const _pushUpPlus = ExerciseModel(name: 'Push-Up Plus', category: 'strength');

// -- Tuesday tendon/neck
const _dbShrugsLight = ExerciseModel(name: 'DB Shrugs — Light', category: 'neck');
const _neckFlexion = ExerciseModel(name: 'Neck Flexion — Plate/Towel', category: 'neck');
const _neckExtension = ExerciseModel(name: 'Neck Extension — Plate/Towel', category: 'neck');
const _bandLateralNeckHolds = ExerciseModel(name: 'Band Lateral Neck Holds', category: 'neck');

// -- Wednesday warmup
const _birdDog = ExerciseModel(name: 'Bird Dog', category: 'mobility');
const _pelvicFloorDrawIn = ExerciseModel(name: 'Pelvic Floor Draw-In', category: 'mobility');
const _proneCobra = ExerciseModel(name: 'Prone Cobra', category: 'mobility');
const _worldsGreatestStretch = ExerciseModel(name: "World's Greatest Stretch", category: 'mobility');

// -- Wednesday posterior chain
const _rdl = ExerciseModel(name: 'RDL — DB or Barbell', category: 'strength');
const _nordicCurl = ExerciseModel(name: 'Nordic Curl', category: 'strength');
const _isoGluteBridge = ExerciseModel(name: 'Isometric Glute Bridge', category: 'tendon');
const _pallofPress = ExerciseModel(name: 'Pallof Press', category: 'core');
const _backExtension45 = ExerciseModel(name: '45° Back Extension', category: 'strength');

// -- Thursday warmup
const _tendonGlides = ExerciseModel(name: 'Tendon Glides', category: 'mobility');
const _bandFingerExtensions = ExerciseModel(name: 'Band Finger Extensions', category: 'mobility');
const _deadHangPassive = ExerciseModel(name: 'Dead Hang (passive)', category: 'mobility');
const _scapularPullUps = ExerciseModel(name: 'Scapular Pull-Ups', category: 'mobility');
const _facePullsBand = ExerciseModel(name: 'Face Pulls — band/cable', category: 'mobility');

// -- Thursday main
const _pullUps = ExerciseModel(name: 'Pull-Ups or Assisted Pull-Ups', category: 'strength');
const _chestSupportedRow = ExerciseModel(name: 'Chest-Supported DB Row', category: 'strength');
const _singleArmDBRow = ExerciseModel(name: 'Single-Arm DB Row', category: 'strength');
const _cablePullover = ExerciseModel(name: 'Cable Pullover', category: 'strength');
const _facePullsCable = ExerciseModel(name: 'Face Pulls — Cable', category: 'strength');

// -- Thursday grip
const _isoDeadHang = ExerciseModel(name: 'Isometric Dead Hang', category: 'grip');
const _towelHang = ExerciseModel(name: 'Towel Hang', category: 'grip');
const _dbPronation = ExerciseModel(name: 'Dumbbell Pronation', category: 'grip');
const _dbSupination = ExerciseModel(name: 'Dumbbell Supination', category: 'grip');

// -- Friday warmup
const _bandedClamshell = ExerciseModel(name: 'Banded Clamshell', category: 'mobility');
const _seatedHipIRER = ExerciseModel(name: 'Seated Hip IR/ER', category: 'mobility');
const _pubicCrunch = ExerciseModel(name: 'Pubic Crunch — Pyramidalis', category: 'core');
const _armCirclesShadow = ExerciseModel(name: 'Arm Circles + Shadowboxing', category: 'mobility');
const _bandDislocations = ExerciseModel(name: 'Band Dislocations', category: 'mobility');

// -- Friday main
const _cossackSquatFri = ExerciseModel(name: 'Cossack Squat — BW', category: 'mobility');
const _singleArmDBOHP = ExerciseModel(name: 'Single-Arm DB OHP', category: 'strength');
const _dbHammerCurls = ExerciseModel(name: 'DB Hammer Curls', category: 'strength');
const _overheadCableTriceps = ExerciseModel(name: 'Overhead Cable Triceps Ext', category: 'strength');

// -- Friday core
const _pallofPressFri = ExerciseModel(name: 'Pallof Press', category: 'core');
const _cableWoodyFri = ExerciseModel(name: 'Cable Woodchoppers', category: 'core');
const _pufferFish = ExerciseModel(name: 'Puffer Fish — 360° brace', category: 'core');
const _abWheel = ExerciseModel(name: 'Ab Wheel Rollout', category: 'core');
const _hangingKneeRaise = ExerciseModel(name: 'Hanging Knee Raise', category: 'core');

// ---------------------------------------------------------------------------
// Cooldown exercises (static stretches — no sets/reps, self-paced)
// ---------------------------------------------------------------------------

BlockExerciseModel _cooldown(String name, String duration, int order) =>
    BlockExerciseModel(
      exercise: ExerciseModel(name: name, category: 'mobility'),
      exerciseOrder: order,
      reps: duration,
      tempo: 'Static',
    );

// ---------------------------------------------------------------------------
// Monday — Lower Body Mobility + Unilateral Strength
// ---------------------------------------------------------------------------

const _monWarmupExercises = [
  BlockExerciseModel(
    exercise: _shortFoot,
    exerciseOrder: 0,
    sets: 3,
    reps: '20s/foot',
    tempo: 'Static',
    notes: 'Arch activation before any loading',
  ),
  BlockExerciseModel(
    exercise: _reverseHeelTap,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    notes: 'Tib anterior + ankle proprioception',
  ),
  BlockExerciseModel(
    exercise: _tibialisRaise,
    exerciseOrder: 2,
    sets: 2,
    reps: '25',
    tempo: '2-1-2-0',
    notes: 'Shin armor — do against wall',
  ),
  BlockExerciseModel(
    exercise: _catCow,
    exerciseOrder: 3,
    sets: 2,
    reps: '10',
    tempo: 'Slow',
    notes: 'Thoracic + lumbar mobility',
  ),
  BlockExerciseModel(
    exercise: _cossackSquatBW,
    exerciseOrder: 4,
    sets: 2,
    reps: '8/side',
    tempo: '2-1-1-0',
    notes: 'Hip mobility, adductor prep',
  ),
  BlockExerciseModel(
    exercise: _gluteBridgeBW,
    exerciseOrder: 5,
    sets: 2,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'Glute activation before loading',
  ),
];

const _monMainExercises = [
  BlockExerciseModel(
    exercise: _gobletSquat,
    exerciseOrder: 0,
    sets: 3,
    reps: '12',
    tempo: '3-1-1-0',
    notes: 'Light KB/DB — focus on depth & knee track',
  ),
  BlockExerciseModel(
    exercise: _bulgarianSplitSquat,
    exerciseOrder: 1,
    sets: 3,
    reps: '8/leg',
    tempo: '3-2-1-0',
    notes: 'Start weak leg. Match reps on strong leg',
  ),
  BlockExerciseModel(
    exercise: _legPress,
    exerciseOrder: 2,
    sets: 3,
    reps: '12',
    tempo: '3-1-2-0',
    notes: 'Moderate load, full ROM, no knee lockout',
  ),
  BlockExerciseModel(
    exercise: _legExtension,
    exerciseOrder: 3,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'Light load. Terminal knee extension focus',
  ),
  BlockExerciseModel(
    exercise: _seatedAdductor,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-1-1-0',
    notes: 'Groin injury prevention',
  ),
  BlockExerciseModel(
    exercise: _singleLegCalfRaise,
    exerciseOrder: 5,
    sets: 3,
    reps: '12/leg',
    tempo: '3-1-X-2',
    notes: 'Slow stretch at bottom — Achilles health',
  ),
];

const _monTendonExercises = [
  BlockExerciseModel(
    exercise: _isoWallSit,
    exerciseOrder: 0,
    sets: 3,
    reps: '30–45s',
    tempo: 'Static',
    notes: 'Build to failure over 6 weeks',
  ),
  BlockExerciseModel(
    exercise: _footDoming,
    exerciseOrder: 1,
    sets: 2,
    reps: '15',
    tempo: '1-1-1-1',
    notes: 'Intrinsic arch strength',
  ),
  BlockExerciseModel(
    exercise: _toeCurls,
    exerciseOrder: 2,
    sets: 2,
    reps: '10',
    tempo: '1-1-1-1',
    notes: 'Plantar fascia protection',
  ),
];

final _monCooldownExercises = [
  _cooldown('90-90 Hip Stretch', '2 min/side', 0),
  _cooldown('Couch Stretch', '1 min/side', 1),
  _cooldown('Pigeon Pose', '90s/side', 2),
  _cooldown('Seated Forward Fold', '90s', 3),
];

final phase1Monday = SessionModel(
  phaseNumber: 1,
  weekDay: 1,
  name: 'Lower Body Mobility + Unilateral Strength',
  focus: 'Hip restoration · VMO activation · Arch & ankle prep · Asymmetry correction',
  estimatedMinutes: 80,
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
      name: 'CARDIO FINISHER',
      blockOrder: 3,
      blockType: BlockType.conditioning,
      durationMinutes: 25,
      instructions:
          '25 min steady-state: outdoor run or jump rope at conversational pace (60–65% max HR). No sprinting in Phase 1.',
      exercises: const [],
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 4,
      blockType: BlockType.cooldown,
      exercises: _monCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Tuesday — Upper Body Conservative Push + Neck Protocol
// ---------------------------------------------------------------------------

const _tueWarmupExercises = [
  BlockExerciseModel(
    exercise: _chinTucks,
    exerciseOrder: 0,
    sets: 3,
    reps: '10 (5s hold)',
    tempo: 'Controlled',
    notes: 'Deep cervical flexors — protect C-spine',
  ),
  BlockExerciseModel(
    exercise: _jawOpener,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Slow',
    notes: 'TMJ decompression',
  ),
  BlockExerciseModel(
    exercise: _serratusWallSlides,
    exerciseOrder: 2,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-0',
    notes: 'Scapular control pre-press',
  ),
  BlockExerciseModel(
    exercise: _cervicalFlexionHold,
    exerciseOrder: 3,
    sets: 1,
    reps: '10s each direction',
    tempo: 'Static',
    notes: 'Front / back / left / right',
  ),
  BlockExerciseModel(
    exercise: _bandPullAparts,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-0',
    notes: 'Rear delt + rotator cuff',
  ),
  BlockExerciseModel(
    exercise: _armCirclesLarge,
    exerciseOrder: 5,
    sets: 2,
    reps: '15 each',
    tempo: 'Slow',
    notes: 'Shoulder capsule mobility',
  ),
];

const _tueMainExercises = [
  BlockExerciseModel(
    exercise: _singleArmDBChestPress,
    exerciseOrder: 0,
    sets: 3,
    reps: '10/arm',
    tempo: '2-1-1-0',
    notes: 'Unilateral. Weak arm first. Expose gap now.',
  ),
  BlockExerciseModel(
    exercise: _dbFloorPress,
    exerciseOrder: 1,
    sets: 3,
    reps: '10',
    tempo: '2-1-X-0',
    notes: 'Shoulder-safe ROM. Moderate load only.',
  ),
  BlockExerciseModel(
    exercise: _isoPushUpHold,
    exerciseOrder: 2,
    sets: 3,
    reps: '20–30s',
    tempo: 'Static',
    notes: 'Mid-range hold — tendon adaptation',
  ),
  BlockExerciseModel(
    exercise: _cableWoodchoppers,
    exerciseOrder: 3,
    sets: 3,
    reps: '10/side',
    tempo: '2-0-X-0',
    notes: 'Light load. Rotational motor pattern.',
  ),
  BlockExerciseModel(
    exercise: _pushUpPlus,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-0-2-0',
    notes: 'Serratus activation at lockout',
  ),
];

const _tueTendonNeckExercises = [
  BlockExerciseModel(
    exercise: _dbShrugsLight,
    exerciseOrder: 0,
    sets: 3,
    reps: '15',
    tempo: '2-0-X-2',
    notes: 'Trap activation — not heavy in Phase 1',
  ),
  BlockExerciseModel(
    exercise: _neckFlexion,
    exerciseOrder: 1,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    notes: 'Front of neck. Very light load.',
  ),
  BlockExerciseModel(
    exercise: _neckExtension,
    exerciseOrder: 2,
    sets: 3,
    reps: '15',
    tempo: 'Controlled',
    notes: 'Back of neck. Controlled through full ROM.',
  ),
  BlockExerciseModel(
    exercise: _bandLateralNeckHolds,
    exerciseOrder: 3,
    sets: 2,
    reps: '20s/side',
    tempo: 'Static',
    notes: 'Build lateral neck strength safely',
  ),
];

final _tueCooldownExercises = [
  _cooldown('Crucifixion Stretch', '2×60s', 0),
  _cooldown('Child\'s Pose', '90s', 1),
  _cooldown('Doorway Chest Stretch', '60s/side', 2),
];

final phase1Tuesday = SessionModel(
  phaseNumber: 1,
  weekDay: 2,
  name: 'Upper Body — Conservative Push + Neck Protocol',
  focus: 'Shoulder prehab · Pressing at sub-max load · Neck strengthening · Serratus activation',
  estimatedMinutes: 80,
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
          'LEFT SHOULDER PROTOCOL ACTIVE — Stop immediately if any discomfort during pressing exercises. Replace bilateral press with single-arm DB press.',
      exercises: _tueMainExercises,
    ),
    const BlockModel(
      name: 'TENDON & NECK BLOCK',
      blockOrder: 2,
      blockType: BlockType.tendon,
      exercises: _tueTendonNeckExercises,
    ),
    BlockModel(
      name: 'CARDIO FINISHER',
      blockOrder: 3,
      blockType: BlockType.conditioning,
      durationMinutes: 25,
      instructions: '25 min steady-state: run or jump rope. Same pace as Monday.',
      exercises: const [],
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
// Wednesday — Posterior Chain + Breathing Foundation
// ---------------------------------------------------------------------------

const _wedWarmupExercises = [
  BlockExerciseModel(
    exercise: _birdDog,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side (5s hold)',
    tempo: 'Controlled',
    notes: 'Lumbar stability — do not rotate hips',
  ),
  BlockExerciseModel(
    exercise: _pelvicFloorDrawIn,
    exerciseOrder: 1,
    sets: 3,
    reps: '10 (5s hold)',
    tempo: 'Static',
    notes: 'Breathe in, draw navel up, hold',
  ),
  BlockExerciseModel(
    exercise: _proneCobra,
    exerciseOrder: 2,
    sets: 2,
    reps: '45s',
    tempo: 'Static',
    notes: 'Thoracic extension, shoulder retraction',
  ),
  BlockExerciseModel(
    exercise: _catCow,
    exerciseOrder: 3,
    sets: 2,
    reps: '10',
    tempo: 'Slow',
    notes: 'Spinal mobility',
  ),
  BlockExerciseModel(
    exercise: _worldsGreatestStretch,
    exerciseOrder: 4,
    sets: 2,
    reps: '5/side',
    tempo: 'Slow',
    notes: 'Full chain mobility',
  ),
];

const _wedPosteriorExercises = [
  BlockExerciseModel(
    exercise: _rdl,
    exerciseOrder: 0,
    sets: 4,
    reps: '8–10',
    tempo: '3-1-1-1',
    notes: 'Hip hinge focus. Soft knee. Feel hamstring stretch.',
  ),
  BlockExerciseModel(
    exercise: _nordicCurl,
    exerciseOrder: 1,
    sets: 3,
    reps: '4–6',
    tempo: '4-0-1-0',
    notes: 'Lower slowly. Use band assist if needed in wk 1–2.',
  ),
  BlockExerciseModel(
    exercise: _isoGluteBridge,
    exerciseOrder: 2,
    sets: 3,
    reps: '45s',
    tempo: 'Static',
    notes: 'Drive through heels. Full glute squeeze.',
  ),
  BlockExerciseModel(
    exercise: _pallofPress,
    exerciseOrder: 3,
    sets: 3,
    reps: '10/side',
    tempo: '1-5-1-0',
    notes: '5s isometric hold at extension. Anti-rotation.',
  ),
  BlockExerciseModel(
    exercise: _backExtension45,
    exerciseOrder: 4,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-1',
    notes: 'Bodyweight only in Phase 1. Focus on lumbar control.',
  ),
];

final _wedCooldownExercises = [
  _cooldown('Cat-Cow', '2×15', 0),
  _cooldown('Seated Forward Fold', '2 min', 1),
  _cooldown('Supine Figure-4 Stretch', '90s/side', 2),
  _cooldown('Deep Squat Hold', '2 min', 3),
];

final phase1Wednesday = SessionModel(
  phaseNumber: 1,
  weekDay: 3,
  name: 'Posterior Chain + Breathing Foundation',
  focus: 'Hamstring restoration · RDL introduction · Breathing mechanics · Core stability',
  estimatedMinutes: 75,
  blocks: [
    const BlockModel(
      name: 'WARMUP — 10 MIN',
      blockOrder: 0,
      blockType: BlockType.warmup,
      durationMinutes: 10,
      exercises: _wedWarmupExercises,
    ),
    BlockModel(
      name: 'CONDITIONING BLOCK',
      blockOrder: 1,
      blockType: BlockType.conditioning,
      durationMinutes: 25,
      instructions:
          'Phase 1 — Low Intensity Steady State Only: 20–25 min continuous jump rope or run at 60–65% max HR. Focus on breathing rhythm — nasal in, mouth out. Do not go anaerobic yet.',
      exercises: const [],
    ),
    const BlockModel(
      name: 'POSTERIOR CHAIN BLOCK',
      blockOrder: 2,
      blockType: BlockType.posterior,
      instructions:
          'BREATHING PROTOCOL: Inhale during the eccentric (lowering). Brace and hold at the concentric transition. Exhale at the top. This applies to every rep of every exercise in this block.',
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
// Thursday — Pull, Back Thickness + Grip Foundation
// ---------------------------------------------------------------------------

const _thuWarmupExercises = [
  BlockExerciseModel(
    exercise: _tendonGlides,
    exerciseOrder: 0,
    sets: 1,
    reps: '2 min',
    tempo: 'Slow',
    notes: 'All 5 finger positions — full range',
  ),
  BlockExerciseModel(
    exercise: _bandFingerExtensions,
    exerciseOrder: 1,
    sets: 3,
    reps: '20',
    tempo: 'Controlled',
    notes: 'Counter-balance pulling muscles',
  ),
  BlockExerciseModel(
    exercise: _deadHangPassive,
    exerciseOrder: 2,
    sets: 2,
    reps: '20–30s',
    tempo: 'Relaxed',
    notes: 'Shoulder decompression',
  ),
  BlockExerciseModel(
    exercise: _scapularPullUps,
    exerciseOrder: 3,
    sets: 2,
    reps: '8',
    tempo: 'Controlled',
    notes: 'Scapular depression activation',
  ),
  BlockExerciseModel(
    exercise: _facePullsBand,
    exerciseOrder: 4,
    sets: 2,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'External rotation warm-up',
  ),
];

const _thuMainExercises = [
  BlockExerciseModel(
    exercise: _pullUps,
    exerciseOrder: 0,
    sets: 4,
    reps: '5–7',
    tempo: '2-1-1-0',
    notes: 'Use band if needed. Weak side focus.',
  ),
  BlockExerciseModel(
    exercise: _chestSupportedRow,
    exerciseOrder: 1,
    sets: 4,
    reps: '10',
    tempo: '2-1-X-1',
    notes: 'Bilateral. Squeeze at top 1s.',
  ),
  BlockExerciseModel(
    exercise: _singleArmDBRow,
    exerciseOrder: 2,
    sets: 3,
    reps: '10/arm',
    tempo: '2-1-X-0',
    notes: 'Expose left-right gap. Match on strong side.',
  ),
  BlockExerciseModel(
    exercise: _cablePullover,
    exerciseOrder: 3,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-1',
    notes: 'Lat activation through full ROM',
  ),
  BlockExerciseModel(
    exercise: _facePullsCable,
    exerciseOrder: 4,
    sets: 3,
    reps: '15',
    tempo: '2-1-2-1',
    notes: 'Rear delt + external rotation',
  ),
];

const _thuGripExercises = [
  BlockExerciseModel(
    exercise: _isoDeadHang,
    exerciseOrder: 0,
    sets: 3,
    reps: 'Max time',
    tempo: 'Static',
    notes: 'Goal: 30–60s. Build each week.',
  ),
  BlockExerciseModel(
    exercise: _towelHang,
    exerciseOrder: 1,
    sets: 3,
    reps: '20–30s',
    tempo: 'Static',
    notes: 'Forearm endurance baseline',
  ),
  BlockExerciseModel(
    exercise: _dbPronation,
    exerciseOrder: 2,
    sets: 2,
    reps: '12',
    tempo: '2-0-2-0',
    notes: 'Light DB — wrist stability',
  ),
  BlockExerciseModel(
    exercise: _dbSupination,
    exerciseOrder: 3,
    sets: 2,
    reps: '12',
    tempo: '2-0-2-0',
    notes: 'Supinator + biceps tendon health',
  ),
];

final _thuCooldownExercises = [
  _cooldown('Seated Forward Fold', '2 min', 0),
  _cooldown('Dead Hang (passive)', '2×60s', 1),
  _cooldown('Lat Stretch on Rack', '60s/side', 2),
];

final phase1Thursday = SessionModel(
  phaseNumber: 1,
  weekDay: 4,
  name: 'Pull, Back Thickness + Grip Foundation',
  focus: 'Scapular health · Vertical & horizontal pull · Grip/forearm intro · Wrist prehab',
  estimatedMinutes: 75,
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
      name: 'GRIP & FOREARM BLOCK',
      blockOrder: 2,
      blockType: BlockType.grip,
      exercises: _thuGripExercises,
    ),
    BlockModel(
      name: 'CARDIO FINISHER',
      blockOrder: 3,
      blockType: BlockType.conditioning,
      durationMinutes: 20,
      instructions:
          '20 min steady-state. Lower intensity — this is recovery cardio after a pulling session.',
      exercises: const [],
    ),
    BlockModel(
      name: 'COOLDOWN',
      blockOrder: 4,
      blockType: BlockType.cooldown,
      exercises: _thuCooldownExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Friday — Core, Pelvic Stability + Full Mobility Session
// ---------------------------------------------------------------------------

const _friWarmupExercises = [
  BlockExerciseModel(
    exercise: _bandedClamshell,
    exerciseOrder: 0,
    sets: 3,
    reps: '15/side',
    tempo: '2-1-1-0',
    notes: 'Glute med — hip stability base',
  ),
  BlockExerciseModel(
    exercise: _seatedHipIRER,
    exerciseOrder: 1,
    sets: 2,
    reps: '15 each way',
    tempo: 'Slow',
    notes: 'Hip capsule mobility — kicks & takedowns',
  ),
  BlockExerciseModel(
    exercise: _pubicCrunch,
    exerciseOrder: 2,
    sets: 3,
    reps: '10',
    tempo: '2-1-2-1',
    notes: 'Lower abdominal + pelvic floor integration',
  ),
  BlockExerciseModel(
    exercise: _armCirclesShadow,
    exerciseOrder: 3,
    sets: 1,
    reps: '3 min',
    tempo: 'Fluid',
    notes: 'Light movement — shoulder mobility',
  ),
  BlockExerciseModel(
    exercise: _bandDislocations,
    exerciseOrder: 4,
    sets: 2,
    reps: '15',
    tempo: 'Slow',
    notes: 'Thoracic + shoulder mobility',
  ),
];

const _friMainExercises = [
  BlockExerciseModel(
    exercise: _cossackSquatFri,
    exerciseOrder: 0,
    sets: 3,
    reps: '8/side',
    tempo: '3-2-1-0',
    notes: 'Deep hip mobility. Heel down if possible.',
  ),
  BlockExerciseModel(
    exercise: _singleArmDBOHP,
    exerciseOrder: 1,
    sets: 3,
    reps: '10/arm',
    tempo: '2-1-1-1',
    notes: 'Unilateral — expose shoulder asymmetry',
  ),
  BlockExerciseModel(
    exercise: _dbHammerCurls,
    exerciseOrder: 2,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-0',
    notes: 'Brachialis + elbow tendon health',
  ),
  BlockExerciseModel(
    exercise: _overheadCableTriceps,
    exerciseOrder: 3,
    sets: 3,
    reps: '12',
    tempo: '2-1-2-1',
    notes: 'Long head stretch — elbow tendon integrity',
  ),
];

const _friCoreExercises = [
  BlockExerciseModel(
    exercise: _pallofPressFri,
    exerciseOrder: 0,
    sets: 3,
    reps: '10/side',
    tempo: '1-5-1-0',
    notes: '5s hold at extension. Breathe through it.',
  ),
  BlockExerciseModel(
    exercise: _cableWoodyFri,
    exerciseOrder: 1,
    sets: 3,
    reps: '10/side',
    tempo: '2-1-2-1',
    notes: 'Light load. Hip rotation motor pattern.',
  ),
  BlockExerciseModel(
    exercise: _pufferFish,
    exerciseOrder: 2,
    sets: 3,
    reps: '30s',
    tempo: 'Static',
    notes: 'Expand in all directions. No breath-holding.',
  ),
  BlockExerciseModel(
    exercise: _abWheel,
    exerciseOrder: 3,
    sets: 3,
    reps: '8–10',
    tempo: '3-1-X-0',
    notes: 'From knees if needed. Hips do not sag.',
  ),
  BlockExerciseModel(
    exercise: _hangingKneeRaise,
    exerciseOrder: 4,
    sets: 3,
    reps: '12',
    tempo: '2-1-1-0',
    notes: 'Controlled. No swing.',
  ),
];

final _friMobilityExercises = [
  _cooldown('Pigeon Pose', '2 min/side', 0),
  _cooldown('90-90 Hip Stretch', '2 min/side', 1),
  _cooldown('Couch Stretch', '90s/side', 2),
  _cooldown('Thoracic Foam Roll', '3 min', 3),
  _cooldown('Doorway Chest Stretch', '60s/side', 4),
  _cooldown('Lat Stretch on Rack', '60s/side', 5),
  _cooldown('Supine Spinal Twist', '60s/side', 6),
];

final phase1Friday = SessionModel(
  phaseNumber: 1,
  weekDay: 5,
  name: 'Core, Pelvic Stability + Full Mobility Session',
  focus: 'Hip capsule work · Anti-rotation core · Pelvic floor · Flexibility restoration',
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
      name: 'CORE & PELVIC FLOOR BLOCK',
      blockOrder: 2,
      blockType: BlockType.core,
      exercises: _friCoreExercises,
    ),
    BlockModel(
      name: 'EXTENDED MOBILITY SESSION — 20 MIN',
      blockOrder: 3,
      blockType: BlockType.cooldown,
      durationMinutes: 20,
      exercises: _friMobilityExercises,
    ),
  ],
);

// ---------------------------------------------------------------------------
// Phase 1 — top-level definition
// ---------------------------------------------------------------------------

const phase1 = PhaseModel(
  number: 1,
  name: 'Foundation',
  subtitle: 'Rebuild Movement, Gut & Engine',
  weeksStart: 1,
  weeksEnd: 6,
  intensityMin: 0.60,
  intensityMax: 0.70,
  deloadWeeks: [4],
  overviewText:
      'Your body has been in irregular stress for 2–3 months. Joints are stiff, cardio is near zero, '
      'and the left shoulder requires careful management. Phase 1 is not about performance — it is about '
      're-establishing movement quality, mobilising the hips and thoracic spine, and building the aerobic '
      'base through low-to-moderate intensity work. Unilateral exercises dominate every session to begin '
      'closing the left-right strength gap. Sessions run 70–90 minutes.',
);

/// All 5 sessions for Phase 1 (Mon–Fri). Same sessions repeat for weeks 1–6
/// (deload modifier is applied at runtime by WeekCalculator, not here).
final phase1Sessions = [
  phase1Monday,
  phase1Tuesday,
  phase1Wednesday,
  phase1Thursday,
  phase1Friday,
];
