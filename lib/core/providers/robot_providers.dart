import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../services/ble/robot_ble_interface.dart';
import '../../models/robot_state.dart';
import '../../models/preset.dart';
import '../../models/drill.dart';
import '../../models/session.dart';
import '../../services/storage/storage_service.dart';
import '../../services/storage/sqlite_storage_service.dart';

part 'robot_providers.g.dart';

// BLE Service Provider
@riverpod
RobotBleInterface robotBleService(RobotBleServiceRef ref) {
  final service = RobotBleService();
  ref.onDispose(() => service.dispose());
  return service;
}

// Storage Service Provider
@riverpod
StorageService storageService(StorageServiceRef ref) {
  final service = SqliteStorageService();
  ref.onDispose(() => service.dispose());
  return service;
}

// Robot State Provider
@riverpod
class RobotStateNotifier extends _$RobotStateNotifier {
  @override
  RobotState build() {
    final bleService = ref.watch(robotBleServiceProvider);
    
    // Listen to BLE state changes
    ref.listen(robotBleServiceProvider, (previous, next) {
      next.robotStateStream.listen((state) {
        state = state;
      });
    });
    
    return const RobotState();
  }
  
  Future<void> updateFrequency(int value) async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.writeFrequency(value);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> updateOscillation(int value) async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.writeOscillation(value);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> updateTopspin(int value) async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.writeTopspin(value);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> updateBackspin(int value) async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.writeBackspin(value);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> togglePower() async {
    final bleService = ref.read(robotBleServiceProvider);
    final currentState = state;
    try {
      await bleService.writePower(!currentState.isPowered);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> toggleFeed() async {
    final bleService = ref.read(robotBleServiceProvider);
    final currentState = state;
    try {
      await bleService.writeFeed(!currentState.isFeeding);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> emergencyStop() async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.emergencyStop();
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> applyPreset(Preset preset) async {
    await updateFrequency(preset.frequency);
    await updateOscillation(preset.oscillation);
    await updateTopspin(preset.topspin);
    await updateBackspin(preset.backspin);
  }
}

// Presets Provider
@riverpod
class PresetsNotifier extends _$PresetsNotifier {
  @override
  Future<List<Preset>> build() async {
    final storageService = ref.watch(storageServiceProvider);
    return await storageService.getAllPresets();
  }
  
  Future<void> addPreset(Preset preset) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.savePreset(preset);
    ref.invalidateSelf();
  }
  
  Future<void> updatePreset(Preset preset) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.updatePreset(preset);
    ref.invalidateSelf();
  }
  
  Future<void> deletePreset(String presetId) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.deletePreset(presetId);
    ref.invalidateSelf();
  }
}

// Drills Provider
@riverpod
class DrillsNotifier extends _$DrillsNotifier {
  @override
  Future<List<Drill>> build() async {
    final storageService = ref.watch(storageServiceProvider);
    return await storageService.getAllDrills();
  }
  
  Future<void> addDrill(Drill drill) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveDrill(drill);
    ref.invalidateSelf();
  }
  
  Future<void> updateDrill(Drill drill) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.updateDrill(drill);
    ref.invalidateSelf();
  }
  
  Future<void> deleteDrill(String drillId) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.deleteDrill(drillId);
    ref.invalidateSelf();
  }
}

// Session Provider
@riverpod
class SessionNotifier extends _$SessionNotifier {
  @override
  Session? build() {
    return null;
  }
  
  void startSession({String? drillId, String? drillName}) {
    state = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      drillId: drillId,
      drillName: drillName,
      stats: const SessionStats(),
    );
  }
  
  void endSession() {
    if (state != null) {
      state = state!.copyWith(endTime: DateTime.now());
    }
  }
  
  void updateBallsThrown(int count) {
    if (state != null) {
      state = state!.copyWith(totalBallsThrown: count);
    }
  }
  
  void addSessionStep(SessionStep step) {
    if (state != null) {
      final steps = List<SessionStep>.from(state!.steps)..add(step);
      state = state!.copyWith(steps: steps);
    }
  }
}

// Connection Provider
@riverpod
class ConnectionNotifier extends _$ConnectionNotifier {
  @override
  bool build() {
    final bleService = ref.watch(robotBleServiceProvider);
    
    ref.listen(robotBleServiceProvider, (previous, next) {
      next.connectionStream.listen((isConnected) {
        state = isConnected;
      });
    });
    
    return false;
  }
  
  Future<void> connectToDevice(String deviceId) async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.connectToDevice(deviceId);
    } catch (e) {
      // Handle error
    }
  }
  
  Future<void> disconnect() async {
    final bleService = ref.read(robotBleServiceProvider);
    try {
      await bleService.disconnect();
    } catch (e) {
      // Handle error
    }
  }
}