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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_detail.dart';
import 'database_provider.dart';

final sessionDetailProvider = FutureProvider.family<SessionDetail, int>((ref, sessionId) async {
  final db = ref.watch(databaseProvider);

  final session = await db.programDao.getSessionById(sessionId);
  if (session == null) throw StateError('Session $sessionId not found');

  final phase = await db.programDao.getPhaseById(session.phaseId);
  if (phase == null) throw StateError('Phase ${session.phaseId} not found');

  final blocks = await db.programDao.getBlocksForSession(sessionId);
  final blockDetails = await Future.wait(
    blocks.map((b) async {
      final exercises = await db.programDao.getBlockExercisesWithExercise(b.id);
      return BlockDetail(block: b, exercises: exercises);
    }),
  );

  return SessionDetail(session: session, phase: phase, blocks: blockDetails);
});
