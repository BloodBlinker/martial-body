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
  });

  bool get isRestDay => todaySession == null;

  // Delegates to phase_math so Home, Program, and Progress never disagree
  // on a phase's canonical name.
  String get phaseName => phaseForWeek(weekNumber).name;

  bool isSessionDone(int sessionId) => completedSessionIds.contains(sessionId);
}
