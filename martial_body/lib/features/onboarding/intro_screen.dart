import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/database_provider.dart';
import 'package:martial_body/core/theme/app_colors.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _starting = false;
  bool _checked = false;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': 'THE FOUNDATION',
      'subtitle': 'Build your base. 24 weeks of progressive periodization starting with foundational strength and conditioning.',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': 'THE ENGINE',
      'subtitle': 'Push the pace. Phase 2 ramps up the volume and intensity to build an unbreakable cardiovascular engine.',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': 'THE COMBAT',
      'subtitle': 'Translate strength to power. Phase 3 focuses on explosive movements and sport-specific physical preparation.',
    },
    {
      'image': 'assets/images/onboarding_4.png',
      'title': 'FIGHT READY',
      'subtitle': 'The final phase. Sharpen your conditioning and step into the cage ready for anything.',
    }
  ];

  Future<void> _onStart() async {
    if (_starting) return;
    if (!_checked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the disclaimer to begin.')),
      );
      return;
    }
    setState(() => _starting = true);
    try {
      final db = ref.read(databaseProvider);
      await db.userDao.insertUserState(DateTime.now());
      if (!mounted) return;
      unawaited(HapticFeedback.heavyImpact());
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _starting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not start: $e')),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Jump straight to the disclaimer (the final, gating page).
  void _skip() {
    HapticFeedback.lightImpact();
    _pageController.animateToPage(
      _pages.length,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  /// Step indicator dots — shown on every page (including the disclaimer) so
  /// the user always knows where they are and how many steps remain.
  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        _pages.length + 1,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          height: 6,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? context.appColors.gold : Colors.white38,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) {
              setState(() => _currentPage = idx);
              HapticFeedback.lightImpact();
            },
            itemCount: _pages.length + 1, // +1 for the disclaimer page
            itemBuilder: (context, index) {
              if (index == _pages.length) {
                return _buildDisclaimerPage(tt);
              }
              final page = _pages[index];
              return _buildImagePage(page, tt);
            },
          ),
          
          // Navigation / Bottom Area
          if (_currentPage < _pages.length)
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back affordance (placeholder keeps dots aligned on page 1).
                  _currentPage > 0
                      ? IconButton(
                          onPressed: _prevPage,
                          tooltip: 'Back',
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        )
                      : const SizedBox(width: 48),
                  _buildDots(),
                  FloatingActionButton(
                    onPressed: _nextPage,
                    backgroundColor: context.appColors.gold,
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ],
              ),
            ),
          // Skip straight to the disclaimer from any image page.
          if (_currentPage < _pages.length)
            Positioned(
              top: 8,
              right: 12,
              child: SafeArea(
                child: TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  child: const Text('Skip'),
                ),
              ),
            ),
          // Back button on the disclaimer page (its own CTA lives in the body).
          if (_currentPage == _pages.length)
            Positioned(
              top: 8,
              left: 8,
              child: SafeArea(
                child: IconButton(
                  onPressed: _prevPage,
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePage(Map<String, String> page, TextTheme tt) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          page['image']!,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.transparent, Colors.black87],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page['title']!,
                style: tt.headlineLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                page['subtitle']!,
                style: tt.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDisclaimerPage(TextTheme tt) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'BEFORE WE BEGIN',
                      style: tt.headlineMedium?.copyWith(
                        color: context.appColors.gold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "You're moments from Week 1. One quick, important read first — then you're in.",
                      style: tt.bodyLarge?.copyWith(
                        color: context.appColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'This 24-week program is a general fitness guide, not medical advice. High-intensity training and combat-sport preparation carry real injury risk.\n\n'
                      '• Consult a qualified physician if you have any medical condition.\n'
                      '• Stop immediately if you experience chest pain, dizziness, or unusual symptoms.\n'
                      '• Load, reps, and technique are ultimately your responsibility — prioritise form over weight.\n\n'
                      'By continuing you acknowledge you train at your own risk. The developer accepts no liability for injury or loss arising from use of this app.',
                      style: tt.bodyMedium?.copyWith(
                        color: context.appColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    InkWell(
                      onTap: () {
                        setState(() => _checked = !_checked);
                        HapticFeedback.lightImpact();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _checked,
                              onChanged: (v) {
                                setState(() => _checked = v ?? false);
                                HapticFeedback.lightImpact();
                              },
                              activeColor: context.appColors.gold,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  'I have read and understand the above. I am medically cleared to train and accept full responsibility for my participation.',
                                  style: tt.bodySmall?.copyWith(color: context.appColors.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: _buildDots()),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _starting ? null : _onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _checked ? context.appColors.gold : context.appColors.surfaceVariant,
                ),
                child: _starting
                    ? const SizedBox(
                        width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : Text(
                        'BEGIN PROGRAM',
                        style: tt.labelLarge?.copyWith(
                          color: _checked ? Colors.black : context.appColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
