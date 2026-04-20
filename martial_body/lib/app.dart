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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/intro_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/program/phase_detail_screen.dart';
import 'features/program/program_screen.dart';
import 'features/session/active_session_screen.dart';
import 'features/session/session_overview_screen.dart';
import 'features/splash/splash_screen.dart';

int? _parseSessionId(GoRouterState state) =>
    int.tryParse(state.pathParameters['sessionId'] ?? '');

final _router = GoRouter(
  initialLocation: '/splash',
  errorBuilder: (_, state) => _InvalidRouteScreen(uri: state.uri.toString()),
  routes: [
    // Splash + intro live OUTSIDE the bottom-nav shell so they occupy the
    // full screen with no navigation chrome.
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/intro', builder: (_, __) => const IntroScreen()),
    ShellRoute(
      builder: (context, state, child) => _ScaffoldWithNav(
        location: state.uri.toString(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/session/:sessionId',
          builder: (_, state) {
            final id = _parseSessionId(state);
            final preview = state.uri.queryParameters['preview'] == '1';
            return id == null
                ? const _InvalidRouteScreen(uri: 'invalid session')
                : SessionOverviewScreen(sessionId: id, preview: preview);
          },
          routes: [
            GoRoute(
              path: 'active',
              builder: (_, state) {
                final id = _parseSessionId(state);
                return id == null
                    ? const _InvalidRouteScreen(uri: 'invalid session')
                    : ActiveSessionScreen(sessionId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/progress',
          builder: (_, __) => const ProgressScreen(),
        ),
        GoRoute(
          path: '/program',
          builder: (_, __) => const ProgramScreen(),
          routes: [
            GoRoute(
              path: 'phase/:phaseNumber',
              builder: (_, state) {
                final n = int.tryParse(
                    state.pathParameters['phaseNumber'] ?? '');
                if (n == null || n < 1 || n > 4) {
                  return const _InvalidRouteScreen(uri: 'invalid phase');
                }
                return PhaseDetailScreen(phaseNumber: n);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class _InvalidRouteScreen extends StatelessWidget {
  final String uri;
  const _InvalidRouteScreen({required this.uri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.textSecondary, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Page not found',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                uri,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('GO HOME'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MartialBodyApp extends StatelessWidget {
  const MartialBodyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Martial Body',
      theme: AppTheme.dark,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom-nav shell
// ---------------------------------------------------------------------------

class _ScaffoldWithNav extends StatelessWidget {
  final String location;
  final Widget child;

  const _ScaffoldWithNav({required this.location, required this.child});

  int get _selectedIndex {
    if (location.startsWith('/progress')) return 1;
    if (location.startsWith('/program')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // /home and /session/*
  }

  // Hide the bottom nav on the immersive active session screen. Match the
  // full trailing segment `/active` so a path like `/active-alt` (or a
  // session named "active") doesn't accidentally hide the nav.
  bool get _showNav {
    final path = Uri.parse(location).path;
    return !(path == '/active' || path.endsWith('/active'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _showNav ? _buildNavBar(context) : null,
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.phase1Muted,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/home');
          case 1:
            context.go('/progress');
          case 2:
            context.go('/program');
          case 3:
            context.go('/profile');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.home, color: AppColors.phase1),
          label: 'Today',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.bar_chart, color: AppColors.phase1),
          label: 'Progress',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.calendar_month, color: AppColors.phase1),
          label: 'Program',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
          selectedIcon: Icon(Icons.person, color: AppColors.phase1),
          label: 'Profile',
        ),
      ],
    );
  }
}
