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

import 'package:flutter_test/flutter_test.dart';
import 'package:martial_body/core/providers/active_session_provider.dart';

/// Regression tests for the P0 data-corruption bug where
/// `weight.toString().replaceAll('.0', '')` stripped '.0' substrings anywhere
/// in the string, turning 50.0 → "5" and 100.0 → "10".
void main() {
  group('ActiveSessionNotifier.formatWeight', () {
    test('whole numbers render without trailing zero', () {
      expect(ActiveSessionNotifier.formatWeight(50), '50');
      expect(ActiveSessionNotifier.formatWeight(100), '100');
      expect(ActiveSessionNotifier.formatWeight(0), '0');
    });

    test('decimals keep one fractional digit', () {
      expect(ActiveSessionNotifier.formatWeight(10.5), '10.5');
      expect(ActiveSessionNotifier.formatWeight(42.5), '42.5');
    });

    test('regression: values containing ".0" as a substring survive', () {
      // Under the buggy replaceAll implementation, 10.0 → "1", 100.0 → "10".
      expect(ActiveSessionNotifier.formatWeight(10), '10');
      expect(ActiveSessionNotifier.formatWeight(100), '100');
      expect(ActiveSessionNotifier.formatWeight(1000), '1000');
    });
  });
}
