import 'block_model.dart';

/// One training day within a phase (e.g. Phase 1 Monday).
/// weekDay follows DateTime.weekday convention: 1=Mon … 5=Fri.
class SessionModel {
  final int phaseNumber; // 1–4
  final int weekDay; // 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri
  final String name; // "Lower Body Mobility + Unilateral Strength"
  final String focus; // "Hip restoration · VMO activation · …"
  final int estimatedMinutes;
  final List<BlockModel> blocks;

  const SessionModel({
    required this.phaseNumber,
    required this.weekDay,
    required this.name,
    required this.focus,
    required this.estimatedMinutes,
    required this.blocks,
  });
}
