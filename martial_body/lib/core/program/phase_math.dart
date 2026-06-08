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

/// Single source of truth for phase / week / deload boundaries.
///
/// The 24-week programme is 6 + 6 + 8 + 4 weeks, not 4×6. Home, Program, and
/// active-session logic all derive from these constants so they agree.
class PhaseInfo {
  final int number;
  final String name;
  final int startWeek; // inclusive
  final int endWeek; // inclusive
  final Set<int> deloadWeeks; // absolute week numbers

  /// Training sessions scheduled per week in this phase. Phases 1–3 run a
  /// 5-day Mon–Fri split; Phase 4 tapers to 4 days (no Thursday). Used as the
  /// denominator for weekly-progress counters so Home, Program, and Progress
  /// never assume a fixed "5".
  final int sessionsPerWeek;

  const PhaseInfo({
    required this.number,
    required this.name,
    required this.startWeek,
    required this.endWeek,
    required this.deloadWeeks,
    this.sessionsPerWeek = 5,
  });

  int get lengthWeeks => endWeek - startWeek + 1;
}

const kPhases = <PhaseInfo>[
  PhaseInfo(
    number: 1,
    name: 'Foundation',
    startWeek: 1,
    endWeek: 6,
    deloadWeeks: {4},
  ),
  PhaseInfo(
    number: 2,
    name: 'Engine Build',
    startWeek: 7,
    endWeek: 12,
    deloadWeeks: {10},
  ),
  PhaseInfo(
    number: 3,
    name: 'Full Combat',
    startWeek: 13,
    endWeek: 20,
    deloadWeeks: {16, 20},
  ),
  PhaseInfo(
    number: 4,
    name: 'MMA Transition',
    startWeek: 21,
    endWeek: 24,
    deloadWeeks: {},
    sessionsPerWeek: 4,
  ),
];

const int kProgramWeeks = 24;

/// Week number relative to programme start. Always >= 1. Not clamped to 24
/// at the high end so the caller can detect "programme complete".
int computeWeekNumber(DateTime programStart, DateTime now) {
  final daysDiff = now.difference(programStart).inDays;
  final week = (daysDiff ~/ 7) + 1;
  return week < 1 ? 1 : week;
}

/// Phase containing [weekNumber]. Returns the last phase when the programme
/// has ended, matching the Home behaviour of keeping the UI stable.
PhaseInfo phaseForWeek(int weekNumber) {
  for (final p in kPhases) {
    if (weekNumber >= p.startWeek && weekNumber <= p.endWeek) return p;
  }
  return weekNumber < kPhases.first.startWeek ? kPhases.first : kPhases.last;
}

bool isDeloadWeek(int weekNumber) =>
    phaseForWeek(weekNumber).deloadWeeks.contains(weekNumber);

int phaseNumberForWeek(int weekNumber) => phaseForWeek(weekNumber).number;
