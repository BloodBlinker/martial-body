import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/database/database.dart';
import '../../core/export/csv_exporter.dart';
import '../../core/models/health_metrics.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/theme/app_colors.dart';

/// Public URL of the hosted privacy policy — shown on the Profile tab and
/// referenced from Play Console. Update to the real GitHub Pages URL when
/// published.
const String kPrivacyPolicyUrl =
    'https://bloodblinker.github.io/martial-body/privacy.html';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(userProfileProvider);
    return async.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Error: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
      data: (profile) => _ProfileBody(profile: profile),
    );
  }
}

// ---------------------------------------------------------------------------

class _ProfileBody extends ConsumerStatefulWidget {
  final UserProfile? profile;
  const _ProfileBody({required this.profile});

  @override
  ConsumerState<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends ConsumerState<_ProfileBody> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _age;
  late final TextEditingController _weight;
  late final TextEditingController _height;
  String? _sex; // 'male' | 'female'

  bool _dirty = false;
  bool _saving = false;

  // Drop trailing ".0" on whole numbers so "72.0" renders as "72".
  static String _numStr(num? v) {
    if (v == null) return '';
    if (v is int) return v.toString();
    final d = v.toDouble();
    return d % 1 == 0 ? d.toInt().toString() : d.toString();
  }

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _name = TextEditingController(text: p?.name ?? '');
    _age = TextEditingController(text: _numStr(p?.age));
    _weight = TextEditingController(text: _numStr(p?.weightKg));
    _height = TextEditingController(text: _numStr(p?.heightCm));
    _sex = p?.sex;
  }

  @override
  void didUpdateWidget(covariant _ProfileBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the underlying stream emits a fresh profile (e.g. saved here, or
    // modified elsewhere), update controllers — but only if the user hasn't
    // edited locally since the last save, to avoid clobbering in-progress
    // edits.
    if (_dirty || _saving) return;
    final p = widget.profile;
    _syncIfDifferent(_name, p?.name ?? '');
    _syncIfDifferent(_age, _numStr(p?.age));
    _syncIfDifferent(_weight, _numStr(p?.weightKg));
    _syncIfDifferent(_height, _numStr(p?.heightCm));
    if (_sex != p?.sex) {
      _sex = p?.sex;
    }
  }

  void _syncIfDifferent(TextEditingController c, String next) {
    if (c.text != next) c.text = next;
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  HealthMetrics? get _metrics => HealthMetrics.compute(
        age: int.tryParse(_age.text),
        sex: _sex,
        weightKg: double.tryParse(_weight.text),
        heightCm: double.tryParse(_height.text),
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final db = ref.read(databaseProvider);
      await db.userProfileDao.upsertProfile(
        name: _name.text.trim().isEmpty ? null : _name.text.trim(),
        age: int.tryParse(_age.text),
        sex: _sex,
        weightKg: double.tryParse(_weight.text),
        heightCm: double.tryParse(_height.text),
      );
      if (mounted) {
        setState(() => _dirty = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save: $e')),
        );
      }
    } finally {
      // Always release the spinner — otherwise a thrown upsert leaves Save
      // disabled forever and the user has to kill the app.
      if (mounted) setState(() => _saving = false);
    }
  }

  // Called on every keystroke; only rebuild the first time the form becomes
  // dirty so subsequent keystrokes stay cheap (setState would otherwise
  // rebuild the whole Profile tab on each character).
  void _markDirty() {
    if (_dirty) return;
    setState(() => _dirty = true);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: _markDirty,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  children: [
                    _SectionLabel('PERSONAL DETAILS'),
                    const SizedBox(height: 12),
                    _InputCard(children: [
                      _FieldRow(
                        label: 'Name',
                        child: TextFormField(
                          controller: _name,
                          style: _inputStyle,
                          decoration: _inputDeco('e.g. Alex'),
                        ),
                      ),
                      _divider(),
                      _FieldRow(
                        label: 'Age',
                        child: TextFormField(
                          controller: _age,
                          keyboardType: TextInputType.number,
                          style: _inputStyle,
                          decoration: _inputDeco('years'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            final n = int.tryParse(v);
                            if (n == null || n < 10 || n > 100) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      _divider(),
                      _FieldRow(
                        label: 'Sex',
                        child: _SexToggle(
                          value: _sex,
                          onChanged: (v) => setState(() {
                            _sex = v;
                            _markDirty();
                          }),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _SectionLabel('BODY METRICS'),
                    const SizedBox(height: 12),
                    _InputCard(children: [
                      _FieldRow(
                        label: 'Weight',
                        child: TextFormField(
                          controller: _weight,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: _inputStyle,
                          decoration: _inputDeco('kg'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            final n = double.tryParse(v);
                            if (n == null || n < 30 || n > 300) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      _divider(),
                      _FieldRow(
                        label: 'Height',
                        child: TextFormField(
                          controller: _height,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: _inputStyle,
                          decoration: _inputDeco('cm'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            final n = double.tryParse(v);
                            if (n == null || n < 100 || n > 250) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                    ]),
                    if (metrics != null) ...[
                      const SizedBox(height: 28),
                      _SectionLabel('HEALTH CALCULATIONS'),
                      const SizedBox(height: 12),
                      _HealthPanel(metrics: metrics),
                    ],
                    const SizedBox(height: 28),
                    if (_dirty)
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.phase1,
                          foregroundColor: AppColors.background,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.background,
                                ),
                              )
                            : const Text('Save Profile',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    const SizedBox(height: 28),
                    _SectionLabel('DATA & PRIVACY'),
                    const SizedBox(height: 12),
                    _InputCard(children: [
                      _ActionRow(
                        icon: Icons.download,
                        label: 'Export workout log (CSV)',
                        onTap: _exportCsv,
                      ),
                      _divider(),
                      _ActionRow(
                        icon: Icons.event,
                        label: 'Shift program start date',
                        onTap: _shiftStartDate,
                      ),
                      _divider(),
                      _ActionRow(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy policy',
                        onTap: _openPrivacyPolicy,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Martial Body · v1.0.0',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary.withAlpha(140),
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportCsv() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final path =
          await CsvExporter(ref.read(databaseProvider)).exportAll();
      await Share.shareXFiles(
        [XFile(path, mimeType: 'text/csv', name: 'martial_body_log.csv')],
        text: 'Martial Body workout log',
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  Future<void> _shiftStartDate() async {
    final db = ref.read(databaseProvider);
    final current = (await db.userDao.getUserState())?.programStartDate ??
        DateTime.now();
    if (!mounted) return;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      // A program start can only have been in the past. Cap "future" to
      // today so users don't accidentally set week 1 to next month.
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Shift start date?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'This will recompute the current week (and phase) from '
          '${picked.toIso8601String().split('T').first}. Existing workout '
          'logs keep their original week numbers.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.gold),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await db.userDao.updateProgramStartDate(picked);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Start date updated')),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final ok = await launchUrl(
      Uri.parse(kPrivacyPolicyUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open privacy policy')),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Text(
        'Profile',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  static const TextStyle _inputStyle =
      TextStyle(color: AppColors.textPrimary, fontSize: 15);

  static InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      );

  static Widget _divider() => const Divider(
        color: AppColors.divider,
        height: 1,
        thickness: 1,
      );
}

// ---------------------------------------------------------------------------

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final List<Widget> children;
  const _InputCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: children),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SexToggle extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const _SexToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(label: 'Male', selected: value == 'male', onTap: () => onChanged('male')),
        const SizedBox(width: 8),
        _Chip(label: 'Female', selected: value == 'female', onTap: () => onChanged('female')),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.phase1Muted : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.phase1 : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.phase1 : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _HealthPanel extends StatelessWidget {
  final HealthMetrics metrics;
  const _HealthPanel({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetricCard(
          icon: Icons.monitor_weight_outlined,
          title: 'Body Composition',
          rows: [
            _MetricRow('BMI', '${metrics.bmi.toStringAsFixed(1)}  ·  ${metrics.bmiCategory}'),
            _MetricRow('Body Fat', '${metrics.bodyFatPercent.toStringAsFixed(1)} %'),
            _MetricRow('Lean Mass', '${metrics.leanBodyMass.toStringAsFixed(1)} kg'),
          ],
        ),
        const SizedBox(height: 12),
        _MetricCard(
          icon: Icons.local_fire_department_outlined,
          title: 'Energy',
          rows: [
            _MetricRow('BMR', '${metrics.bmr.round()} kcal / day'),
            _MetricRow('TDEE', '${metrics.tdee.round()} kcal / day'),
          ],
        ),
        const SizedBox(height: 12),
        _MetricCard(
          icon: Icons.fitness_center_outlined,
          title: 'Performance Targets',
          rows: [
            _MetricRow('Ideal Weight',
                '${metrics.idealWeightMin.toStringAsFixed(1)} – ${metrics.idealWeightMax.toStringAsFixed(1)} kg'),
            _MetricRow('Daily Protein', '${metrics.proteinTargetG} g'),
            _MetricRow('Max Heart Rate', '${metrics.maxHeartRate} bpm'),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<_MetricRow> rows;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.phase1, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...rows.map((r) => _buildRow(context, r)),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, _MetricRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            row.label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            row.value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow {
  final String label;
  final String value;
  const _MetricRow(this.label, this.value);
}
