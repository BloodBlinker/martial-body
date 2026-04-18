import 'package:flutter/material.dart';

import '../../../core/meal_plans/meal_plan.dart';
import '../../../core/program/phase_math.dart';
import '../../../core/theme/app_colors.dart';

/// Renders a [MealPlan] — totals card, per-meal cards, optional deload note,
/// and an expandable prep-notes section. Pure presentation: the caller picks
/// the plan from the registry and passes it in.
class MealPlanView extends StatelessWidget {
  final MealPlan plan;
  final PhaseInfo phase;

  const MealPlanView({super.key, required this.plan, required this.phase});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MealPlanHeader(phase: phase),
        const SizedBox(height: 14),
        _MacroTotalsCard(totals: plan.totals),
        if (plan.deloadAdjustment != null) ...[
          const SizedBox(height: 12),
          _DeloadNote(text: plan.deloadAdjustment!),
        ],
        const SizedBox(height: 22),
        for (final meal in plan.meals) ...[
          _MealCard(meal: meal),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
        _PrepNotesSection(notes: plan.prepNotes),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _MealPlanHeader extends StatelessWidget {
  final PhaseInfo phase;
  const _MealPlanHeader({required this.phase});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.phaseColor(phase.number);
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withAlpha(22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.restaurant_menu, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PHASE ${phase.number} · ${phase.name.toUpperCase()}',
                style: tt.labelSmall?.copyWith(
                  color: color,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Meal plan',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _MacroTotalsCard extends StatelessWidget {
  final MacroTotals totals;
  const _MacroTotalsCard({required this.totals});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${totals.calories}',
                style: tt.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'kcal / day',
                  style: tt.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MacroPill(
                  label: 'PROTEIN',
                  value: '${totals.proteinG}g',
                  color: AppColors.phase1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroPill(
                  label: 'CARBS',
                  value: '${totals.carbsG}g',
                  color: AppColors.phase4,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MacroPill(
                  label: 'FAT',
                  value: '${totals.fatG}g',
                  color: AppColors.phase2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: tt.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _DeloadNote extends StatelessWidget {
  final String text;
  const _DeloadNote({required this.text});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.deloadMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.deload.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.waves, size: 16, color: AppColors.deload),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DELOAD ADJUSTMENT',
                  style: tt.labelSmall?.copyWith(
                    color: AppColors.deload,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
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

class _MealCard extends StatelessWidget {
  final Meal meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name.toUpperCase(),
                        style: tt.labelSmall?.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                        ),
                      ),
                      if (meal.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          meal.subtitle!,
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (meal.timeLabel != null)
                  Text(
                    meal.timeLabel!,
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          for (var i = 0; i < meal.items.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.divider),
            _MealItemRow(item: meal.items[i]),
          ],
        ],
      ),
    );
  }
}

class _MealItemRow extends StatelessWidget {
  final MealItem item;
  const _MealItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                item.amount,
                style: tt.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _ItemMacro(label: 'P', value: '${item.proteinG}g', color: AppColors.phase1),
              const SizedBox(width: 10),
              _ItemMacro(label: 'C', value: '${item.carbsG}g', color: AppColors.phase4),
              const SizedBox(width: 10),
              _ItemMacro(label: 'F', value: '${item.fatG}g', color: AppColors.phase2),
              const Spacer(),
              Text(
                '${item.calories} kcal',
                style: tt.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemMacro extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ItemMacro({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: tt.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _PrepNotesSection extends StatelessWidget {
  final List<PrepNote> notes;
  const _PrepNotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          iconColor: AppColors.gold,
          collapsedIconColor: AppColors.textSecondary,
          title: Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 18, color: AppColors.gold),
              const SizedBox(width: 10),
              Text(
                'Preparation notes',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: [
            for (var i = 0; i < notes.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _PrepNoteTile(note: notes[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrepNoteTile extends StatelessWidget {
  final PrepNote note;
  const _PrepNoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.category,
          style: tt.labelSmall?.copyWith(
            color: AppColors.gold,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          note.body,
          style: tt.bodySmall?.copyWith(
            color: AppColors.textPrimary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
