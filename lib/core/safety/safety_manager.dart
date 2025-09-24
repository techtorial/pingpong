import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/robot_providers.dart';
import '../constants/app_constants.dart';
import '../errors/robot_errors.dart';

class SafetyManager {
  static Timer? _disconnectTimer;
  static Timer? _safetyCheckTimer;
  static bool _isEmergencyStopActive = false;

  /// Initialize safety monitoring
  static void initialize(WidgetRef ref) {
    _startSafetyMonitoring(ref);
  }

  /// Dispose safety monitoring
  static void dispose() {
    _disconnectTimer?.cancel();
    _safetyCheckTimer?.cancel();
  }

  /// Start safety monitoring
  static void _startSafetyMonitoring(WidgetRef ref) {
    _safetyCheckTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _performSafetyChecks(ref),
    );
  }

  /// Perform safety checks
  static void _performSafetyChecks(WidgetRef ref) {
    final robotState = ref.read(robotStateNotifierProvider);
    final isConnected = ref.read(connectionNotifierProvider);

    // Check for disconnection
    if (!isConnected && robotState.isFeeding) {
      _handleDisconnection(ref);
    }

    // Check for faults
    if (robotState.hasFault) {
      _handleFault(ref);
    }

    // Check for over-temperature
    if (robotState.isOverTemp) {
      _handleOverTemperature(ref);
    }

    // Check for low battery
    if (robotState.batteryLevel != null && robotState.batteryLevel! < 10) {
      _handleLowBattery(ref);
    }
  }

  /// Handle disconnection
  static void _handleDisconnection(WidgetRef ref) {
    if (_isEmergencyStopActive) return;

    _isEmergencyStopActive = true;
    
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      robotNotifier.emergencyStop();
      
      // Show disconnection alert
      _showSafetyAlert(
        'Connection Lost',
        'Robot connection lost. All motors have been stopped for safety.',
        AppColors.errorColor,
      );
    } catch (e) {
      // Handle error
    } finally {
      _isEmergencyStopActive = false;
    }
  }

  /// Handle fault condition
  static void _handleFault(WidgetRef ref) {
    if (_isEmergencyStopActive) return;

    _isEmergencyStopActive = true;
    
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      robotNotifier.emergencyStop();
      
      _showSafetyAlert(
        'Robot Fault',
        'Robot fault detected. All motors have been stopped for safety.',
        AppColors.errorColor,
      );
    } catch (e) {
      // Handle error
    } finally {
      _isEmergencyStopActive = false;
    }
  }

  /// Handle over-temperature condition
  static void _handleOverTemperature(WidgetRef ref) {
    if (_isEmergencyStopActive) return;

    _isEmergencyStopActive = true;
    
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      robotNotifier.emergencyStop();
      
      _showSafetyAlert(
        'Over Temperature',
        'Robot temperature too high. All motors have been stopped for safety.',
        AppColors.warningColor,
      );
    } catch (e) {
      // Handle error
    } finally {
      _isEmergencyStopActive = false;
    }
  }

  /// Handle low battery condition
  static void _handleLowBattery(WidgetRef ref) {
    _showSafetyAlert(
      'Low Battery',
      'Robot battery is low. Please charge the robot soon.',
      AppColors.warningColor,
    );
  }

  /// Show safety alert
  static void _showSafetyAlert(String title, String message, Color color) {
    // This would typically show a system alert or notification
    // For now, we'll just print to console
    print('SAFETY ALERT: $title - $message');
  }

  /// Emergency stop with immediate effect
  static Future<void> emergencyStop(WidgetRef ref) async {
    if (_isEmergencyStopActive) return;

    _isEmergencyStopActive = true;
    
    try {
      final robotNotifier = ref.read(robotStateNotifierProvider.notifier);
      await robotNotifier.emergencyStop();
      
      _showSafetyAlert(
        'Emergency Stop',
        'Emergency stop activated. All motors have been stopped.',
        AppColors.emergencyStop,
      );
    } catch (e) {
      // Handle error
    } finally {
      _isEmergencyStopActive = false;
    }
  }

  /// Check if emergency stop is active
  static bool get isEmergencyStopActive => _isEmergencyStopActive;

  /// Reset emergency stop state
  static void resetEmergencyStop() {
    _isEmergencyStopActive = false;
  }

  /// Validate control values for safety
  static bool validateControlValue(int value, String controlName) {
    if (value < AppConstants.minValue || value > AppConstants.maxValue) {
      throw InvalidValueError(
        '$controlName value $value is out of range (${AppConstants.minValue}-${AppConstants.maxValue})',
      );
    }
    return true;
  }

  /// Validate power on conditions
  static bool validatePowerOn(WidgetRef ref) {
    final robotState = ref.read(robotStateNotifierProvider);
    
    if (!robotState.isConnected) {
      throw SafetyError('Cannot power on - robot not connected');
    }
    
    if (robotState.hasFault) {
      throw SafetyError('Cannot power on - robot has fault');
    }
    
    if (robotState.isOverTemp) {
      throw SafetyError('Cannot power on - robot over temperature');
    }
    
    return true;
  }

  /// Validate feed start conditions
  static bool validateFeedStart(WidgetRef ref) {
    final robotState = ref.read(robotStateNotifierProvider);
    
    if (!robotState.isConnected) {
      throw SafetyError('Cannot start feed - robot not connected');
    }
    
    if (!robotState.isPowered) {
      throw SafetyError('Cannot start feed - robot not powered');
    }
    
    if (robotState.hasFault) {
      throw SafetyError('Cannot start feed - robot has fault');
    }
    
    if (robotState.isOverTemp) {
      throw SafetyError('Cannot start feed - robot over temperature');
    }
    
    return true;
  }
}