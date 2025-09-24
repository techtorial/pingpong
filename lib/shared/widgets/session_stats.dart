import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SessionStats extends StatelessWidget {
  final int ballsThrown;
  final bool isFeeding;
  final String? drillName;

  const SessionStats({
    super.key,
    required this.ballsThrown,
    required this.isFeeding,
    this.drillName,
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
            Row(
              children: [
                Icon(
                  Icons.sports_tennis,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Session Stats',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Balls Thrown',
                    ballsThrown.toString(),
                    Icons.sports_tennis,
                    AppColors.successColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Status',
                    isFeeding ? 'Feeding' : 'Stopped',
                    isFeeding ? Icons.play_arrow : Icons.pause,
                    isFeeding ? AppColors.feeding : AppColors.disconnected,
                  ),
                ),
              ],
            ),
            
            if (drillName != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.timeline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Drill: $drillName',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}