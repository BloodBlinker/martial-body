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

import 'package:drift/drift.dart';
import 'blocks.dart';
import 'exercises.dart';

class BlockExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get exerciseOrder => integer()();
  IntColumn get sets => integer().nullable()();
  TextColumn get reps => text().nullable()(); // "12", "8/leg", "30–45s", "Max time"
  TextColumn get tempo => text().nullable()(); // "3-1-1-0", "Static", "Controlled"
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isNew => boolean().withDefault(const Constant(false))();
}
