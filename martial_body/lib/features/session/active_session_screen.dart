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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/database/database.dart';
import '../../core/models/active_session_state.dart';
import '../../core/providers/active_session_provider.dart';
import '../../core/providers/analytics_provider.dart';
import '../../core/providers/database_provider.dart';
import '../../core/theme/app_colors.dart';

class ActiveSessionScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const ActiveSessionScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  // One controller + focus node per set slot across ALL exercises — keyed by
  // "${beId}_${setNum}".
  final Map<String, TextEditingController> _weightCtrl = {};
  final Map<String, TextEditingController> _repsCtrl = {};
  final Map<String, TextEditingController> _rightRepsCtrl = {};
  final Map<String, FocusNode> _weightFocus = {};
  final Map<String, FocusNode> _repsFocus = {};
  final Map<String, FocusNode> _rightRepsFocus = {};

  // Per-exercise dismissed tempo tooltips (beId).
  final Set<int> _dismissedTempoTooltips = {};
  // Per-exercise open coaching notes (beId).
  final Set<int> _notesOpen = {};

  // Rest-timer state. Lives here so navigating exercises doesn't reset it.
  DateTime? _restStartedAt;
  int? _restDurationSeconds;

  // Master session timer — anchored to the DB startedAt so it survives
  // resume and screen re-creation.
  Timer? _sessionTimer;
  DateTime? _sessionStartedAt;
  Duration _sessionElapsed = Duration.zero;

  // Cardio block timer state, keyed by blockId so each block has its own
  // independent timer that survives navigating to another exercise and back.
  final Map<int, DateTime?> _cardioStartedAt = {};
  final Map<int, Duration> _cardioPausedElapsed = {};

  // Prevent showing the weight dialog multiple times in one session.
  bool _weightDialogShown = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _sessionStartedAt != null) {
        setState(() {
          _sessionElapsed = DateTime.now().difference(_sessionStartedAt!);
        });
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _sessionTimer?.cancel();
    for (final c in _weightCtrl.values) {
      c.dispose();
    }
    for (final c in _repsCtrl.values) {
      c.dispose();
    }
    for (final c in _rightRepsCtrl.values) {
      c.dispose();
    }
    for (final f in _weightFocus.values) {
      f.dispose();
    }
    for (final f in _repsFocus.values) {
      f.dispose();
    }
    for (final f in _rightRepsFocus.values) {
      f.dispose();
    }
    super.dispose();
  }

  /// Build any missing controllers + focus nodes for every set slot.
  /// Controllers are only initialised once (via putIfAbsent) from the
  /// provider's draft values — we never overwrite after that so user-typed
  /// values are not lost when another set is toggled and triggers a rebuild.
  void _syncControllers(ActiveSessionState s) {
    for (final be in s.allExercises) {
      if (be.isCardioBlock) continue;
      final sets = be.blockExercise.sets ?? 1;
      for (int i = 1; i <= sets; i++) {
        final k = ActiveSessionState.key(be.blockExercise.id, i);

        // Prefer any draft the provider already has; fall back to the last
        // completed set for this exercise so the user sees a sane suggestion.
        final draftWeight = s.weightFor(be.blockExercise.id, i);
        final lastLog = s.lastByExerciseId[be.exercise.id];
        final prefillWeight = draftWeight.isNotEmpty
            ? draftWeight
            : (lastLog?.weightKg != null
                ? ActiveSessionNotifier.formatWeight(lastLog!.weightKg!)
                : '');

        _weightCtrl.putIfAbsent(
          k,
          () => TextEditingController(text: prefillWeight),
        );
        _weightFocus.putIfAbsent(k, FocusNode.new);

        _repsCtrl.putIfAbsent(
          k,
          () => TextEditingController(text: s.repsFor(be.blockExercise.id, i)),
        );
        _repsFocus.putIfAbsent(k, FocusNode.new);

        _rightRepsCtrl.putIfAbsent(
          k,
          () => TextEditingController(text: s.rightRepsFor(be.blockExercise.id, i)),
        );
        _rightRepsFocus.putIfAbsent(k, FocusNode.new);
      }
    }
  }

  Map<String, String> _snapshot(Map<String, TextEditingController> m) =>
      {for (final e in m.entries) e.key: e.value.text};

  /// Returns: 'keep' | 'later' | 'exit'
  Future<String> _confirmExit(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: Text('Leave workout?',
            style: TextStyle(color: context.appColors.textPrimary)),
        content: Text(
          'Choose how you want to leave.',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
        actionsAlignment: MainAxisAlignment.start,
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        actions: [
          // Keep training
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(ctx).pop('keep'),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Keep training'),
              ),
            ),
          ),
          // Continue later — leave log intact, show in In Progress
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(ctx).pop('later'),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Continue Later',
                    style: TextStyle(color: context.appColors.textPrimary)),
              ),
            ),
          ),
          // Exit session — delete the log entirely
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(ctx).pop('exit'),
              style: TextButton.styleFrom(foregroundColor: context.appColors.error),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Exit Session'),
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? 'keep';
  }

  /// Called by PopScope when the system back gesture is detected. Reuses
  /// the existing 3-way exit dialog so the user always gets a choice.
  Future<void> _handleBackGesture() async {
    final choice = await _confirmExit(context);
    if (!context.mounted) return;
    final notifier =
        ref.read(activeSessionProvider(widget.sessionId).notifier);
    if (choice == 'later') {
      await notifier.saveDraftsForResume(
        weightTexts: _snapshot(_weightCtrl),
        repsTexts: _snapshot(_repsCtrl),
        rightRepsTexts: _snapshot(_rightRepsCtrl),
      );
      if (context.mounted) context.go('/home');
    } else if (choice == 'exit') {
      await notifier.abandonSession();
      if (context.mounted) context.go('/home');
    }
    // 'keep' → do nothing
  }

  /// Confirmation before completing a session — prevents accidental taps
  /// with sweaty hands from permanently locking in incomplete data.
  Future<void> _confirmComplete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: Text('Complete session?',
            style: TextStyle(color: context.appColors.textPrimary)),
        content: Text(
          'Any unchecked sets will be saved as-is. '
          'You won\'t be able to resume this session later.',
          style: TextStyle(color: context.appColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: context.appColors.gold),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    HapticFeedback.heavyImpact();
    final notifier =
        ref.read(activeSessionProvider(widget.sessionId).notifier);
    await notifier.persistRemainingDrafts(
      weightTexts: _snapshot(_weightCtrl),
      repsTexts: _snapshot(_repsCtrl),
      rightRepsTexts: _snapshot(_rightRepsCtrl),
    );
    await notifier.completeSession();
    ref.invalidate(analyticsProvider);
    if (!context.mounted) return;

    // Compute summary stats for the celebration screen.
    final state = ref.read(activeSessionProvider(widget.sessionId)).valueOrNull;
    final totalSets = state?.allExercises.fold<int>(
          0, (sum, e) => sum + (e.blockExercise.sets ?? 1)) ?? 0;
    final doneSets = state?.setsDone.values.where((v) => v).length ?? 0;
    final elapsed = _sessionElapsed;
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;

    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.appColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(Icons.emoji_events_rounded,
                color: context.appColors.gold, size: 48),
            const SizedBox(height: 12),
            Text(
              'Session Complete!',
              style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              state?.sessionDetail.session.name ?? 'Workout',
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryStat(
                  icon: Icons.timer_outlined,
                  value: '${minutes}m ${seconds.toString().padLeft(2, '0')}s',
                  label: 'Duration',
                ),
                _SummaryStat(
                  icon: Icons.check_circle_outline,
                  value: '$doneSets / $totalSets',
                  label: 'Sets logged',
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.gold,
                  foregroundColor: context.appColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('DONE',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
    if (context.mounted) context.go('/home');
  }

  void _maybeShowWeightDialog(BuildContext context) {
    // Only show once per session, and only if the dialog hasn't been shown yet.
    if (_weightDialogShown) return;
    _weightDialogShown = true;

    // Show the dialog asynchronously to avoid interfering with the first frame.
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!context.mounted) return;
      _showWeightDialog(context);
    });
  }

  Future<void> _showWeightDialog(BuildContext context) async {
    final weightCtrl = TextEditingController();

    final result = await showDialog<double?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: Text('Log your weight',
            style: TextStyle(color: context.appColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your current body weight to track your progress.',
              style: TextStyle(color: context.appColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                hintText: 'e.g. 75.5 kg',
                hintStyle: TextStyle(color: context.appColors.textSecondary),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: TextStyle(color: context.appColors.textPrimary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Skip'),
          ),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(weightCtrl.text);
              Navigator.of(ctx).pop(weight);
            },
            style: TextButton.styleFrom(foregroundColor: context.appColors.gold),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      try {
        final db = ref.read(databaseProvider);
        await db.userDao.upsertTodayWeight(result);
      } catch (e) {
        // Silently fail — don't interrupt the workout if weight logging fails.
      }
    }
    weightCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(activeSessionProvider(widget.sessionId));

    return async.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(child: CircularProgressIndicator(color: context.appColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(child: Text('Error: $e', style: TextStyle(color: context.appColors.textSecondary))),
      ),
      data: (s) {
        _syncControllers(s);
        _maybeShowWeightDialog(context);
        // Anchor timer to real DB startedAt (once, on first data arrival).
        _sessionStartedAt ??= s.sessionStartedAt;
        if (_sessionElapsed == Duration.zero && _sessionStartedAt != null) {
          _sessionElapsed = DateTime.now().difference(_sessionStartedAt!);
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _handleBackGesture();
          },
          child: _ActiveBody(
          s: s,
          sessionId: widget.sessionId,
          phaseNumber: s.sessionDetail.phase.number,
          weightCtrl: _weightCtrl,
          repsCtrl: _repsCtrl,
          rightRepsCtrl: _rightRepsCtrl,
          weightFocus: _weightFocus,
          repsFocus: _repsFocus,
          rightRepsFocus: _rightRepsFocus,
          restStartedAt: _restStartedAt,
          restDurationSeconds: _restDurationSeconds,
          sessionElapsed: _sessionElapsed,
          dismissedTempoTooltips: _dismissedTempoTooltips,
          notesOpen: _notesOpen,
          cardioStartedAt: _cardioStartedAt,
          cardioPausedElapsed: _cardioPausedElapsed,
          onSkipRest: () => setState(() {
            _restStartedAt = null;
            _restDurationSeconds = null;
          }),
          onRequestClose: () async {
            final choice = await _confirmExit(context);
            if (!context.mounted) return;
            final notifier =
                ref.read(activeSessionProvider(widget.sessionId).notifier);
            if (choice == 'later') {
              await notifier.saveDraftsForResume(
                weightTexts: _snapshot(_weightCtrl),
                repsTexts: _snapshot(_repsCtrl),
                rightRepsTexts: _snapshot(_rightRepsCtrl),
              );
              if (context.mounted) context.go('/home');
            } else if (choice == 'exit') {
              await notifier.abandonSession();
              if (context.mounted) context.go('/home');
            }
            // 'keep' → do nothing
          },
          onDismissTempoTooltip: (beId) =>
              setState(() => _dismissedTempoTooltips.add(beId)),
          onToggleNotes: (beId) => setState(() {
            if (_notesOpen.contains(beId)) {
              _notesOpen.remove(beId);
            } else {
              _notesOpen.add(beId);
            }
          }),
          onCardioStateChanged: (blockId, startedAt, pausedElapsed) {
            _cardioStartedAt[blockId] = startedAt;
            _cardioPausedElapsed[blockId] = pausedElapsed;
          },
          onNavigate: (i) => ref
              .read(activeSessionProvider(widget.sessionId).notifier)
              .navigateTo(i),
          onToggleSet: (beId, setNum, restSeconds) async {
            final k = ActiveSessionState.key(beId, setNum);
            final toggledOn = await ref
                .read(activeSessionProvider(widget.sessionId).notifier)
                .toggleSet(
                  beId: beId,
                  setNumber: setNum,
                  weightText: _weightCtrl[k]?.text ?? '',
                  repsText: _repsCtrl[k]?.text ?? '',
                  rightRepsText: _rightRepsCtrl[k]?.text ?? '',
                );
            if (!mounted) return;
            // Haptic feedback: confirm set toggle registered.
            HapticFeedback.mediumImpact();
            if (toggledOn && restSeconds != null && restSeconds > 0) {
              setState(() {
                _restStartedAt = DateTime.now();
                _restDurationSeconds = restSeconds;
              });
            }
          },
          onComplete: () => _confirmComplete(context),
        ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------

class _ActiveBody extends StatelessWidget {
  final ActiveSessionState s;
  final int sessionId;
  final int phaseNumber;
  final Map<String, TextEditingController> weightCtrl;
  final Map<String, TextEditingController> repsCtrl;
  final Map<String, TextEditingController> rightRepsCtrl;
  final Map<String, FocusNode> weightFocus;
  final Map<String, FocusNode> repsFocus;
  final Map<String, FocusNode> rightRepsFocus;
  final DateTime? restStartedAt;
  final int? restDurationSeconds;
  final Duration sessionElapsed;
  final Set<int> dismissedTempoTooltips;
  final Set<int> notesOpen;
  final Map<int, DateTime?> cardioStartedAt;
  final Map<int, Duration> cardioPausedElapsed;
  final VoidCallback onSkipRest;
  final VoidCallback onRequestClose;
  final void Function(int beId) onDismissTempoTooltip;
  final void Function(int beId) onToggleNotes;
  final void Function(int blockId, DateTime? startedAt, Duration pausedElapsed) onCardioStateChanged;
  final void Function(int) onNavigate;
  final void Function(int beId, int setNum, int? restSeconds) onToggleSet;
  final VoidCallback onComplete;

  const _ActiveBody({
    required this.s,
    required this.sessionId,
    required this.phaseNumber,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.rightRepsCtrl,
    required this.weightFocus,
    required this.repsFocus,
    required this.rightRepsFocus,
    required this.restStartedAt,
    required this.restDurationSeconds,
    required this.sessionElapsed,
    required this.dismissedTempoTooltips,
    required this.notesOpen,
    required this.cardioStartedAt,
    required this.cardioPausedElapsed,
    required this.onSkipRest,
    required this.onRequestClose,
    required this.onDismissTempoTooltip,
    required this.onToggleNotes,
    required this.onCardioStateChanged,
    required this.onNavigate,
    required this.onToggleSet,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final be = s.currentExercise;
    final beRow = be.blockExercise;
    final exercise = be.exercise;
    final blockNames = s.sessionDetail.blocks.map((b) => b.block.name).toList();
    final sets = beRow.sets ?? 1;
    final completedSets = s.completedSetsFor(beRow.id, sets);
    final isLast = s.currentExerciseIndex == s.allExercises.length - 1;
    final phaseColor = context.appColors.phaseColor(phaseNumber);
    final currentBlock = s.sessionDetail.blocks[s.currentBlockIndex].block;
    final blockType = currentBlock.blockType;

    // Detect unilateral exercises: reps string contains a slash (e.g. "10/arm")
    final isUnilateral = beRow.reps?.contains('/') ?? false;

    // Detect timed/isometric exercises: Static tempo means the "reps" field is
    // actually a duration — show "Secs" input instead of "Reps".
    final isTimed = !be.isCardioBlock &&
        beRow.tempo == 'Static' &&
        blockType != 'warmup' &&
        blockType != 'cooldown';

    final showRestHint = !be.isCardioBlock &&
        completedSets > 0 &&
        completedSets < sets &&
        beRow.restSeconds != null;

    // The rest timer should be visible globally — even after navigating to a
    // different exercise — as long as a rest period is still active.
    final isRestActive = restStartedAt != null;
    final restTotalSeconds = isRestActive
        ? (restDurationSeconds ?? beRow.restSeconds ?? 60)
        : (beRow.restSeconds ?? 60);

    return Scaffold(
      backgroundColor: context.appColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              session: s.sessionDetail.session,
              phaseNumber: phaseNumber,
              sessionElapsed: sessionElapsed,
              onClose: onRequestClose,
            ),
            _BlockProgressBar(
              blocks: blockNames,
              currentIndex: s.currentBlockIndex,
              accent: phaseColor,
            ),
            const SizedBox(height: 8),
            _BlockLabel(
              blockName: currentBlock.name,
              exerciseIndex: s.currentExerciseIndex,
              totalExercises: s.allExercises.length,
              accent: phaseColor,
              exerciseCompletions: List.generate(
                s.allExercises.length,
                (i) {
                  final ex = s.allExercises[i];
                  final exSets = ex.blockExercise.sets ?? 1;
                  return s.completedSetsFor(ex.blockExercise.id, exSets) >= exSets;
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (be.isCardioBlock)
                      _CardioBlockCard(
                        blockId: currentBlock.id,
                        blockName: exercise.name,
                        instructions: beRow.notes,
                        durationMinutes: currentBlock.durationMinutes,
                        isDone: s.isDone(beRow.id, 1),
                        accent: phaseColor,
                        accentMuted: context.appColors.phaseMutedColor(phaseNumber),
                        initialStartedAt: cardioStartedAt[currentBlock.id],
                        initialPausedElapsed: cardioPausedElapsed[currentBlock.id] ?? Duration.zero,
                        onStateChanged: (startedAt, pausedElapsed) =>
                            onCardioStateChanged(currentBlock.id, startedAt, pausedElapsed),
                        onMarkDone: () => onToggleSet(beRow.id, 1, null),
                      )
                    else ...[
                      _ExerciseCard(
                        beId: beRow.id,
                        name: exercise.name,
                        sets: sets,
                        reps: beRow.reps,
                        tempo: beRow.tempo,
                        restSeconds: beRow.restSeconds,
                        notes: beRow.notes,
                        lastSet: s.lastByExerciseId[exercise.id],
                        accent: phaseColor,
                        showTempoTooltip: !dismissedTempoTooltips.contains(beRow.id),
                        showNotes: notesOpen.contains(beRow.id),
                        onDismissTempoTooltip: () => onDismissTempoTooltip(beRow.id),
                        onToggleNotes: () => onToggleNotes(beRow.id),
                      ),
                      const SizedBox(height: 20),
                      _SetLogTable(
                        beId: beRow.id,
                        sets: sets,
                        restSeconds: beRow.restSeconds,
                        blockType: blockType,
                        prescribedReps: beRow.reps,
                        isUnilateral: isUnilateral,
                        isTimed: isTimed,
                        state: s,
                        weightCtrl: weightCtrl,
                        repsCtrl: repsCtrl,
                        rightRepsCtrl: rightRepsCtrl,
                        weightFocus: weightFocus,
                        repsFocus: repsFocus,
                        rightRepsFocus: rightRepsFocus,
                        accent: phaseColor,
                        accentMuted: context.appColors.phaseMutedColor(phaseNumber),
                        onToggle: onToggleSet,
                      ),
                    ],
                    const SizedBox(height: 20),
                    _NavigationRow(
                      exerciseIndex: s.currentExerciseIndex,
                      total: s.allExercises.length,
                      isLast: isLast,
                      accent: phaseColor,
                      onPrev: s.currentExerciseIndex > 0
                          ? () => onNavigate(s.currentExerciseIndex - 1)
                          : null,
                      onNext: !isLast
                          ? () => onNavigate(s.currentExerciseIndex + 1)
                          : null,
                      onComplete: isLast ? onComplete : null,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Rest timer bar: visible globally whenever a rest period is active
            // (even after navigating to a different exercise), OR when the
            // current exercise has a partial completion to show the static hint.
            if (showRestHint || isRestActive)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: _RestHint(
                  totalSeconds: restTotalSeconds,
                  startedAt: restStartedAt,
                  activeDurationSeconds: restDurationSeconds,
                  onSkip: onSkipRest,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final Session session;
  final int phaseNumber;
  final Duration sessionElapsed;
  final VoidCallback onClose;
  const _TopBar({
    required this.session,
    required this.phaseNumber,
    required this.sessionElapsed,
    required this.onClose,
  });

  String _formatElapsed(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PHASE $phaseNumber · ACTIVE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.appColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                ),
                Text(
                  session.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 14, color: context.appColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                _formatElapsed(sessionElapsed),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.appColors.textSecondary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onClose,
            tooltip: 'Exit workout',
            icon: Icon(
              Icons.close,
              color: context.appColors.textSecondary,
              semanticLabel: 'Exit workout',
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BlockProgressBar extends StatelessWidget {
  final List<String> blocks;
  final int currentIndex;
  final Color accent;

  const _BlockProgressBar({
    required this.blocks,
    required this.currentIndex,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: List.generate(blocks.length, (i) {
          final isCurrent = i == currentIndex;
          final isDone = i < currentIndex;
          final color = (isDone || isCurrent) ? accent : context.appColors.divider;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < blocks.length - 1 ? 4 : 0),
              child: Container(
                height: isCurrent ? 4 : 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _BlockLabel extends StatelessWidget {
  final String blockName;
  final int exerciseIndex;
  final int totalExercises;
  final Color accent;
  /// Per-exercise completion flags — true if all sets for that exercise are done.
  final List<bool> exerciseCompletions;

  const _BlockLabel({
    required this.blockName,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.accent,
    required this.exerciseCompletions,
  });

  @override
  Widget build(BuildContext context) {
    final doneCount = exerciseCompletions.where((v) => v).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  blockName.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text('·', style: TextStyle(color: context.appColors.textSecondary)),
              const SizedBox(width: 8),
              Text(
                '$doneCount/$totalExercises logged',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(totalExercises, (i) {
              final isCurrent = i == exerciseIndex;
              final isDone = exerciseCompletions.length > i && exerciseCompletions[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < totalExercises - 1 ? 3 : 0),
                  child: Container(
                    height: isCurrent ? 4 : 3,
                    decoration: BoxDecoration(
                      color: isDone
                          ? accent
                          : isCurrent
                              ? accent.withAlpha(120)
                              : context.appColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ExerciseCard extends StatelessWidget {
  final int beId;
  final String name;
  final int sets;
  final String? reps;
  final String? tempo;
  final int? restSeconds;
  final String? notes;
  final SetLog? lastSet;
  final Color accent;
  final bool showTempoTooltip;
  final bool showNotes;
  final VoidCallback onDismissTempoTooltip;
  final VoidCallback onToggleNotes;

  const _ExerciseCard({
    required this.beId,
    required this.name,
    required this.sets,
    this.reps,
    this.tempo,
    this.restSeconds,
    this.notes,
    this.lastSet,
    required this.accent,
    required this.showTempoTooltip,
    required this.showNotes,
    required this.onDismissTempoTooltip,
    required this.onToggleNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.divider),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatBox(label: 'SETS', value: '$sets'),
              if (reps != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'REPS', value: reps!),
              ],
              if (restSeconds != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'REST', value: '${restSeconds}s'),
              ],
            ],
          ),
          if (lastSet != null) ...[
            const SizedBox(height: 12),
            _LastSetChip(log: lastSet!, accent: accent),
          ],
          if (tempo != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onDismissTempoTooltip,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TEMPO',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.appColors.textSecondary,
                          letterSpacing: 1.0,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _TempoDisplay(tempo: tempo!),
                  if (showTempoTooltip && tempo!.contains('-')) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.appColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: context.appColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Eccentric · Pause · Concentric · Pause',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                            ),
                          ),
                          GestureDetector(
                            onTap: onDismissTempoTooltip,
                            child: Icon(Icons.close, size: 14, color: context.appColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (notes != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: onToggleNotes,
              child: Row(
                children: [
                  Text(
                    'Coaching notes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: accent),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    showNotes ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: accent,
                  ),
                ],
              ),
            ),
            if (showNotes) ...[
              const SizedBox(height: 8),
              Text(
                notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                      height: 1.5,
                    ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _LastSetChip extends StatelessWidget {
  final SetLog log;
  final Color accent;
  const _LastSetChip({required this.log, required this.accent});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    if (log.weightKg != null) {
      final w = log.weightKg!;
      parts.add('${w % 1 == 0 ? w.toInt() : w.toStringAsFixed(1)} kg');
    }
    if (log.repsCompleted != null) {
      parts.add('${log.repsCompleted} reps');
    }
    if (parts.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 13, color: accent),
          const SizedBox(width: 6),
          Text(
            'Last time: ${parts.join(' × ')}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.appColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.appColors.textSecondary,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

class _TempoDisplay extends StatelessWidget {
  final String tempo;
  const _TempoDisplay({required this.tempo});

  @override
  Widget build(BuildContext context) {
    final parts = tempo.split('-');
    if (parts.length != 4) {
      return Text(tempo, style: Theme.of(context).textTheme.bodyMedium);
    }
    const labels = ['Eccentric', 'Pause', 'Concentric', 'Pause'];
    return Row(
      children: List.generate(4, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 3 ? 6 : 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: context.appColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    parts[i],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    labels[i],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------

class _SetLogTable extends StatelessWidget {
  final int beId;
  final int sets;
  final int? restSeconds;
  final String blockType;
  final String? prescribedReps;
  final bool isUnilateral;
  final bool isTimed;
  final ActiveSessionState state;
  final Map<String, TextEditingController> weightCtrl;
  final Map<String, TextEditingController> repsCtrl;
  final Map<String, TextEditingController> rightRepsCtrl;
  final Map<String, FocusNode> weightFocus;
  final Map<String, FocusNode> repsFocus;
  final Map<String, FocusNode> rightRepsFocus;
  final Color accent;
  final Color accentMuted;
  final void Function(int beId, int setNum, int? restSeconds) onToggle;

  const _SetLogTable({
    required this.beId,
    required this.sets,
    required this.restSeconds,
    required this.blockType,
    required this.prescribedReps,
    required this.isUnilateral,
    required this.isTimed,
    required this.state,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.rightRepsCtrl,
    required this.weightFocus,
    required this.repsFocus,
    required this.rightRepsFocus,
    required this.accent,
    required this.accentMuted,
    required this.onToggle,
  });

  bool get _isSimple =>
      blockType == 'warmup' || blockType == 'cooldown';

  @override
  Widget build(BuildContext context) {
    final headerLabel = _isSimple
        ? 'Prescribed'
        : isUnilateral
            ? null  // custom headers rendered inside
            : null;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 32),
                const SizedBox(width: 12),
                if (_isSimple)
                  Expanded(
                    child: Text(
                      headerLabel ?? 'Prescribed',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.appColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else ...[
                  if (isUnilateral) ...[
                    Expanded(
                      child: Text(
                        'Weight (kg)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTimed ? 'L.Secs' : 'Left',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTimed ? 'R.Secs' : 'Right',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Text(
                        'Weight (kg)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTimed ? 'Secs' : 'Reps',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
                              letterSpacing: 0.8,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
                const SizedBox(width: 10),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const Divider(height: 1),
          ...List.generate(sets, (i) {
            final setNum = i + 1;
            final k = ActiveSessionState.key(beId, setNum);
            return _SetRow(
              setNumber: setNum,
              isDone: state.isDone(beId, setNum),
              isSimple: _isSimple,
              prescribedReps: prescribedReps,
              isUnilateral: isUnilateral && !_isSimple,
              isTimed: isTimed && !_isSimple,
              weightCtrl: weightCtrl[k],
              repsCtrl: repsCtrl[k],
              rightRepsCtrl: rightRepsCtrl[k],
              weightFocus: weightFocus[k],
              repsFocus: repsFocus[k],
              rightRepsFocus: rightRepsFocus[k],
              isLast: i == sets - 1,
              accent: accent,
              accentMuted: accentMuted,
              onToggle: () => onToggle(beId, setNum, restSeconds),
            );
          }),
          // "Fill remaining" button — copies set 1's data to all incomplete sets.
          if (!_isSimple && sets > 1) Builder(builder: (_) {
            final firstKey = ActiveSessionState.key(beId, 1);
            final firstDone = state.isDone(beId, 1);
            final firstWeight = weightCtrl[firstKey]?.text ?? '';
            final firstReps = repsCtrl[firstKey]?.text ?? '';
            final hasFirstData = firstDone || firstWeight.isNotEmpty || firstReps.isNotEmpty;
            final incompleteSets = List.generate(sets, (i) => i + 1)
                .where((s) => !state.isDone(beId, s))
                .toList();
            if (!hasFirstData || incompleteSets.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    for (final s in incompleteSets) {
                      final k = ActiveSessionState.key(beId, s);
                      if (firstWeight.isNotEmpty) {
                        weightCtrl[k]?.text = firstWeight;
                      }
                      if (firstReps.isNotEmpty) {
                        repsCtrl[k]?.text = firstReps;
                      }
                      if (isUnilateral) {
                        final firstRight = rightRepsCtrl[firstKey]?.text ?? '';
                        if (firstRight.isNotEmpty) {
                          rightRepsCtrl[k]?.text = firstRight;
                        }
                      }
                      onToggle(beId, s, null);
                    }
                  },
                  icon: Icon(Icons.copy_all, size: 16, color: accent),
                  label: Text(
                    'Fill remaining (${incompleteSets.length})',
                    style: TextStyle(fontSize: 12, color: accent),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accent.withAlpha(80)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final int setNumber;
  final bool isDone;
  /// True for warmup/cooldown — show prescribed reps text, no input fields.
  final bool isSimple;
  final String? prescribedReps;
  /// True for unilateral exercises — show separate Left / Right reps fields.
  final bool isUnilateral;
  /// True for isometric/static exercises — reps field tracks seconds, not count.
  final bool isTimed;
  final TextEditingController? weightCtrl;
  final TextEditingController? repsCtrl;
  final TextEditingController? rightRepsCtrl;
  final FocusNode? weightFocus;
  final FocusNode? repsFocus;
  final FocusNode? rightRepsFocus;
  final bool isLast;
  final Color accent;
  final Color accentMuted;
  final VoidCallback onToggle;

  const _SetRow({
    required this.setNumber,
    required this.isDone,
    required this.isSimple,
    required this.prescribedReps,
    required this.isUnilateral,
    required this.isTimed,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.rightRepsCtrl,
    required this.weightFocus,
    required this.repsFocus,
    required this.rightRepsFocus,
    required this.isLast,
    required this.accent,
    required this.accentMuted,
    required this.onToggle,
  });

  static final RegExp _weightRegex = RegExp(r'^\d{0,4}(\.\d{0,1})?$');

  Widget _setCircle() => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDone ? accentMuted : AppColors.surfaceVariant,
          shape: BoxShape.circle,
          border: Border.all(color: isDone ? accent : AppColors.divider),
        ),
        child: Center(
          child: Text(
            '$setNumber',
            style: TextStyle(
              color: isDone ? accent : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      );

  Widget _doneButton() => Semantics(
        button: true,
        toggled: isDone,
        label: isDone
            ? 'Set $setNumber complete, tap to undo'
            : 'Mark set $setNumber complete',
        child: GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDone ? accent : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDone ? accent : AppColors.divider),
            ),
            child: Icon(
              Icons.check,
              color: isDone ? Colors.black : AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      );

  Widget _repsField(
    TextEditingController ctrl,
    FocusNode focus, {
    TextInputAction action = TextInputAction.done,
    String? semanticLabel,
  }) =>
      Semantics(
        label: semanticLabel,
        child: TextField(
          controller: ctrl,
          focusNode: focus,
          keyboardType: TextInputType.number,
          textInputAction: action,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: '—',
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _setCircle(),
              const SizedBox(width: 12),
              // ── Simple (warmup / cooldown): show prescribed text only ──
              if (isSimple) ...[
                Expanded(
                  child: Text(
                    prescribedReps ?? '—',
                    style: TextStyle(
                      color: isDone ? accent : context.appColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
              // ── Unilateral: weight + left reps + right reps ──
              else if (isUnilateral && weightCtrl != null && repsCtrl != null && rightRepsCtrl != null) ...[
                Expanded(
                  child: TextField(
                    controller: weightCtrl,
                    focusNode: weightFocus,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      TextInputFormatter.withFunction((o, n) =>
                          _weightRegex.hasMatch(n.text) ? n : o),
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '—',
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _repsField(repsCtrl!, repsFocus!,
                      action: TextInputAction.next),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _repsField(rightRepsCtrl!, rightRepsFocus!),
                ),
              ]
              // ── Standard: weight + reps ──
              else if (weightCtrl != null && repsCtrl != null) ...[
                Expanded(
                  child: TextField(
                    controller: weightCtrl,
                    focusNode: weightFocus,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      TextInputFormatter.withFunction((o, n) =>
                          _weightRegex.hasMatch(n.text) ? n : o),
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '—',
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _repsField(repsCtrl!, repsFocus!,
                      semanticLabel: isTimed
                          ? 'Set $setNumber seconds'
                          : 'Set $setNumber reps'),
                ),
              ],
              const SizedBox(width: 10),
              _doneButton(),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

/// Full-screen card for a conditioning/cardio block that has no individual
/// exercises. Shows instructions, a count-up timer, and Begin/Pause/Done
/// controls. Marking done calls [onMarkDone] which toggles the synthetic set.
class _CardioBlockCard extends StatefulWidget {
  final int blockId;
  final String blockName;
  final String? instructions;
  final int? durationMinutes;
  final bool isDone;
  final Color accent;
  final Color accentMuted;
  final DateTime? initialStartedAt;
  final Duration initialPausedElapsed;
  final void Function(DateTime? startedAt, Duration pausedElapsed) onStateChanged;
  final VoidCallback onMarkDone;

  const _CardioBlockCard({
    required this.blockId,
    required this.blockName,
    required this.instructions,
    required this.durationMinutes,
    required this.isDone,
    required this.accent,
    required this.accentMuted,
    required this.initialStartedAt,
    required this.initialPausedElapsed,
    required this.onStateChanged,
    required this.onMarkDone,
  });

  @override
  State<_CardioBlockCard> createState() => _CardioBlockCardState();
}

class _CardioBlockCardState extends State<_CardioBlockCard> {
  Timer? _ticker;
  // Wall-clock anchor when running (accounts for previous pauses via
  // subtract). Null when paused or not yet started.
  DateTime? _startedAt;
  // Elapsed accumulated before the current run (zero when first started).
  Duration _pausedElapsed = Duration.zero;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _startedAt = widget.initialStartedAt;
    _pausedElapsed = widget.initialPausedElapsed;
    if (_startedAt != null) _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Duration get _elapsed => _startedAt != null
      ? DateTime.now().difference(_startedAt!)
      : _pausedElapsed;

  void _startTicker() {
    _ticker?.cancel();
    _running = true;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final target = widget.durationMinutes;
        if (target != null && _elapsed.inMinutes >= target) {
          _ticker?.cancel();
          _running = false;
        }
      });
    });
  }

  void _begin() {
    _startedAt = DateTime.now().subtract(_pausedElapsed);
    _startTicker();
    widget.onStateChanged(_startedAt, _pausedElapsed);
    setState(() {});
  }

  void _pause() {
    _pausedElapsed = _elapsed;
    _startedAt = null;
    _ticker?.cancel();
    widget.onStateChanged(null, _pausedElapsed);
    setState(() => _running = false);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.durationMinutes;
    final elapsed = _elapsed;
    final finished = target != null && elapsed.inMinutes >= target;

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.divider),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.blockName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (target != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _StatBox(label: 'TARGET', value: '$target min'),
              ],
            ),
          ],
          if (widget.instructions != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.instructions!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: context.appColors.textSecondary,
                    ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Timer display
          Center(
            child: Text(
              _fmt(elapsed),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: finished ? widget.accent : context.appColors.textPrimary,
                    fontSize: 56,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ),
          const SizedBox(height: 20),
          // Controls
          if (!widget.isDone) ...[
            Row(
              children: [
                if (!_running)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _begin,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: Text(_pausedElapsed == Duration.zero ? 'Begin' : 'Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accent,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pause,
                      icon: const Icon(Icons.pause, size: 18),
                      label: const Text('Pause'),
                    ),
                  ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    _ticker?.cancel();
                    widget.onMarkDone();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.accent,
                    side: BorderSide(color: widget.accent),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.accentMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: widget.accent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: widget.accent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cardio complete',
                    style: TextStyle(
                        color: widget.accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Live rest countdown.
///
/// Shows a static "${totalSeconds}s" placeholder until a set is toggled on —
/// then `startedAt` flips to a DateTime and the widget ticks down once per
/// second to zero. When elapsed ≥ duration, switches to "Ready" and stops the
/// ticker to save battery.
class _RestHint extends StatefulWidget {
  final int totalSeconds;
  final DateTime? startedAt;
  final int? activeDurationSeconds;
  final VoidCallback onSkip;

  const _RestHint({
    required this.totalSeconds,
    required this.startedAt,
    required this.activeDurationSeconds,
    required this.onSkip,
  });

  @override
  State<_RestHint> createState() => _RestHintState();
}

class _RestHintState extends State<_RestHint> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _maybeStartTicker();
  }

  @override
  void didUpdateWidget(covariant _RestHint old) {
    super.didUpdateWidget(old);
    if (widget.startedAt != old.startedAt) {
      _maybeStartTicker();
    }
  }

  void _maybeStartTicker() {
    _ticker?.cancel();
    if (widget.startedAt == null) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final remaining = _remaining();
      if (remaining <= 0) {
        _ticker?.cancel();
        HapticFeedback.heavyImpact();
      }
      setState(() {});
    });
  }

  int _remaining() {
    final start = widget.startedAt;
    final dur = widget.activeDurationSeconds ?? widget.totalSeconds;
    if (start == null) return dur;
    final elapsed = DateTime.now().difference(start).inSeconds;
    final r = dur - elapsed;
    return r < 0 ? 0 : r;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.startedAt != null;
    final remaining = _remaining();
    final finished = isActive && remaining == 0;
    final label = finished ? 'Ready' : 'Rest Period';
    final value = isActive ? '${remaining}s' : '${widget.totalSeconds}s';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: context.appColors.phase4Muted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.phase4),
      ),
      child: Row(
        children: [
          Icon(
            finished ? Icons.check_circle : Icons.timer,
            color: context.appColors.phase4,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.appColors.phase4,
                        letterSpacing: 0.8,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: context.appColors.phase4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          if (isActive && !finished)
            TextButton(
              onPressed: widget.onSkip,
              style: TextButton.styleFrom(foregroundColor: context.appColors.phase4),
              child: const Text('Skip'),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _NavigationRow extends StatelessWidget {
  final int exerciseIndex;
  final int total;
  final bool isLast;
  final Color accent;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onComplete;

  const _NavigationRow({
    required this.exerciseIndex,
    required this.total,
    required this.isLast,
    required this.accent,
    this.onPrev,
    this.onNext,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left, size: 18),
              label: const Text('Prev'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.appColors.textSecondary,
                side: BorderSide(color: context.appColors.divider),
              ),
            ),
            Expanded(
              child: Text(
                'Exercise ${exerciseIndex + 1} of $total',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            if (!isLast)
              ElevatedButton.icon(
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right, size: 18),
                label: const Text('Next Exercise'),
              )
            else
              ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('Finish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                ),
              ),
          ],
        ),
        if (isLast) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onComplete,
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('COMPLETE SESSION', style: TextStyle(letterSpacing: 1.2)),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Completion celebration helpers
// ---------------------------------------------------------------------------

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _SummaryStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: context.appColors.gold, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.appColors.textPrimary,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.appColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
