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
