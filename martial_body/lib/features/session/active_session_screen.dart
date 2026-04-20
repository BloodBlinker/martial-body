import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/database/database.dart';
import '../../core/models/active_session_state.dart';
import '../../core/providers/active_session_provider.dart';
import '../../core/providers/analytics_provider.dart';
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
  final Map<String, FocusNode> _weightFocus = {};
  final Map<String, FocusNode> _repsFocus = {};

  // Tempo tooltip — kept here (not in _ExerciseCard) so it doesn't reappear
  // every time the user taps Next to a new exercise.
  bool _showTempoTooltip = true;

  // Rest-timer state. Lives here (not in _RestHint) so navigating exercises
  // doesn't reset the countdown, and so it can be triggered from onToggleSet.
  DateTime? _restStartedAt;
  int? _restDurationSeconds;

  @override
  void dispose() {
    for (final c in _weightCtrl.values) {
      c.dispose();
    }
    for (final c in _repsCtrl.values) {
      c.dispose();
    }
    for (final f in _weightFocus.values) {
      f.dispose();
    }
    for (final f in _repsFocus.values) {
      f.dispose();
    }
    super.dispose();
  }

  /// Build any missing controllers + focus nodes and re-sync existing ones to
  /// the latest draft values from the provider. Only overwrites when the
  /// provider value differs AND the field isn't currently focused — setting
  /// `.text` on a focused field cancels IME composition and jumps the caret.
  void _syncControllers(ActiveSessionState s) {
    for (final be in s.allExercises) {
      final sets = be.blockExercise.sets ?? 1;
      for (int i = 1; i <= sets; i++) {
        final k = ActiveSessionState.key(be.blockExercise.id, i);
        final w = s.weightFor(be.blockExercise.id, i);
        final r = s.repsFor(be.blockExercise.id, i);

        final wc = _weightCtrl.putIfAbsent(
          k,
          () => TextEditingController(text: w),
        );
        final wf = _weightFocus.putIfAbsent(k, FocusNode.new);
        if (!wf.hasFocus && wc.text != w) wc.text = w;

        final rc = _repsCtrl.putIfAbsent(
          k,
          () => TextEditingController(text: r),
        );
        final rf = _repsFocus.putIfAbsent(k, FocusNode.new);
        if (!rf.hasFocus && rc.text != r) rc.text = r;
      }
    }
  }

  Map<String, String> _snapshot(Map<String, TextEditingController> m) =>
      {for (final e in m.entries) e.key: e.value.text};

  Future<bool> _confirmExit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('End session?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Your logged sets are saved. This will exit the active workout '
          'without marking the session complete.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep training'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(activeSessionProvider(widget.sessionId));

    return async.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.textSecondary))),
      ),
      data: (s) {
        _syncControllers(s);
        return _ActiveBody(
          s: s,
          sessionId: widget.sessionId,
          phaseNumber: s.sessionDetail.phase.number,
          weightCtrl: _weightCtrl,
          repsCtrl: _repsCtrl,
          weightFocus: _weightFocus,
          repsFocus: _repsFocus,
          restStartedAt: _restStartedAt,
          restDurationSeconds: _restDurationSeconds,
          onSkipRest: () => setState(() {
            _restStartedAt = null;
            _restDurationSeconds = null;
          }),
          onRequestClose: () async {
            final ok = await _confirmExit(context);
            if (ok && context.mounted) {
              context.go('/session/${widget.sessionId}');
            }
          },
          showTempoTooltip: _showTempoTooltip,
          onDismissTempoTooltip: () =>
              setState(() => _showTempoTooltip = false),
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
                );
            if (!mounted) return;
            if (toggledOn && restSeconds != null && restSeconds > 0) {
              setState(() {
                _restStartedAt = DateTime.now();
                _restDurationSeconds = restSeconds;
              });
            }
          },
          onComplete: () async {
            final notifier =
                ref.read(activeSessionProvider(widget.sessionId).notifier);
            // Auto-persist any non-empty but untoggled rows so the last set
            // always makes it into the log, even if the user forgot to tap
            // the check.
            await notifier.persistRemainingDrafts(
              weightTexts: _snapshot(_weightCtrl),
              repsTexts: _snapshot(_repsCtrl),
            );
            await notifier.completeSession();
            // homeProvider is Stream-backed off watchAllLogs() and refreshes
            // on its own. analyticsProvider is a FutureProvider and must be
            // invalidated so the Progress tab reflects the new session.
            ref.invalidate(analyticsProvider);
            if (context.mounted) context.go('/home');
          },
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
  final Map<String, FocusNode> weightFocus;
  final Map<String, FocusNode> repsFocus;
  final DateTime? restStartedAt;
  final int? restDurationSeconds;
  final VoidCallback onSkipRest;
  final VoidCallback onRequestClose;
  final bool showTempoTooltip;
  final VoidCallback onDismissTempoTooltip;
  final void Function(int) onNavigate;
  final void Function(int beId, int setNum, int? restSeconds) onToggleSet;
  final VoidCallback onComplete;

  const _ActiveBody({
    required this.s,
    required this.sessionId,
    required this.phaseNumber,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.weightFocus,
    required this.repsFocus,
    required this.restStartedAt,
    required this.restDurationSeconds,
    required this.onSkipRest,
    required this.onRequestClose,
    required this.showTempoTooltip,
    required this.onDismissTempoTooltip,
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
    final phaseColor = AppColors.phaseColor(phaseNumber);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              session: s.sessionDetail.session,
              phaseNumber: phaseNumber,
              onClose: onRequestClose,
            ),
            _BlockProgressBar(
              blocks: blockNames,
              currentIndex: s.currentBlockIndex,
              accent: phaseColor,
            ),
            const SizedBox(height: 8),
            _BlockLabel(
              blockName: s.sessionDetail.blocks[s.currentBlockIndex].block.name,
              exerciseIndex: s.currentExerciseIndex,
              totalExercises: s.allExercises.length,
              accent: phaseColor,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _ExerciseCard(
                      name: exercise.name,
                      sets: sets,
                      reps: beRow.reps,
                      tempo: beRow.tempo,
                      restSeconds: beRow.restSeconds,
                      notes: beRow.notes,
                      lastSet: s.lastByExerciseId[exercise.id],
                      accent: phaseColor,
                      showTempoTooltip: showTempoTooltip,
                      onDismissTempoTooltip: onDismissTempoTooltip,
                    ),
                    const SizedBox(height: 20),
                    _SetLogTable(
                      beId: beRow.id,
                      sets: sets,
                      restSeconds: beRow.restSeconds,
                      state: s,
                      weightCtrl: weightCtrl,
                      repsCtrl: repsCtrl,
                      weightFocus: weightFocus,
                      repsFocus: repsFocus,
                      accent: phaseColor,
                      accentMuted: AppColors.phaseMutedColor(phaseNumber),
                      onToggle: onToggleSet,
                    ),
                    const SizedBox(height: 20),
                    if (completedSets > 0 && completedSets < sets && beRow.restSeconds != null)
                      _RestHint(
                        totalSeconds: beRow.restSeconds!,
                        startedAt: restStartedAt,
                        activeDurationSeconds: restDurationSeconds,
                        onSkip: onSkipRest,
                      ),
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
                    const SizedBox(height: 40),
                  ],
                ),
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
  final VoidCallback onClose;
  const _TopBar({
    required this.session,
    required this.phaseNumber,
    required this.onClose,
  });

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
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                ),
                Text(
                  session.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'Exit workout',
            icon: const Icon(
              Icons.close,
              color: AppColors.textSecondary,
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
          final color = (isDone || isCurrent) ? accent : AppColors.divider;
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

  const _BlockLabel({
    required this.blockName,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
          const Text('·', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Text(
            'Exercise ${exerciseIndex + 1} of $totalExercises',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ExerciseCard extends StatefulWidget {
  final String name;
  final int sets;
  final String? reps;
  final String? tempo;
  final int? restSeconds;
  final String? notes;
  final SetLog? lastSet;
  final Color accent;
  final bool showTempoTooltip;
  final VoidCallback onDismissTempoTooltip;

  const _ExerciseCard({
    required this.name,
    required this.sets,
    this.reps,
    this.tempo,
    this.restSeconds,
    this.notes,
    this.lastSet,
    required this.accent,
    required this.showTempoTooltip,
    required this.onDismissTempoTooltip,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _showNotes = false;

  Future<void> _openDemo(BuildContext context, String exerciseName) async {
    final uri = Uri.https(
      'www.youtube.com',
      '/results',
      {'search_query': '$exerciseName form demo'},
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open demo video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                tooltip: 'Watch demo',
                onPressed: () => _openDemo(context, widget.name),
                icon: Icon(
                  Icons.play_circle_outline,
                  color: widget.accent,
                  semanticLabel: 'Watch ${widget.name} demo',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatBox(label: 'SETS', value: '${widget.sets}'),
              if (widget.reps != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'REPS', value: widget.reps!),
              ],
              if (widget.restSeconds != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'REST', value: '${widget.restSeconds}s'),
              ],
            ],
          ),
          if (widget.lastSet != null) ...[
            const SizedBox(height: 12),
            _LastSetChip(log: widget.lastSet!, accent: widget.accent),
          ],
          if (widget.tempo != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: widget.onDismissTempoTooltip,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TEMPO',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.0,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _TempoDisplay(tempo: widget.tempo!),
                  if (widget.showTempoTooltip && widget.tempo!.contains('-')) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Eccentric · Pause · Concentric · Pause',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onDismissTempoTooltip,
                            child: const Icon(Icons.close, size: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (widget.notes != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => setState(() => _showNotes = !_showNotes),
              child: Row(
                children: [
                  Text(
                    'Coaching notes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: widget.accent),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showNotes ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: widget.accent,
                  ),
                ],
              ),
            ),
            if (_showNotes) ...[
              const SizedBox(height: 8),
              Text(
                widget.notes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
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
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 13, color: accent),
          const SizedBox(width: 6),
          Text(
            'Last time: ${parts.join(' × ')}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
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
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
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
                color: AppColors.surfaceVariant,
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
  final ActiveSessionState state;
  final Map<String, TextEditingController> weightCtrl;
  final Map<String, TextEditingController> repsCtrl;
  final Map<String, FocusNode> weightFocus;
  final Map<String, FocusNode> repsFocus;
  final Color accent;
  final Color accentMuted;
  final void Function(int beId, int setNum, int? restSeconds) onToggle;

  const _SetLogTable({
    required this.beId,
    required this.sets,
    required this.restSeconds,
    required this.state,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.weightFocus,
    required this.repsFocus,
    required this.accent,
    required this.accentMuted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Weight (kg)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Reps',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const Divider(height: 1),
          ...List.generate(sets, (i) {
            final setNum = i + 1;
            final k = ActiveSessionState.key(beId, setNum);
            // _syncControllers guarantees the key exists for every set of
            // every exercise before this widget is built.
            final wCtrl = weightCtrl[k]!;
            final rCtrl = repsCtrl[k]!;
            final wFocus = weightFocus[k]!;
            final rFocus = repsFocus[k]!;
            return _SetRow(
              setNumber: setNum,
              isDone: state.isDone(beId, setNum),
              weightCtrl: wCtrl,
              repsCtrl: rCtrl,
              weightFocus: wFocus,
              repsFocus: rFocus,
              isLast: i == sets - 1,
              accent: accent,
              accentMuted: accentMuted,
              onToggle: () => onToggle(beId, setNum, restSeconds),
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
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  final FocusNode weightFocus;
  final FocusNode repsFocus;
  final bool isLast;
  final Color accent;
  final Color accentMuted;
  final VoidCallback onToggle;

  const _SetRow({
    required this.setNumber,
    required this.isDone,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.weightFocus,
    required this.repsFocus,
    required this.isLast,
    required this.accent,
    required this.accentMuted,
    required this.onToggle,
  });

  // Up to one decimal point, digits only. Rejects paste of "abc" or "12.5.5".
  static final RegExp _weightRegex = RegExp(r'^\d{0,4}(\.\d{0,1})?$');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: weightCtrl,
                  focusNode: weightFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    TextInputFormatter.withFunction((oldVal, newVal) =>
                        _weightRegex.hasMatch(newVal.text) ? newVal : oldVal),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: '—',
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: repsCtrl,
                  focusNode: repsFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: '—',
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Semantics(
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
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16),
      ],
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
        color: AppColors.phase4Muted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.phase4),
      ),
      child: Row(
        children: [
          Icon(
            finished ? Icons.check_circle : Icons.timer,
            color: AppColors.phase4,
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
                        color: AppColors.phase4,
                        letterSpacing: 0.8,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.phase4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          if (isActive && !finished)
            TextButton(
              onPressed: widget.onSkip,
              style: TextButton.styleFrom(foregroundColor: AppColors.phase4),
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
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.divider),
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
                label: const Text('Next'),
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
