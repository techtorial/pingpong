import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SessionTimer extends StatelessWidget {
  final DateTime startTime;
  final bool isActive;

  const SessionTimer({
    super.key,
    required this.startTime,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = DateTime.now().difference(startTime);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isActive ? Icons.timer : Icons.timer_off,
                  color: isActive ? AppColors.successColor : AppColors.disconnected,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  isActive ? 'SESSION ACTIVE' : 'SESSION PAUSED',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isActive ? AppColors.successColor : AppColors.disconnected,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Timer Display
            Text(
              _formatDuration(duration),
              style: AppTextStyles.headlineLarge.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Session Duration',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}