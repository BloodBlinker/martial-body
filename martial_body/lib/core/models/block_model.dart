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

import 'exercise_model.dart';

/// Type of block within a session.
enum BlockType {
  warmup,
  main,
  tendon,
  conditioning,
  grip,
  core,
  posterior,
  finishing,
  cooldown,
}

/// A named block within a session (e.g. "WARMUP — 12 MIN", "MAIN BLOCK").
class BlockModel {
  final String name;
  final int blockOrder; // 0-based
  final BlockType blockType;
  final String? instructions; // special protocol text (interval details, breathing notes, etc.)
  final int? durationMinutes;
  final List<BlockExerciseModel> exercises;

  const BlockModel({
    required this.name,
    required this.blockOrder,
    required this.blockType,
    this.instructions,
    this.durationMinutes,
    required this.exercises,
  });
}
