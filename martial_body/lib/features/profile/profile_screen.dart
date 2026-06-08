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
import 'package:share_plus/share_plus.dart';

import '../../core/database/database.dart';
import '../../core/export/csv_exporter.dart';
import '../../core/models/health_metrics.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/units_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/utils/units.dart';
import 'package:martial_body/core/theme/app_colors.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(userProfileProvider);
    return async.when(
      loading: () => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(child: CircularProgressIndicator(color: context.appColors.gold)),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(
          child: Text('Error: $e',
              style: TextStyle(color: context.appColors.textSecondary)),
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

  // The unit the weight/height fields are currently displayed in. Kept in sync
  // with the global preference; flipping it reconverts the field contents.
  late UnitSystem _unit;

  // Drop trailing ".0" on whole numbers so "72.0" renders as "72".
  static String _numStr(num? v) {
    if (v == null) return '';
    if (v is int) return v.toString();
    final d = v.toDouble();
    return d % 1 == 0 ? d.toInt().toString() : d.toString();
  }

  // ── Display-unit helpers (storage is always kg/cm) ──
  String _weightDisplay(double? kg) =>
      kg == null ? '' : Units.weightValue(kg, _unit);
  String _heightDisplay(double? cm) => cm == null
      ? ''
      : (_unit == UnitSystem.imperial
          ? Units.cmToIn(cm).round().toString()
          : _numStr(cm));

  double? _weightTextToKg() {
    final v = double.tryParse(_weight.text);
    return v == null ? null : Units.toKg(v, _unit);
  }

  double? _heightTextToCm() {
    final v = double.tryParse(_height.text);
    if (v == null) return null;
    return _unit == UnitSystem.imperial ? Units.inToCm(v) : v;
  }

  @override
  void initState() {
    super.initState();
    _unit = ref.read(unitSystemProvider);
    final p = widget.profile;
    _name = TextEditingController(text: p?.name ?? '');
    _age = TextEditingController(text: _numStr(p?.age));
    _weight = TextEditingController(text: _weightDisplay(p?.weightKg));
    _height = TextEditingController(text: _heightDisplay(p?.heightCm));
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
    _syncIfDifferent(_weight, _weightDisplay(p?.weightKg));
    _syncIfDifferent(_height, _heightDisplay(p?.heightCm));
    if (_sex != p?.sex) {
      _sex = p?.sex;
    }
  }

  void _syncIfDifferent(TextEditingController c, String next) {
    if (c.text != next) c.text = next;
  }

  /// Reconvert the weight/height field contents when the unit preference flips
  /// (the toggle lives on this same screen).
  void _onUnitChanged(UnitSystem next) {
    if (next == _unit) return;
    final kg = _weightTextToKg();
    final cm = _heightTextToCm();
    _unit = next;
    _weight.text = _weightDisplay(kg);
    _height.text = _heightDisplay(cm);
    setState(() {});
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
        weightKg: _weightTextToKg(),
        heightCm: _heightTextToCm(),
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
        weightKg: _weightTextToKg(),
        heightCm: _heightTextToCm(),
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
    // Reconvert fields if the unit preference flips while we're on this screen.
    ref.listen<UnitSystem>(unitSystemProvider, (_, next) => _onUnitChanged(next));
    final unit = ref.watch(unitSystemProvider);
    final metrics = _metrics;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: context.appColors.surface,
            title: Text('Unsaved changes',
                style: TextStyle(color: context.appColors.textPrimary)),
            content: Text(
              'You have unsaved changes. Leave without saving?',
              style: TextStyle(color: context.appColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: TextButton.styleFrom(foregroundColor: context.appColors.error),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        if (leave == true && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
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
                          decoration: _inputDeco(Units.weightUnit(unit)),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            final n = double.tryParse(v);
                            if (n == null) return 'Invalid';
                            final kg = Units.toKg(n, unit);
                            if (kg < 30 || kg > 300) return 'Invalid';
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
                          decoration:
                              _inputDeco(unit == UnitSystem.imperial ? 'in' : 'cm'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return null;
                            final n = double.tryParse(v);
                            if (n == null) return 'Invalid';
                            final cm =
                                unit == UnitSystem.imperial ? Units.inToCm(n) : n;
                            if (cm < 100 || cm > 250) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                    ]),
                    if (metrics != null) ...[
                      const SizedBox(height: 28),
                      _SectionLabel('HEALTH CALCULATIONS'),
                      const SizedBox(height: 12),
                      _HealthPanel(metrics: metrics, unit: unit),
                    ],
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: (_dirty && !_saving) ? _save : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: context.appColors.phase1,
                        foregroundColor: context.appColors.background,
                        disabledBackgroundColor: context.appColors.surfaceVariant,
                        disabledForegroundColor: context.appColors.textSecondary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _saving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.appColors.background,
                              ),
                            )
                          : const Text('Save Profile',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 28),
                    _SectionLabel('APPEARANCE'),
                    const SizedBox(height: 12),
                    _InputCard(children: [
                      _ThemeToggleRow(
                        isDark: isDark,
                        onChanged: (_) {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                      ),
                      _divider(),
                      _UnitsRow(
                        unit: unit,
                        onChanged: (u) =>
                            ref.read(unitSystemProvider.notifier).set(u),
                      ),
                    ]),
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
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy policy',
                        onTap: _openPrivacyPolicy,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Martial Body · v2.0.0',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.appColors.textSecondary,
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
          ),
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

  Future<void> _openPrivacyPolicy() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appColors.surface,
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: context.appColors.textPrimary),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Updated: May 2026',
                  style: TextStyle(color: context.appColors.textSecondary, fontSize: 12),
                ),
                SizedBox(height: 16),
                _PolicySection(
                  title: 'Overview',
                  body: 'Martial Body is an offline-first workout tracking '
                      'application. Your data is stored exclusively on your '
                      'device. We do not collect, transmit, or share any '
                      'personal information.',
                ),
                _PolicySection(
                  title: 'Data Storage',
                  body: 'All workout logs, profile information, and preferences '
                      'are stored in a local database on your device. No data '
                      'is sent to external servers.',
                ),
                _PolicySection(
                  title: 'Permissions',
                  body: 'The app may request permission to keep the screen awake '
                      'during active workout sessions and to share exported CSV '
                      'files. No internet permission is required.',
                ),
                _PolicySection(
                  title: 'Data Export',
                  body: 'You can export your workout data as a CSV file via the '
                      'Profile screen. Exported files are shared through your '
                      'device\u2019s native share mechanism.',
                ),
                _PolicySection(
                  title: 'Third-Party Services',
                  body: 'Martial Body does not integrate with any third-party '
                      'analytics, advertising, or tracking services.',
                ),
                _PolicySection(
                  title: 'Contact',
                  body: 'For questions or concerns about this policy, '
                      'contact robinroy3107@gmail.com.',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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

  TextStyle get _inputStyle =>
      TextStyle(color: context.appColors.textPrimary, fontSize: 15);

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.appColors.textSecondary, fontSize: 14),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      );

  Widget _divider() => Divider(
        color: context.appColors.divider,
        height: 1,
        thickness: 1,
      );
}

// ---------------------------------------------------------------------------

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;
  const _PolicySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
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
            Icon(icon, color: context.appColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: context.appColors.textPrimary),
              ),
            ),
            Icon(Icons.chevron_right,
                color: context.appColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleRow extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  const _ThemeToggleRow({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: context.appColors.textSecondary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isDark ? 'Dark theme' : 'Light theme',
              style: TextStyle(color: context.appColors.textPrimary),
            ),
          ),
          Switch(
            value: isDark,
            onChanged: onChanged,
            // Defaults to colorScheme.primary (gold), matching the app accent.
          ),
        ],
      ),
    );
  }
}

class _UnitsRow extends StatelessWidget {
  final UnitSystem unit;
  final ValueChanged<UnitSystem> onChanged;
  const _UnitsRow({required this.unit, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.straighten, color: context.appColors.textSecondary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Units', style: TextStyle(color: context.appColors.textPrimary)),
          ),
          _UnitChip(
            label: 'kg / cm',
            selected: unit == UnitSystem.metric,
            onTap: () => onChanged(UnitSystem.metric),
          ),
          const SizedBox(width: 8),
          _UnitChip(
            label: 'lb / in',
            selected: unit == UnitSystem.imperial,
            onTap: () => onChanged(UnitSystem.imperial),
          ),
        ],
      ),
    );
  }
}

class _UnitChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _UnitChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? context.appColors.phase1Muted
              : context.appColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? context.appColors.phase1 : context.appColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? context.appColors.phase1
                : context.appColors.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
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
            color: context.appColors.textSecondary,
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
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
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
                  ?.copyWith(color: context.appColors.textSecondary),
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
          color: selected ? context.appColors.phase1Muted : context.appColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? context.appColors.phase1 : context.appColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? context.appColors.phase1 : context.appColors.textSecondary,
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
  final UnitSystem unit;
  const _HealthPanel({required this.metrics, required this.unit});

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
            _MetricRow('Lean Mass', Units.weight(metrics.leanBodyMass, unit)),
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
                '${Units.weightValue(metrics.idealWeightMin, unit)} – ${Units.weight(metrics.idealWeightMax, unit)}'),
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
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: context.appColors.phase1, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.appColors.textPrimary,
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
                ?.copyWith(color: context.appColors.textSecondary),
          ),
          Text(
            row.value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textPrimary,
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
