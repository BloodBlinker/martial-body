import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/database_provider.dart';
import '../../core/theme/app_colors.dart';

/// First-run intro. Tapping "Start Training" creates the user_state row with
/// today's date — that row's existence is the "has onboarded" flag, and its
/// date is the Week 1 anchor for every downstream week calculation.
class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  bool _starting = false;
  bool _acknowledged = false;

  Future<void> _onStart() async {
    if (_starting) return;
    if (!_acknowledged) {
      final ok = await _showDisclaimer();
      if (ok != true) return;
      setState(() => _acknowledged = true);
    }
    setState(() => _starting = true);
    try {
      final db = ref.read(databaseProvider);
      await db.userDao.insertUserState(DateTime.now());
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _starting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not start: $e')),
      );
    }
  }

  Future<bool?> _showDisclaimer() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        bool checked = false;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              'Before you start',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This 24-week program is a general fitness guide, not '
                    'medical advice. High-intensity training and combat-sport '
                    'preparation carry real injury risk.\n\n'
                    'Before beginning:\n'
                    '  • Consult a qualified physician if you have any '
                    'cardiovascular, orthopaedic, metabolic, or other '
                    'medical condition.\n'
                    '  • Stop immediately and seek care if you experience '
                    'chest pain, dizziness, joint pain, or any unusual '
                    'symptom.\n'
                    '  • Load, reps, and technique are ultimately your '
                    'responsibility — scale movements to your ability and '
                    'prioritise form over weight.\n\n'
                    'By continuing you acknowledge you train at your own '
                    'risk. The developer accepts no liability for injury or '
                    'loss arising from use of this app.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => setDialogState(() => checked = !checked),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: checked,
                          onChanged: (v) =>
                              setDialogState(() => checked = v ?? false),
                          activeColor: AppColors.gold,
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'I have read and understand the above. I am '
                              'medically cleared to train and accept full '
                              'responsibility for my participation.',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: checked ? () => Navigator.of(ctx).pop(true) : null,
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.gold),
                child: const Text('Begin program'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    width: 148,
                    height: 148,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'MARTIAL BODY',
                textAlign: TextAlign.center,
                style: tt.headlineMedium?.copyWith(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '24 weeks. Four phases.\nOne fight-ready body.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(flex: 3),
              _FeatureRow(
                icon: Icons.fitness_center,
                title: 'Structured program',
                subtitle: 'Foundation → Engine → Combat → MMA.',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.bar_chart,
                title: 'Track every set',
                subtitle: 'Weight, reps, completion — fully offline.',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.restaurant_menu,
                title: 'Meal plans per phase',
                subtitle: 'Nutrition aligned with each training block.',
              ),
              const Spacer(flex: 2),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _starting ? null : _onStart,
                  child: _starting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : const Text('START TRAINING'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.gold.withAlpha(22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.gold),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
