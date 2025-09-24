import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PowerToggle extends StatelessWidget {
  final bool isPowered;
  final VoidCallback? onToggle;

  const PowerToggle({
    super.key,
    required this.isPowered,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              isPowered ? Icons.power : Icons.power_off,
              size: 48,
              color: isPowered ? AppColors.powerOn : AppColors.powerOff,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              isPowered ? 'POWER ON' : 'POWER OFF',
              style: AppTextStyles.titleLarge.copyWith(
                color: isPowered ? AppColors.powerOn : AppColors.powerOff,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Switch(
              value: isPowered,
              onChanged: onToggle != null ? (_) => onToggle!() : null,
              activeColor: AppColors.powerOn,
              inactiveThumbColor: AppColors.powerOff,
            ),
          ],
        ),
      ),
    );
  }
}