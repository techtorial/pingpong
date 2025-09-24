abstract class RobotError implements Exception {
  final String message;
  final String? code;
  
  const RobotError(this.message, [this.code]);
  
  @override
  String toString() => 'RobotError: $message';
}

class BleConnectionError extends RobotError {
  const BleConnectionError(super.message, [super.code]);
}

class BleWriteError extends RobotError {
  const BleWriteError(super.message, [super.code]);
}

class BleReadError extends RobotError {
  const BleReadError(super.message, [super.code]);
}

class DeviceNotFoundError extends RobotError {
  const DeviceNotFoundError(super.message, [super.code]);
}

class PermissionDeniedError extends RobotError {
  const PermissionDeniedError(super.message, [super.code]);
}

class InvalidValueError extends RobotError {
  const InvalidValueError(super.message, [super.code]);
}

class SafetyError extends RobotError {
  const SafetyError(super.message, [super.code]);
}

class StorageError extends RobotError {
  const StorageError(super.message, [super.code]);
}