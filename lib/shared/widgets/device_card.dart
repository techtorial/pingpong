import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../theme/app_theme.dart';

class DeviceCard extends StatelessWidget {
  final DiscoveredDevice device;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onConnect;

  const DeviceCard({
    super.key,
    required this.device,
    this.isSelected = false,
    this.onTap,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signalStrength = _getSignalStrength(device.rssi);
    final signalColor = _getSignalColor(signalStrength);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 8 : 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bluetooth,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name.isNotEmpty ? device.name : 'Unknown Device',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          device.id,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSignalIndicator(signalColor, signalStrength),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(
                    Icons.signal_cellular_alt,
                    size: 16,
                    color: signalColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${device.rssi} dBm',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: signalColor,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    ElevatedButton(
                      onPressed: onConnect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        minimumSize: const Size(100, 36),
                      ),
                      child: const Text('Connect'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalIndicator(Color color, int strength) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final isActive = index < strength;
        return Container(
          margin: const EdgeInsets.only(left: 2),
          width: 4,
          height: (index + 1) * 4.0,
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  int _getSignalStrength(int rssi) {
    if (rssi >= -50) return 4;
    if (rssi >= -60) return 3;
    if (rssi >= -70) return 2;
    if (rssi >= -80) return 1;
    return 0;
  }

  Color _getSignalColor(int strength) {
    switch (strength) {
      case 4:
        return AppColors.batteryHigh;
      case 3:
        return AppColors.batteryMedium;
      case 2:
        return AppColors.batteryLow;
      default:
        return Colors.grey;
    }
  }
}