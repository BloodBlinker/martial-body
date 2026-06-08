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

import 'package:flutter/material.dart';

enum AchievementId {
  firstStep,
  firstWeek,
  tenSessions,
  foundation, // Phase 1 complete
  halfway,
  combatReady, // Phase 3 complete
  fiftySessions,
  recordBreaker,
  graduate,
}

/// The signals an achievement can unlock against. Pure data so unlock logic is
/// testable without a database.
class AchievementCriteria {
  final int weeksCompleted; // 0..24
  final int totalSessions;
  final bool programComplete;
  final bool hasPersonalRecord;

  const AchievementCriteria({
    required this.weeksCompleted,
    required this.totalSessions,
    required this.programComplete,
    required this.hasPersonalRecord,
  });
}

class Achievement {
  final AchievementId id;
  final String title;
  final String description;
  final IconData icon;
  final bool Function(AchievementCriteria c) _unlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required bool Function(AchievementCriteria c) unlocked,
  }) : _unlocked = unlocked;

  bool unlockedBy(AchievementCriteria c) => _unlocked(c);
}

/// The full achievement catalogue, ordered roughly by how soon they unlock.
final List<Achievement> kAchievements = [
  Achievement(
    id: AchievementId.firstStep,
    title: 'First Step',
    description: 'Complete your first session.',
    icon: Icons.flag_outlined,
    unlocked: (c) => c.totalSessions >= 1,
  ),
  Achievement(
    id: AchievementId.firstWeek,
    title: 'Week One Down',
    description: 'Finish your first full week.',
    icon: Icons.event_available_outlined,
    unlocked: (c) => c.weeksCompleted >= 1,
  ),
  Achievement(
    id: AchievementId.tenSessions,
    title: 'Disciplined',
    description: 'Log 10 sessions.',
    icon: Icons.bolt_outlined,
    unlocked: (c) => c.totalSessions >= 10,
  ),
  Achievement(
    id: AchievementId.recordBreaker,
    title: 'Record Breaker',
    description: 'Set your first personal record.',
    icon: Icons.emoji_events_outlined,
    unlocked: (c) => c.hasPersonalRecord,
  ),
  Achievement(
    id: AchievementId.foundation,
    title: 'Foundation Forged',
    description: 'Complete Phase 1.',
    icon: Icons.foundation_outlined,
    unlocked: (c) => c.weeksCompleted >= 6,
  ),
  Achievement(
    id: AchievementId.halfway,
    title: 'Halfway There',
    description: 'Reach the midpoint of the program.',
    icon: Icons.timeline_outlined,
    unlocked: (c) => c.weeksCompleted >= 12,
  ),
  Achievement(
    id: AchievementId.fiftySessions,
    title: 'Relentless',
    description: 'Log 50 sessions.',
    icon: Icons.local_fire_department_outlined,
    unlocked: (c) => c.totalSessions >= 50,
  ),
  Achievement(
    id: AchievementId.combatReady,
    title: 'Combat Ready',
    description: 'Complete Phase 3.',
    icon: Icons.sports_mma_outlined,
    unlocked: (c) => c.weeksCompleted >= 20,
  ),
  Achievement(
    id: AchievementId.graduate,
    title: 'Fight Ready',
    description: 'Complete all 24 weeks.',
    icon: Icons.military_tech_outlined,
    unlocked: (c) => c.programComplete,
  ),
];

/// The set of achievement ids unlocked by [c].
Set<AchievementId> unlockedAchievements(AchievementCriteria c) =>
    {for (final a in kAchievements) if (a.unlockedBy(c)) a.id};
