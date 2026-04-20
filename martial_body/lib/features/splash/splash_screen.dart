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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/database_provider.dart';
import '../../core/theme/app_colors.dart';

/// Brief brand splash shown on every cold start. The minimum visible duration
/// is enforced regardless of how fast the DB read resolves so the logo never
/// flashes by too quickly to register.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _minVisible = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    final db = ref.read(databaseProvider);
    // Kick off the DB read and a fixed delay in parallel; we wait on the
    // slower of the two so the splash always shows for at least _minVisible.
    final results = await Future.wait<Object?>([
      db.userDao.getUserState(),
      Future.delayed(_minVisible),
    ]);
    final userState = results[0];
    if (!mounted) return;
    context.go(userState == null ? '/intro' : '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/icon/app_icon.png',
                width: 112,
                height: 112,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'MARTIAL BODY',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    letterSpacing: 3.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
