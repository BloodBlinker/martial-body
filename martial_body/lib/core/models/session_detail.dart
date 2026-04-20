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

class BlockExerciseDetail {
  final BlockExercise blockExercise;
  final Exercise exercise;

  const BlockExerciseDetail({
    required this.blockExercise,
    required this.exercise,
  });
}

class BlockDetail {
  final Block block;
  final List<BlockExerciseDetail> exercises;

  const BlockDetail({
    required this.block,
    required this.exercises,
  });
}

class SessionDetail {
  final Session session;
  final Phase phase;
  final List<BlockDetail> blocks;

  const SessionDetail({
    required this.session,
    required this.phase,
    required this.blocks,
  });
}
