class AppConstants {
  // BLE Service and Characteristic UUIDs (placeholders - replace with actual UUIDs)
  static const String robotServiceUuid = '12345678-1234-1234-1234-123456789ABC';
  
  // Control Characteristics
  static const String frequencyCharUuid = '12345678-1234-1234-1234-123456789ABD';
  static const String oscillationCharUuid = '12345678-1234-1234-1234-123456789ABE';
  static const String topspinCharUuid = '12345678-1234-1234-1234-123456789ABF';
  static const String backspinCharUuid = '12345678-1234-1234-1234-123456789AC0';
  static const String powerCharUuid = '12345678-1234-1234-1234-123456789AC1';
  static const String feedCharUuid = '12345678-1234-1234-1234-123456789AC2';
  static const String estopCharUuid = '12345678-1234-1234-1234-123456789AC3';
  
  // Status Characteristics
  static const String statusCharUuid = '12345678-1234-1234-1234-123456789AC4';
  static const String batteryCharUuid = '12345678-1234-1234-1234-123456789AC5';
  
  // Device Configuration
  static const String deviceNamePrefix = 'TABLE TENNIS ROBOT';
  static const Duration scanTimeout = Duration(seconds: 10);
  static const Duration connectionTimeout = Duration(seconds: 5);
  static const Duration autoReconnectDelay = Duration(seconds: 5);
  
  // Control Ranges
  static const int minValue = 0;
  static const int maxValue = 20;
  static const int defaultStepSize = 1;
  static const int emergencyStopDelayMs = 100;
  static const int controlUpdateDelayMs = 200;
  
  // Safety
  static const Duration armDelay = Duration(seconds: 3);
  static const Duration disconnectTimeout = Duration(seconds: 30);
  
  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double buttonMinSize = 48.0;
  static const double cardElevation = 4.0;
  
  // Storage
  static const String databaseName = 'table_tennis_robot.db';
  static const int databaseVersion = 1;
  
  // Audio
  static const String countdownSoundPath = 'sounds/countdown.mp3';
  static const String beepSoundPath = 'sounds/beep.mp3';
  static const String errorSoundPath = 'sounds/error.mp3';
  
  // Haptic Feedback
  static const int lightHapticIntensity = 1;
  static const int mediumHapticIntensity = 2;
  static const int heavyHapticIntensity = 3;
}