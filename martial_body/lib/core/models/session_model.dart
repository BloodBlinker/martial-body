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

import 'block_model.dart';

/// One training day within a phase (e.g. Phase 1 Monday).
/// weekDay follows DateTime.weekday convention: 1=Mon … 5=Fri.
class SessionModel {
  final int phaseNumber; // 1–4
  final int weekDay; // 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri
  final String name; // "Lower Body Mobility + Unilateral Strength"
  final String focus; // "Hip restoration · VMO activation · …"
  final int estimatedMinutes;
  final List<BlockModel> blocks;

  const SessionModel({
    required this.phaseNumber,
    required this.weekDay,
    required this.name,
    required this.focus,
    required this.estimatedMinutes,
    required this.blocks,
  });
}
