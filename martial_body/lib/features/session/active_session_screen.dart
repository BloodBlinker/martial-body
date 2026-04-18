import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/database.dart';
import '../../core/models/active_session_state.dart';
import '../../core/providers/active_session_provider.dart';
import '../../core/providers/home_provider.dart';
import '../../core/theme/app_colors.dart';

class ActiveSessionScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const ActiveSessionScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  // One controller per set slot across ALL exercises — keyed by "${beId}_${setNum}".
  final Map<String, TextEditingController> _weightCtrl = {};
  final Map<String, TextEditingController> _repsCtrl = {};

  // Tempo tooltip — kept here (not in _ExerciseCard) so it doesn't reappear
  // every time the user taps Next to a new exercise.
  bool _showTempoTooltip = true;

  @override
  void dispose() {
    for (final c in _weightCtrl.values) {
      c.dispose();
    }
    for (final c in _repsCtrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Build any missing controllers and re-sync existing ones to the latest
  /// draft values from the provider. Only overwrites when the provider value
  /// differs AND the field isn't currently focused (so we don't fight the
  /// user mid-type).
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
        if (wc.text != w) wc.text = w;

        final rc = _repsCtrl.putIfAbsent(
          k,
          () => TextEditingController(text: r),
        );
        if (rc.text != r) rc.text = r;
      }
    }
  }

  Map<String, String> _snapshot(Map<String, TextEditingController> m) =>
      {for (final e in m.entries) e.key: e.value.text};

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
          weightCtrl: _weightCtrl,
          repsCtrl: _repsCtrl,
          showTempoTooltip: _showTempoTooltip,
          onDismissTempoTooltip: () =>
              setState(() => _showTempoTooltip = false),
          onNavigate: (i) => ref
              .read(activeSessionProvider(widget.sessionId).notifier)
              .navigateTo(i),
          onToggleSet: (beId, setNum) {
            final k = ActiveSessionState.key(beId, setNum);
            ref.read(activeSessionProvider(widget.sessionId).notifier).toggleSet(
                  beId: beId,
                  setNumber: setNum,
                  weightText: _weightCtrl[k]?.text ?? '',
                  repsText: _repsCtrl[k]?.text ?? '',
                );
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
            // Home is a Stream-backed provider now, but invalidate anyway so
            // any consumer built off FutureProviders (analytics) gets fresh
            // data the moment the user lands on /home.
            ref.invalidate(homeProvider);
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
  final Map<String, TextEditingController> weightCtrl;
  final Map<String, TextEditingController> repsCtrl;
  final bool showTempoTooltip;
  final VoidCallback onDismissTempoTooltip;
  final void Function(int) onNavigate;
  final void Function(int beId, int setNum) onToggleSet;
  final VoidCallback onComplete;

  const _ActiveBody({
    required this.s,
    required this.sessionId,
    required this.weightCtrl,
    required this.repsCtrl,
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              session: s.sessionDetail.session,
              onClose: () => context.go('/session/$sessionId'),
            ),
            _BlockProgressBar(
              blocks: blockNames,
              currentIndex: s.currentBlockIndex,
            ),
            const SizedBox(height: 8),
            _BlockLabel(
              blockName: s.sessionDetail.blocks[s.currentBlockIndex].block.name,
              exerciseIndex: s.currentExerciseIndex,
              totalExercises: s.allExercises.length,
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
                      showTempoTooltip: showTempoTooltip,
                      onDismissTempoTooltip: onDismissTempoTooltip,
                    ),
                    const SizedBox(height: 20),
                    _SetLogTable(
                      beId: beRow.id,
                      sets: sets,
                      state: s,
                      weightCtrl: weightCtrl,
                      repsCtrl: repsCtrl,
                      onToggle: onToggleSet,
                    ),
                    const SizedBox(height: 20),
                    if (completedSets > 0 && completedSets < sets && beRow.restSeconds != null)
                      _RestHint(seconds: beRow.restSeconds!),
                    const SizedBox(height: 20),
                    _NavigationRow(
                      exerciseIndex: s.currentExerciseIndex,
                      total: s.allExercises.length,
                      isLast: isLast,
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
  final VoidCallback onClose;
  const _TopBar({required this.session, required this.onClose});

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
                  'PHASE 1 · ACTIVE',
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
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
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

  const _BlockProgressBar({required this.blocks, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: List.generate(blocks.length, (i) {
          final isCurrent = i == currentIndex;
          final isDone = i < currentIndex;
          final color = (isDone || isCurrent) ? AppColors.phase1 : AppColors.divider;
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

  const _BlockLabel({
    required this.blockName,
    required this.exerciseIndex,
    required this.totalExercises,
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
                    color: AppColors.phase1,
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
  final bool showTempoTooltip;
  final VoidCallback onDismissTempoTooltip;

  const _ExerciseCard({
    required this.name,
    required this.sets,
    this.reps,
    this.tempo,
    this.restSeconds,
    this.notes,
    required this.showTempoTooltip,
    required this.onDismissTempoTooltip,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _showNotes = false;

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
          Text(
            widget.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.phase1),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showNotes ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: AppColors.phase1,
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
  final ActiveSessionState state;
  final Map<String, TextEditingController> weightCtrl;
  final Map<String, TextEditingController> repsCtrl;
  final void Function(int beId, int setNum) onToggle;

  const _SetLogTable({
    required this.beId,
    required this.sets,
    required this.state,
    required this.weightCtrl,
    required this.repsCtrl,
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
            return _SetRow(
              setNumber: setNum,
              isDone: state.isDone(beId, setNum),
              weightCtrl: wCtrl,
              repsCtrl: rCtrl,
              isLast: i == sets - 1,
              onToggle: () => onToggle(beId, setNum),
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
  final bool isLast;
  final VoidCallback onToggle;

  const _SetRow({
    required this.setNumber,
    required this.isDone,
    required this.weightCtrl,
    required this.repsCtrl,
    required this.isLast,
    required this.onToggle,
  });

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
                  color: isDone ? AppColors.phase1Muted : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: isDone ? AppColors.phase1 : AppColors.divider),
                ),
                child: Center(
                  child: Text(
                    '$setNumber',
                    style: TextStyle(
                      color: isDone ? AppColors.phase1 : AppColors.textSecondary,
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: '—',
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.phase1 : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDone ? AppColors.phase1 : AppColors.divider),
                  ),
                  child: Icon(
                    Icons.check,
                    color: isDone ? Colors.black : AppColors.textSecondary,
                    size: 20,
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

class _RestHint extends StatelessWidget {
  final int seconds;
  const _RestHint({required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.phase4Muted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.phase4),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: AppColors.phase4, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rest Period',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.phase4,
                        letterSpacing: 0.8,
                      ),
                ),
                Text(
                  '${seconds}s',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.phase4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
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
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onComplete;

  const _NavigationRow({
    required this.exerciseIndex,
    required this.total,
    required this.isLast,
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
                  backgroundColor: AppColors.phase1,
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
                foregroundColor: AppColors.phase1,
                side: const BorderSide(color: AppColors.phase1),
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
