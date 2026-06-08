import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/units_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/units.dart';

class ShareableDashboard extends ConsumerStatefulWidget {
  final int phaseNumber;
  final int sessionsCompleted;
  final double totalVolumeKg;
  final String rankName;
  final UnitSystem unit;

  const ShareableDashboard({
    super.key,
    required this.phaseNumber,
    required this.sessionsCompleted,
    required this.totalVolumeKg,
    required this.rankName,
    required this.unit,
  });

  static Future<void> show(
    BuildContext context, {
    required int phaseNumber,
    required int sessionsCompleted,
    required double totalVolumeKg,
    required String rankName,
    required UnitSystem unit,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ShareableDashboard(
          phaseNumber: phaseNumber,
          sessionsCompleted: sessionsCompleted,
          totalVolumeKg: totalVolumeKg,
          rankName: rankName,
          unit: unit,
        ),
      ),
    );
  }

  @override
  ConsumerState<ShareableDashboard> createState() => _ShareableDashboardState();
}

class _ShareableDashboardState extends ConsumerState<ShareableDashboard> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isExporting = false;

  Future<void> _exportAndShare() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final boundary =
          _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/fight_camp_dashboard.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Crushing my Fight Camp on Martial Body. #KinesicEvolution',
        );
      }
    } catch (e) {
      debugPrint('Error sharing dashboard: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.appColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: _DashboardCard(
                        phaseNumber: widget.phaseNumber,
                        sessionsCompleted: widget.sessionsCompleted,
                        totalVolumeKg: widget.totalVolumeKg,
                        rankName: widget.rankName,
                        unit: widget.unit,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.gold,
                    foregroundColor: context.appColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Icon(Icons.share, size: 20),
                  label: Text(
                    _isExporting ? 'EXPORTING...' : 'SHARE TO STORIES',
                    style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  onPressed: _exportAndShare,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final int phaseNumber;
  final int sessionsCompleted;
  final double totalVolumeKg;
  final String rankName;
  final UnitSystem unit;

  const _DashboardCard({
    required this.phaseNumber,
    required this.sessionsCompleted,
    required this.totalVolumeKg,
    required this.rankName,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.phaseColor(phaseNumber);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withAlpha(80), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(20),
            blurRadius: 30,
            spreadRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(20),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(15),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MARTIAL\nBODY',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: context.appColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                      ),
                      Icon(Icons.bolt, color: color, size: 40),
                    ],
                  ),
                  const SizedBox(height: 48),
                  
                  Text(
                    'KINESIC EVOLUTION',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.appColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rankName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 48),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _StatBlock(
                          label: 'SESSIONS',
                          value: '$sessionsCompleted',
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: context.appColors.divider,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _StatBlock(
                          label: 'TOTAL VOLUME',
                          value: Units.volume(totalVolumeKg, unit),
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'FIGHT CAMP SUMMARY',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.appColors.textSecondary,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
