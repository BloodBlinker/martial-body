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
  final Map<String, String> rightRepsDrafts;

  /// Last prior completed SetLog per exerciseId.
  final Map<int, SetLog> lastByExerciseId;

  /// The real start time of this workout (from the DB). Used to anchor the
  /// session timer so it survives resume / screen re-creation.
  final DateTime sessionStartedAt;

  const ActiveSessionState({
    required this.workoutLogId,
    required this.sessionDetail,
    required this.allExercises,
    required this.currentExerciseIndex,
    required this.sessionStartedAt,
    this.setsDone = const {},
    this.weightDrafts = const {},
    this.repsDrafts = const {},
    this.rightRepsDrafts = const {},
    this.lastByExerciseId = const {},
  });

  static String key(int beId, int setNum) => '${beId}_$setNum';

  bool isDone(int beId, int setNum) => setsDone[key(beId, setNum)] ?? false;
  String weightFor(int beId, int setNum) => weightDrafts[key(beId, setNum)] ?? '';
  String repsFor(int beId, int setNum) => repsDrafts[key(beId, setNum)] ?? '';
  String rightRepsFor(int beId, int setNum) => rightRepsDrafts[key(beId, setNum)] ?? '';

  BlockExerciseDetail get currentExercise => allExercises[currentExerciseIndex];

  /// Look up the block index by matching blockExercise.blockId — works for
  /// both real and synthetic (cardio placeholder) entries.
  int get currentBlockIndex {
    final targetBlockId = allExercises[currentExerciseIndex].blockExercise.blockId;
    for (int bi = 0; bi < sessionDetail.blocks.length; bi++) {
      if (sessionDetail.blocks[bi].block.id == targetBlockId) return bi;
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
    Map<String, String>? rightRepsDrafts,
    Map<int, SetLog>? lastByExerciseId,
  }) {
    return ActiveSessionState(
      workoutLogId: workoutLogId,
      sessionDetail: sessionDetail,
      allExercises: allExercises,
      sessionStartedAt: sessionStartedAt,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      setsDone: setsDone ?? this.setsDone,
      weightDrafts: weightDrafts ?? this.weightDrafts,
      repsDrafts: repsDrafts ?? this.repsDrafts,
      rightRepsDrafts: rightRepsDrafts ?? this.rightRepsDrafts,
      lastByExerciseId: lastByExerciseId ?? this.lastByExerciseId,
    );
  }
}
