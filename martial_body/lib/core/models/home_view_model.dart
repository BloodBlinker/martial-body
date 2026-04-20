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
