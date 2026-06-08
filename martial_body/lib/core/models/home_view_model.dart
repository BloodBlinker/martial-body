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
import '../program/phase_math.dart';

class HomeViewModel {
  final int weekNumber;
  final int phaseNumber;
  final bool isDeload;
  final Session? todaySession;
  final List<Session> allPhaseSessions;
  final Set<int> completedSessionIds; // session IDs with a completed log this week
  final int completedThisWeek;
  final int totalCompletedSessions;
  final DateTime programStartDate;
  /// Sessions scheduled per week in the current phase (5 for phases 1–3, 4 for
  /// phase 4). Denominator for the "X of N this week" counters.
  final int sessionsPerWeek;

  /// Missed weekdays so far in the current week attempt (0, 1, or 2+).
  final int missCount;

  /// True once the user has finished all 24 weeks.
  final bool programComplete;
  /// Most-recent incomplete workout log per session ID (all time, not just today).
  /// Used to surface RESUME / QUIT for any session that was left mid-workout.
  final Map<int, WorkoutLog> inProgressLogBySessionId;

  const HomeViewModel({
    required this.weekNumber,
    required this.phaseNumber,
    required this.isDeload,
    required this.todaySession,
    required this.allPhaseSessions,
    required this.completedSessionIds,
    required this.completedThisWeek,
    required this.totalCompletedSessions,
    required this.programStartDate,
    required this.sessionsPerWeek,
    required this.missCount,
    required this.programComplete,
    this.inProgressLogBySessionId = const {},
  });

  /// Convenience getter — the in-progress log for today's session (if any).
  WorkoutLog? get inProgressTodayLog =>
      todaySession != null ? inProgressLogBySessionId[todaySession!.id] : null;

  bool get isRestDay => todaySession == null;

  /// True once the user has finished all 24 weeks — Home switches to the
  /// completion state instead of showing more weeks.
  bool get isProgramComplete => programComplete;

  /// The current week has failed (2+ missed weekdays) and will reset Monday.
  /// The user may still train, but sessions no longer count.
  bool get weekFailed => missCount >= 2;

  /// Week number to display, never exceeding the programme length.
  int get displayWeek => weekNumber > kProgramWeeks ? kProgramWeeks : weekNumber;

  // Delegates to phase_math so Home, Program, and Progress never disagree
  // on a phase's canonical name.
  String get phaseName => phaseForWeek(weekNumber).name;

  bool isSessionDone(int sessionId) => completedSessionIds.contains(sessionId);
}
