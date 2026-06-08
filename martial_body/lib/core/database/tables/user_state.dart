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

// @DataClassName avoids a naming conflict between the table class and
// the generated data class (both would otherwise be called "UserState").
@DataClassName('UserStateRow')
class UserStateTable extends Table {
  @override
  String get tableName => 'user_state';

  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get programStartDate => dateTime()();
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();

  // ── Completion-anchored scheduling (v1.5.4) ──
  // The program week (1–24) advances only when a week is completed, not by the
  // calendar. `weekAnchorDate` is the date the current week's attempt began (a
  // Monday, except a brand-new user's Week 1 which anchors to install day).
  IntColumn get currentWeek => integer().withDefault(const Constant(1))();
  DateTimeColumn get weekAnchorDate => dateTime().nullable()();
  BoolColumn get programComplete =>
      boolean().withDefault(const Constant(false))();
}
