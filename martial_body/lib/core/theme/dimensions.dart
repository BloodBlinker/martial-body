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

import 'package:flutter/widgets.dart';

/// The single corner-radius scale for the app. New/updated UI should use these
/// instead of ad-hoc literals so shapes stay consistent.
///
/// - [chip]   8  — pills, small tags, inputs
/// - [card]  16  — the standard card / surface radius
/// - [sheet] 24  — bottom sheets, large hero containers
class AppRadius {
  static const double chip = 8;
  static const double card = 16;
  static const double sheet = 24;

  static const BorderRadius chipR = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius cardR = BorderRadius.all(Radius.circular(card));
  static const BorderRadius sheetR = BorderRadius.all(Radius.circular(sheet));
}

/// The single spacing scale (4-pt rhythm). Use for gaps and padding so the
/// vertical rhythm is consistent across screens.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}
