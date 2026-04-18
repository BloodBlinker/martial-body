import '../database/database.dart';

class HomeViewModel {
  final int weekNumber;
  final int phaseNumber;
  final bool isDeload;
  final Session? todaySession;
  final List<Session> allPhaseSessions;
  final Set<int> completedSessionIds; // session IDs logged (any status) this week
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

  String get phaseName {
    switch (phaseNumber) {
      case 1:
        return 'Foundation';
      case 2:
        return 'Build';
      case 3:
        return 'Peak';
      case 4:
        return 'Fight Prep';
      default:
        return 'Phase $phaseNumber';
    }
  }

  bool isSessionDone(int sessionId) => completedSessionIds.contains(sessionId);
}
