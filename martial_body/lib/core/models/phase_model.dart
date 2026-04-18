/// Represents one of the 4 training phases in the 24-week program.
class PhaseModel {
  final int number; // 1–4
  final String name; // "Foundation"
  final String subtitle; // "Rebuild Movement, Gut & Engine"
  final int weeksStart; // 1
  final int weeksEnd; // 6
  final double intensityMin; // 0.60
  final double intensityMax; // 0.70
  final List<int> deloadWeeks; // [4]
  final String overviewText;

  const PhaseModel({
    required this.number,
    required this.name,
    required this.subtitle,
    required this.weeksStart,
    required this.weeksEnd,
    required this.intensityMin,
    required this.intensityMax,
    required this.deloadWeeks,
    required this.overviewText,
  });
}
