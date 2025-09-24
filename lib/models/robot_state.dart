import 'package:json_annotation/json_annotation.dart';

part 'robot_state.g.dart';

@JsonSerializable()
class RobotState {
  final bool isConnected;
  final bool isPowered;
  final bool isFeeding;
  final int frequency;
  final int oscillation;
  final int topspin;
  final int backspin;
  final int? batteryLevel;
  final String? deviceName;
  final String? deviceId;
  final DateTime? lastSeen;
  final int? signalStrength;
  final bool hasFault;
  final bool isOverTemp;

  const RobotState({
    this.isConnected = false,
    this.isPowered = false,
    this.isFeeding = false,
    this.frequency = 0,
    this.oscillation = 0,
    this.topspin = 0,
    this.backspin = 0,
    this.batteryLevel,
    this.deviceName,
    this.deviceId,
    this.lastSeen,
    this.signalStrength,
    this.hasFault = false,
    this.isOverTemp = false,
  });

  factory RobotState.fromJson(Map<String, dynamic> json) => _$RobotStateFromJson(json);
  Map<String, dynamic> toJson() => _$RobotStateToJson(this);

  RobotState copyWith({
    bool? isConnected,
    bool? isPowered,
    bool? isFeeding,
    int? frequency,
    int? oscillation,
    int? topspin,
    int? backspin,
    int? batteryLevel,
    String? deviceName,
    String? deviceId,
    DateTime? lastSeen,
    int? signalStrength,
    bool? hasFault,
    bool? isOverTemp,
  }) {
    return RobotState(
      isConnected: isConnected ?? this.isConnected,
      isPowered: isPowered ?? this.isPowered,
      isFeeding: isFeeding ?? this.isFeeding,
      frequency: frequency ?? this.frequency,
      oscillation: oscillation ?? this.oscillation,
      topspin: topspin ?? this.topspin,
      backspin: backspin ?? this.backspin,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      lastSeen: lastSeen ?? this.lastSeen,
      signalStrength: signalStrength ?? this.signalStrength,
      hasFault: hasFault ?? this.hasFault,
      isOverTemp: isOverTemp ?? this.isOverTemp,
    );
  }

  bool get isOperational => isConnected && isPowered && !hasFault && !isOverTemp;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RobotState &&
        other.isConnected == isConnected &&
        other.isPowered == isPowered &&
        other.isFeeding == isFeeding &&
        other.frequency == frequency &&
        other.oscillation == oscillation &&
        other.topspin == topspin &&
        other.backspin == backspin &&
        other.batteryLevel == batteryLevel &&
        other.deviceName == deviceName &&
        other.deviceId == deviceId &&
        other.signalStrength == signalStrength &&
        other.hasFault == hasFault &&
        other.isOverTemp == isOverTemp;
  }

  @override
  int get hashCode {
    return Object.hash(
      isConnected,
      isPowered,
      isFeeding,
      frequency,
      oscillation,
      topspin,
      backspin,
      batteryLevel,
      deviceName,
      deviceId,
      signalStrength,
      hasFault,
      isOverTemp,
    );
  }

  @override
  String toString() {
    return 'RobotState(isConnected: $isConnected, isPowered: $isPowered, isFeeding: $isFeeding, frequency: $frequency, oscillation: $oscillation, topspin: $topspin, backspin: $backspin)';
  }
}