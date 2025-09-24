// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'robot_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RobotState _$RobotStateFromJson(Map<String, dynamic> json) => RobotState(
      isConnected: json['isConnected'] as bool? ?? false,
      isPowered: json['isPowered'] as bool? ?? false,
      isFeeding: json['isFeeding'] as bool? ?? false,
      frequency: json['frequency'] as int? ?? 0,
      oscillation: json['oscillation'] as int? ?? 0,
      topspin: json['topspin'] as int? ?? 0,
      backspin: json['backspin'] as int? ?? 0,
      batteryLevel: json['batteryLevel'] as int?,
      deviceName: json['deviceName'] as String?,
      deviceId: json['deviceId'] as String?,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      signalStrength: json['signalStrength'] as int?,
      hasFault: json['hasFault'] as bool? ?? false,
      isOverTemp: json['isOverTemp'] as bool? ?? false,
    );

Map<String, dynamic> _$RobotStateToJson(RobotState instance) =>
    <String, dynamic>{
      'isConnected': instance.isConnected,
      'isPowered': instance.isPowered,
      'isFeeding': instance.isFeeding,
      'frequency': instance.frequency,
      'oscillation': instance.oscillation,
      'topspin': instance.topspin,
      'backspin': instance.backspin,
      'batteryLevel': instance.batteryLevel,
      'deviceName': instance.deviceName,
      'deviceId': instance.deviceId,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'signalStrength': instance.signalStrength,
      'hasFault': instance.hasFault,
      'isOverTemp': instance.isOverTemp,
    };