import 'dart:async';
import 'dart:math';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/robot_errors.dart';
import '../../models/robot_state.dart';

abstract class RobotBleInterface {
  Stream<RobotState> get robotStateStream;
  Stream<bool> get connectionStream;
  Stream<String> get errorStream;
  
  Future<void> initialize();
  Future<void> dispose();
  Future<void> startScanning();
  Future<void> stopScanning();
  Future<void> connectToDevice(String deviceId);
  Future<void> disconnect();
  Future<void> writeFrequency(int value);
  Future<void> writeOscillation(int value);
  Future<void> writeTopspin(int value);
  Future<void> writeBackspin(int value);
  Future<void> writePower(bool isOn);
  Future<void> writeFeed(bool isFeeding);
  Future<void> emergencyStop();
  Future<List<DiscoveredDevice>> get discoveredDevices;
}

class RobotBleService implements RobotBleInterface {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  
  final StreamController<RobotState> _robotStateController = StreamController<RobotState>.broadcast();
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();
  final StreamController<String> _errorController = StreamController<String>.broadcast();
  
  RobotState _currentState = const RobotState();
  String? _connectedDeviceId;
  bool _isScanning = false;
  Timer? _mockUpdateTimer;
  final Random _random = Random();
  
  @override
  Stream<RobotState> get robotStateStream => _robotStateController.stream;
  
  @override
  Stream<bool> get connectionStream => _connectionController.stream;
  
  @override
  Stream<String> get errorStream => _errorController.stream;
  
  @override
  Future<void> initialize() async {
    // Initialize BLE service
    _startMockUpdates();
  }
  
  @override
  Future<void> dispose() async {
    await _mockUpdateTimer?.cancel();
    await _robotStateController.close();
    await _connectionController.close();
    await _errorController.close();
  }
  
  @override
  Future<void> startScanning() async {
    if (_isScanning) return;
    
    _isScanning = true;
    
    try {
      await _ble.startScan(
        withServices: [Uuid.parse(AppConstants.robotServiceUuid)],
        scanMode: ScanMode.lowLatency,
        requireLocationServicesEnabled: false,
      );
    } catch (e) {
      _errorController.add('Failed to start scanning: $e');
    }
  }
  
  @override
  Future<void> stopScanning() async {
    if (!_isScanning) return;
    
    _isScanning = false;
    await _ble.stopScan();
  }
  
  @override
  Future<void> connectToDevice(String deviceId) async {
    try {
      _connectedDeviceId = deviceId;
      _currentState = _currentState.copyWith(
        isConnected: true,
        deviceId: deviceId,
        lastSeen: DateTime.now(),
      );
      _connectionController.add(true);
      _robotStateController.add(_currentState);
    } catch (e) {
      _errorController.add('Failed to connect: $e');
    }
  }
  
  @override
  Future<void> disconnect() async {
    _connectedDeviceId = null;
    _currentState = _currentState.copyWith(isConnected: false);
    _connectionController.add(false);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> writeFrequency(int value) async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    if (value < AppConstants.minValue || value > AppConstants.maxValue) {
      throw const InvalidValueError('Frequency value out of range');
    }
    
    await _simulateWriteDelay();
    _currentState = _currentState.copyWith(frequency: value);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> writeOscillation(int value) async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    if (value < AppConstants.minValue || value > AppConstants.maxValue) {
      throw const InvalidValueError('Oscillation value out of range');
    }
    
    await _simulateWriteDelay();
    _currentState = _currentState.copyWith(oscillation: value);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> writeTopspin(int value) async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    if (value < AppConstants.minValue || value > AppConstants.maxValue) {
      throw const InvalidValueError('Topspin value out of range');
    }
    
    // Enforce mutual exclusivity with backspin
    if (value > 0) {
      _currentState = _currentState.copyWith(backspin: 0);
    }
    
    await _simulateWriteDelay();
    _currentState = _currentState.copyWith(topspin: value);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> writeBackspin(int value) async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    if (value < AppConstants.minValue || value > AppConstants.maxValue) {
      throw const InvalidValueError('Backspin value out of range');
    }
    
    // Enforce mutual exclusivity with topspin
    if (value > 0) {
      _currentState = _currentState.copyWith(topspin: 0);
    }
    
    await _simulateWriteDelay();
    _currentState = _currentState.copyWith(backspin: value);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> writePower(bool isOn) async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    await _simulateWriteDelay();
    _currentState = _currentState.copyWith(isPowered: isOn);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> writeFeed(bool isFeeding) async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    if (!_currentState.isPowered) {
      throw const SafetyError('Cannot start feeding - robot is not powered');
    }
    
    await _simulateWriteDelay();
    _currentState = _currentState.copyWith(isFeeding: isFeeding);
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<void> emergencyStop() async {
    if (!_currentState.isConnected) {
      throw const BleConnectionError('Not connected to device');
    }
    
    // Emergency stop should be immediate
    _currentState = _currentState.copyWith(
      isFeeding: false,
      isPowered: false,
    );
    _robotStateController.add(_currentState);
  }
  
  @override
  Future<List<DiscoveredDevice>> get discoveredDevices async {
    // In mock mode, return simulated devices
    return [
      DiscoveredDevice(
        id: 'mock-device-1',
        name: AppConstants.deviceNamePrefix,
        rssi: -50,
        serviceData: {},
        manufacturerData: Uint8List(0),
        serviceUuids: [AppConstants.robotServiceUuid],
      ),
    ];
  }
  
  void _startMockUpdates() {
    _mockUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentState.isConnected) {
        // Simulate battery level changes
        final batteryLevel = _random.nextInt(20) + 80; // 80-100%
        
        // Simulate signal strength changes
        final signalStrength = _random.nextInt(20) + 80; // 80-100%
        
        _currentState = _currentState.copyWith(
          batteryLevel: batteryLevel,
          signalStrength: signalStrength,
          lastSeen: DateTime.now(),
        );
        _robotStateController.add(_currentState);
      }
    });
  }
  
  Future<void> _simulateWriteDelay() async {
    // Simulate BLE write delay
    await Future.delayed(const Duration(milliseconds: 50));
  }
}