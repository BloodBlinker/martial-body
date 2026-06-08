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
import 'package:shared_preferences/shared_preferences.dart';

enum UnitSystem { metric, imperial }

/// App-wide measurement unit preference. Storage stays metric (kg/cm); this
/// only affects how weight/height/volume are displayed and entered.
final unitSystemProvider =
    StateNotifierProvider<UnitSystemNotifier, UnitSystem>((ref) {
  return UnitSystemNotifier();
});

class UnitSystemNotifier extends StateNotifier<UnitSystem> {
  static const _key = 'unitSystem';

  UnitSystemNotifier() : super(UnitSystem.metric) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) == 'imperial'
        ? UnitSystem.imperial
        : UnitSystem.metric;
  }

  Future<void> set(UnitSystem system) async {
    state = system;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, system == UnitSystem.imperial ? 'imperial' : 'metric');
  }

  void toggle() =>
      set(state == UnitSystem.metric ? UnitSystem.imperial : UnitSystem.metric);
}
