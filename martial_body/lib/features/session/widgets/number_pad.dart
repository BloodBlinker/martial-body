import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:martial_body/core/theme/app_colors.dart';

class CustomNumberPad extends StatefulWidget {
  final String initialValue;

  const CustomNumberPad({
    super.key,
    required this.initialValue,
  });

  static Future<String?> show(BuildContext context, String initialValue) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CustomNumberPad(initialValue: initialValue),
    );
  }

  @override
  State<CustomNumberPad> createState() => _CustomNumberPadState();
}

class _CustomNumberPadState extends State<CustomNumberPad> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  void _handleTap(String key) {
    HapticFeedback.lightImpact();
    if (key == 'DEL') {
      if (currentValue.isNotEmpty) {
        setState(() => currentValue = currentValue.substring(0, currentValue.length - 1));
      }
    } else if (key == 'DONE') {
      Navigator.of(context).pop(currentValue);
    } else if (key == '.') {
      if (!currentValue.contains('.')) {
        setState(() => currentValue = currentValue.isEmpty ? '0.' : '$currentValue.');
      }
    } else {
      // Limit to max 5 characters for weight/reps
      if (currentValue.length < 5) {
        if (currentValue == '0' && key != '.') {
          setState(() => currentValue = key);
        } else {
          setState(() => currentValue = currentValue + key);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(bottom: 32, top: 24, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: context.appColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentValue.isEmpty ? '0' : currentValue,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: context.appColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildKey(context, '1'),
              _buildKey(context, '2'),
              _buildKey(context, '3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildKey(context, '4'),
              _buildKey(context, '5'),
              _buildKey(context, '6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildKey(context, '7'),
              _buildKey(context, '8'),
              _buildKey(context, '9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildKey(context, '.', flex: 1),
              _buildKey(context, '0', flex: 1),
              _buildKey(context, 'DEL', flex: 1, color: context.appColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(currentValue);
                },
                child: const Text('DONE'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, String label, {int flex = 1, Color? color}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _handleTap(label),
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: label == 'DEL' 
                ? Icon(Icons.backspace, color: color ?? context.appColors.textPrimary)
                : Text(
                  label,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color ?? context.appColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
