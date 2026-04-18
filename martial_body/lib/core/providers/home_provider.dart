import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_view_model.dart';
import '../program/phase_math.dart';
import 'database_provider.dart';

/// Stream-backed so the Home screen updates the moment a workout is completed
/// or the user state changes — no manual invalidation needed on navigation.
final homeProvider = StreamProvider<HomeViewModel>((ref) {
  final db = ref.watch(databaseProvider);

  return db.sessionDao.watchAllLogs().asyncMap((allLogs) async {
    final userState = await db.userDao.getUserState();
    // Guaranteed non-null after main.dart initialisation.
    final programStartDate = userState?.programStartDate ?? DateTime.now();

    final now = DateTime.now();
    final weekNumber = computeWeekNumber(programStartDate, now);
    final phase = phaseForWeek(weekNumber);
    final isDeload = phase.deloadWeeks.contains(weekNumber);

    final allPhaseSessions =
        await db.programDao.getSessionsForPhase(phase.number);

    // Today's session — Mon–Fri (weekday 1–5) only
    final todayWeekday = now.weekday;
    final todaySession = (todayWeekday >= 1 && todayWeekday <= 5)
        ? await db.programDao.getSessionForDay(phase.number, todayWeekday)
        : null;

    final weekLogs = allLogs.where((l) => l.weekNumber == weekNumber).toList();
    final completedSessionIds = weekLogs
        .where((l) => l.completed)
        .map((l) => l.sessionId)
        .toSet();
    final completedThisWeek = completedSessionIds.length;

    final totalCompletedSessions = allLogs.where((l) => l.completed).length;

    return HomeViewModel(
      weekNumber: weekNumber,
      phaseNumber: phase.number,
      isDeload: isDeload,
      todaySession: todaySession,
      allPhaseSessions: allPhaseSessions,
      completedSessionIds: completedSessionIds,
      completedThisWeek: completedThisWeek,
      totalCompletedSessions: totalCompletedSessions,
      programStartDate: programStartDate,
    );
  });
});
