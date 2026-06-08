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

/// Completion-anchored scheduling.
///
/// The program week (1–24) advances only when the user completes a week with
/// at most one missed weekday. Two missed weekdays in a week fail it, and the
/// week is redone the following Monday. The calendar decides *which* weekday's
/// session you do; completion decides *whether the week number moves*.
///
/// This file holds the pure date helpers + miss math (used by the read-side
/// home provider) and [reconcileSchedule] (the write-side rollover that runs at
/// app startup and on resume).
library;

import '../database/database.dart';
import 'phase_math.dart';

/// Strip the time component.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// The Monday (date-only) of the week containing [d].
DateTime mondayOf(DateTime d) {
  final o = dateOnly(d);
  return o.subtract(Duration(days: o.weekday - 1));
}

/// Count missed weekdays (Mon–Fri) in the current week attempt.
///
/// [anchor] is the day the attempt began (a Monday, or the install day for a
/// brand-new user's Week 1). [completedDates] are the day-only dates on which a
/// session was completed for the current week. [cutoff] is exclusive: only
/// weekdays strictly before it are eligible to be "missed" — so today is never
/// counted as a miss (you still have today to train).
int missedWeekdays({
  required DateTime anchor,
  required Set<DateTime> completedDates,
  required DateTime cutoff,
}) {
  final start = dateOnly(anchor);
  final friday = mondayOf(start).add(const Duration(days: 4));
  final cutoffDay = dateOnly(cutoff);
  var misses = 0;
  for (var d = start; !d.isAfter(friday); d = d.add(const Duration(days: 1))) {
    if (d.weekday > 5) continue; // skip Sat/Sun
    if (!d.isBefore(cutoffDay)) continue; // only fully-elapsed weekdays
    if (!completedDates.contains(d)) misses++;
  }
  return misses;
}

/// Apply any pending week rollover (advance on success / reset on failure).
///
/// Idempotent and side-effecting: safe to call on every app launch and resume.
/// Does nothing unless a new Monday has passed since the current attempt's
/// anchor. One call resolves one transition, which is sufficient because the
/// week number never advances on failure — a long absence simply keeps the
/// current week parked until the user completes it.
Future<void> reconcileSchedule(AppDatabase db) async {
  final st = await db.userDao.getUserState();
  if (st == null || st.programComplete) return;

  final anchor = st.weekAnchorDate ?? st.programStartDate;
  final anchorMonday = mondayOf(anchor);
  final thisMonday = mondayOf(DateTime.now());

  // Still inside the current attempt's week (including its weekend) → nothing
  // to settle yet.
  if (!thisMonday.isAfter(anchorMonday)) return;

  // The attempt week is over — evaluate it.
  final logs = await db.sessionDao.getLogsForWeek(st.currentWeek);
  final completed = logs.where((l) => l.completed).toList();
  final completedDates = completed.map((l) => dateOnly(l.date)).toSet();
  final completedSessions = completed.map((l) => l.sessionId).toSet().length;

  final misses = missedWeekdays(
    anchor: anchor,
    completedDates: completedDates,
    cutoff: thisMonday, // whole attempt week has elapsed
  );

  final succeeded = misses <= 1 && completedSessions >= 1;

  if (succeeded) {
    final next = st.currentWeek + 1;
    if (next > kProgramWeeks) {
      await db.userDao.updateScheduleState(
        programComplete: true,
        weekAnchorDate: thisMonday,
      );
    } else {
      await db.userDao.updateScheduleState(
        currentWeek: next,
        weekAnchorDate: thisMonday,
      );
    }
  } else {
    // Failed (or no work done): clear this week's logs so the redo is clean.
    // Bodyweight entries are intentionally kept.
    await db.sessionDao.deleteLogsForWeek(st.currentWeek);
    await db.userDao.updateScheduleState(weekAnchorDate: thisMonday);
  }
}
