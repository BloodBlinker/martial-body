import '../database/database.dart';
import 'session_detail.dart';

class ActiveSessionState {
  final int workoutLogId;
  final SessionDetail sessionDetail;
  final List<BlockExerciseDetail> allExercises;
  final int currentExerciseIndex;
  final Map<String, bool> setsDone;
  final Map<String, String> weightDrafts;
  final Map<String, String> repsDrafts;

  /// Last prior completed SetLog per exerciseId. Used to render the
  /// "Last: 60kg × 8" hint on set rows so the user can easily repeat or
  /// progressively overload.
  final Map<int, SetLog> lastByExerciseId;

  const ActiveSessionState({
    required this.workoutLogId,
    required this.sessionDetail,
    required this.allExercises,
    required this.currentExerciseIndex,
    this.setsDone = const {},
    this.weightDrafts = const {},
    this.repsDrafts = const {},
    this.lastByExerciseId = const {},
  });

  static String key(int beId, int setNum) => '${beId}_$setNum';

  bool isDone(int beId, int setNum) => setsDone[key(beId, setNum)] ?? false;
  String weightFor(int beId, int setNum) => weightDrafts[key(beId, setNum)] ?? '';
  String repsFor(int beId, int setNum) => repsDrafts[key(beId, setNum)] ?? '';

  BlockExerciseDetail get currentExercise => allExercises[currentExerciseIndex];

  int get currentBlockIndex {
    int idx = 0;
    for (int bi = 0; bi < sessionDetail.blocks.length; bi++) {
      for (int ei = 0; ei < sessionDetail.blocks[bi].exercises.length; ei++) {
        if (idx == currentExerciseIndex) return bi;
        idx++;
      }
    }
    return 0;
  }

  int completedSetsFor(int beId, int totalSets) {
    int count = 0;
    for (int i = 1; i <= totalSets; i++) {
      if (isDone(beId, i)) count++;
    }
    return count;
  }

  ActiveSessionState copyWith({
    int? currentExerciseIndex,
    Map<String, bool>? setsDone,
    Map<String, String>? weightDrafts,
    Map<String, String>? repsDrafts,
    Map<int, SetLog>? lastByExerciseId,
  }) {
    return ActiveSessionState(
      workoutLogId: workoutLogId,
      sessionDetail: sessionDetail,
      allExercises: allExercises,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      setsDone: setsDone ?? this.setsDone,
      weightDrafts: weightDrafts ?? this.weightDrafts,
      repsDrafts: repsDrafts ?? this.repsDrafts,
      lastByExerciseId: lastByExerciseId ?? this.lastByExerciseId,
    );
  }
}
