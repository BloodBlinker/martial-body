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

import '../providers/units_provider.dart';

/// Pure conversion + formatting helpers. Canonical storage is always metric
/// (kg / cm); these convert to/from the user's chosen display unit.
class Units {
  static const double _kgPerLb = 0.45359237;

  static double kgToLb(double kg) => kg / _kgPerLb;
  static double lbToKg(double lb) => lb * _kgPerLb;
  static double cmToIn(double cm) => cm / 2.54;
  static double inToCm(double inches) => inches * 2.54;

  static String weightUnit(UnitSystem u) =>
      u == UnitSystem.imperial ? 'lb' : 'kg';

  /// Drop a trailing ".0" so whole numbers render cleanly.
  static String _trim(double v) =>
      v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);

  /// A stored kg value as a bare number string in the display unit (for input
  /// fields / the number pad). e.g. 60 kg → "132.3" in imperial.
  static String weightValue(double kg, UnitSystem u) =>
      _trim(u == UnitSystem.imperial ? kgToLb(kg) : kg);

  /// A stored kg value formatted with its unit, e.g. "60 kg" / "132.3 lb".
  static String weight(double kg, UnitSystem u) =>
      '${weightValue(kg, u)} ${weightUnit(u)}';

  /// Convert a number the user typed (in their display unit) back to kg.
  static double toKg(double displayValue, UnitSystem u) =>
      u == UnitSystem.imperial ? lbToKg(displayValue) : displayValue;

  /// Convert a kg value to the display unit's numeric value (no rounding to
  /// string) — used to seed input controllers.
  static double toDisplay(double kg, UnitSystem u) =>
      u == UnitSystem.imperial ? kgToLb(kg) : kg;

  /// A stored cm value formatted as height, e.g. "180 cm" / "5 ft 11 in".
  static String height(double cm, UnitSystem u) {
    if (u != UnitSystem.imperial) return '${_trim(cm)} cm';
    final totalInches = cmToIn(cm).round();
    final ft = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$ft ft $inches in';
  }

  /// A volume (kg) formatted with thousands abbreviation, in the display unit.
  static String volume(double kg, UnitSystem u) {
    final v = u == UnitSystem.imperial ? kgToLb(kg) : kg;
    final unit = weightUnit(u);
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k $unit';
    return '${v.round()} $unit';
  }
}
