import 'package:flutter/material.dart';
import '../../models/robot_state.dart';
import '../theme/app_theme.dart';

class ConnectionStatus extends StatelessWidget {
  final bool isConnected;
  final RobotState robotState;

  const ConnectionStatus({
    super.key,
    required this.isConnected,
    required this.robotState,
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
                  isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                  color: isConnected ? AppColors.connected : AppColors.disconnected,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isConnected ? AppColors.connected : AppColors.disconnected,
                  ),
                ),
                const Spacer(),
                if (isConnected && robotState.deviceName != null)
                  Text(
                    robotState.deviceName!,
                    style: theme.textTheme.bodyMedium,
                  ),
              ],
            ),
            
            if (isConnected) ...[
              const SizedBox(height: 12),
              _buildStatusRow(
                context,
                'Power',
                robotState.isPowered ? 'ON' : 'OFF',
                robotState.isPowered ? AppColors.powerOn : AppColors.powerOff,
              ),
              _buildStatusRow(
                context,
                'Feeding',
                robotState.isFeeding ? 'ACTIVE' : 'STOPPED',
                robotState.isFeeding ? AppColors.feeding : AppColors.disconnected,
              ),
              if (robotState.batteryLevel != null)
                _buildStatusRow(
                  context,
                  'Battery',
                  '${robotState.batteryLevel}%',
                  _getBatteryColor(robotState.batteryLevel!),
                ),
              if (robotState.signalStrength != null)
                _buildStatusRow(
                  context,
                  'Signal',
                  '${robotState.signalStrength} dBm',
                  _getSignalColor(robotState.signalStrength!),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBatteryColor(int batteryLevel) {
    if (batteryLevel >= 80) return AppColors.batteryHigh;
    if (batteryLevel >= 50) return AppColors.batteryMedium;
    return AppColors.batteryLow;
  }

  Color _getSignalColor(int signalStrength) {
    if (signalStrength >= -50) return AppColors.batteryHigh;
    if (signalStrength >= -70) return AppColors.batteryMedium;
    return AppColors.batteryLow;
  }
}