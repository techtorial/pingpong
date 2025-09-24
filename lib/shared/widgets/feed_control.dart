import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeedControl extends StatelessWidget {
  final bool isFeeding;
  final bool isArming;
  final int countdown;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final bool enabled;

  const FeedControl({
    super.key,
    required this.isFeeding,
    required this.isArming,
    required this.countdown,
    this.onStart,
    this.onStop,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Status Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFeeding ? Icons.play_arrow : Icons.pause,
                  size: 32,
                  color: isFeeding ? AppColors.feeding : AppColors.disconnected,
                ),
                const SizedBox(width: 12),
                Text(
                  isFeeding ? 'FEEDING' : 'STOPPED',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isFeeding ? AppColors.feeding : AppColors.disconnected,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            // Countdown Display
            if (isArming) ...[
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warningColor.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.warningColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    countdown.toString(),
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Starting in...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.warningColor,
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: enabled && !isFeeding && !isArming ? onStart : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Feed'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.feeding,
                      side: const BorderSide(color: AppColors.feeding),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: enabled && (isFeeding || isArming) ? onStop : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Feed'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.disconnected,
                      side: const BorderSide(color: AppColors.disconnected),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}