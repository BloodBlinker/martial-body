import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds — near-black with subtle depth
  static const Color background = Color(0xFF080808);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color divider = Color(0xFF252525);

  // Primary accent — rich gold
  static const Color gold = Color(0xFFD4A843);

  // Phase colors
  static const Color phase1 = Color(0xFFD4A843); // gold — Foundation
  static const Color phase2 = Color(0xFFE07A3C); // warm orange — Engine Build
  static const Color phase3 = Color(0xFFD44C4C); // deep red — Full Combat
  static const Color phase4 = Color(0xFF4A8FCC); // steel blue — MMA Transition
  static const Color deload = Color(0xFFD49A38); // amber-gold — deload weeks

  // Muted variants (15% alpha, pre-baked)
  static const Color phase1Muted = Color(0x26D4A843);
  static const Color phase2Muted = Color(0x26E07A3C);
  static const Color phase3Muted = Color(0x26D44C4C);
  static const Color phase4Muted = Color(0x264A8FCC);
  static const Color deloadMuted = Color(0x26D49A38);

  // Text — warm-tinted for premium feel against black
  static const Color textPrimary = Color(0xFFF2ECD8);
  static const Color textSecondary = Color(0xFF7A6E5E);

  // Utility
  static const Color error = Color(0xFFD44C4C);

  static Color phaseColor(int phase) {
    switch (phase) {
      case 1:
        return phase1;
      case 2:
        return phase2;
      case 3:
        return phase3;
      case 4:
        return phase4;
      default:
        return phase1;
    }
  }

  static Color phaseMutedColor(int phase) {
    switch (phase) {
      case 1:
        return phase1Muted;
      case 2:
        return phase2Muted;
      case 3:
        return phase3Muted;
      case 4:
        return phase4Muted;
      default:
        return phase1Muted;
    }
  }
}
