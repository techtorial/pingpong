import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/robot_providers.dart';
import '../constants/app_constants.dart';

class AutoDisconnectHandler {
  static Timer? _disconnectTimer;
  static bool _isMonitoring = false;

  /// Start monitoring for disconnection
  static void startMonitoring(WidgetRef ref) {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _disconnectTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _checkConnection(ref),
    );
  }

  /// Stop monitoring for disconnection
  static void stopMonitoring() {
    _isMonitoring = false;
    _disconnectTimer?.cancel();
  }

  /// Check connection status
  static void _checkConnection(WidgetRef ref) {
    final isConnected = ref.read(connectionNotifierProvider);
    final robotState = ref.read(robotStateNotifierProvider);
    
    if (!isConnected && robotState.isFeeding) {
      _handleDisconnection(ref);
    }
  }

  /// Handle disconnection
  static void _handleDisconnection(WidgetRef ref) {
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      robotNotifier.emergencyStop();
      
      // Show disconnection notification
      _showDisconnectionNotification();
    } catch (e) {
      // Handle error
    }
  }

  /// Show disconnection notification
  static void _showDisconnectionNotification() {
    // This would typically show a system notification
    // For now, we'll just print to console
    print('DISCONNECTION: Robot disconnected, feed stopped for safety');
  }

  /// Reset connection monitoring
  static void reset() {
    stopMonitoring();
  }
}