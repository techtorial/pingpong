import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ControlCard extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;
  final bool enabled;

  const ControlCard({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: enabled 
                    ? theme.colorScheme.onSurface 
                    : theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Value Display
            Center(
              child: Text(
                value.toString(),
                style: AppTextStyles.headlineLarge.copyWith(
                  color: enabled 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  context,
                  Icons.remove,
                  () => _decrement(),
                  enabled: enabled && value > min,
                ),
                _buildControlButton(
                  context,
                  Icons.add,
                  () => _increment(),
                  enabled: enabled && value < max,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Slider
            Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              onChanged: enabled ? (newValue) {
                onChanged?.call(newValue.round());
              } : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, {
    required bool enabled,
  }) {
    final theme = Theme.of(context);
    
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: enabled 
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface,
        foregroundColor: enabled 
            ? theme.colorScheme.primary 
            : theme.colorScheme.onSurface.withOpacity(0.3),
        minimumSize: const Size(48, 48),
      ),
    );
  }

  void _decrement() {
    if (value > min) {
      onChanged?.call(value - 1);
    }
  }

  void _increment() {
    if (value < max) {
      onChanged?.call(value + 1);
    }
  }
}