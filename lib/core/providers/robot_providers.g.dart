// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'robot_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$robotBleServiceHash() => r'1234567890abcdef';

/// See also [robotBleService].
@ProviderFor(robotBleService)
final robotBleServiceProvider = AutoDisposeProvider<RobotBleInterface>.internal(
  robotBleService,
  name: r'robotBleServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$robotBleServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RobotBleServiceRef = AutoDisposeProviderRef<RobotBleInterface>;
String _$robotStateNotifierHash() => r'1234567890abcdef';

/// See also [RobotStateNotifier].
@ProviderFor(RobotStateNotifier)
final robotStateNotifierProvider =
    AutoDisposeNotifierProvider<RobotStateNotifier, RobotState>.internal(
  RobotStateNotifier.new,
  name: r'robotStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$robotStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RobotStateNotifierRef = AutoDisposeNotifierProviderRef<RobotState, RobotStateNotifier>;
String _$presetsNotifierHash() => r'1234567890abcdef';

/// See also [PresetsNotifier].
@ProviderFor(PresetsNotifier)
final presetsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PresetsNotifier, List<Preset>>.internal(
  PresetsNotifier.new,
  name: r'presetsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$presetsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PresetsNotifierRef = AutoDisposeAsyncNotifierProviderRef<List<Preset>, PresetsNotifier>;
String _$drillsNotifierHash() => r'1234567890abcdef';

/// See also [DrillsNotifier].
@ProviderFor(DrillsNotifier)
final drillsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DrillsNotifier, List<Drill>>.internal(
  DrillsNotifier.new,
  name: r'drillsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$drillsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DrillsNotifierRef = AutoDisposeAsyncNotifierProviderRef<List<Drill>, DrillsNotifier>;
String _$sessionNotifierHash() => r'1234567890abcdef';

/// See also [SessionNotifier].
@ProviderFor(SessionNotifier)
final sessionNotifierProvider =
    AutoDisposeNotifierProvider<SessionNotifier, Session?>.internal(
  SessionNotifier.new,
  name: r'sessionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionNotifierRef = AutoDisposeNotifierProviderRef<Session?, SessionNotifier>;
String _$connectionNotifierHash() => r'1234567890abcdef';

/// See also [ConnectionNotifier].
@ProviderFor(ConnectionNotifier)
final connectionNotifierProvider =
    AutoDisposeNotifierProvider<ConnectionNotifier, bool>.internal(
  ConnectionNotifier.new,
  name: r'connectionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectionNotifierRef = AutoDisposeNotifierProviderRef<bool, ConnectionNotifier>;
String _$storageServiceHash() => r'1234567890abcdef';

/// See also [storageService].
@ProviderFor(storageService)
final storageServiceProvider = AutoDisposeProvider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StorageServiceRef = AutoDisposeProviderRef<StorageService>;