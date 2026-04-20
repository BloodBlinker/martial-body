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

/// Represents one of the 4 training phases in the 24-week program.
class PhaseModel {
  final int number; // 1–4
  final String name; // "Foundation"
  final String subtitle; // "Rebuild Movement, Gut & Engine"
  final int weeksStart; // 1
  final int weeksEnd; // 6
  final double intensityMin; // 0.60
  final double intensityMax; // 0.70
  final List<int> deloadWeeks; // [4]
  final String overviewText;

  const PhaseModel({
    required this.number,
    required this.name,
    required this.subtitle,
    required this.weeksStart,
    required this.weeksEnd,
    required this.intensityMin,
    required this.intensityMax,
    required this.deloadWeeks,
    required this.overviewText,
  });
}
