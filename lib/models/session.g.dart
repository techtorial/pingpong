// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      totalBallsThrown: json['totalBallsThrown'] as int? ?? 0,
      totalDurationSec: json['totalDurationSec'] as int? ?? 0,
      drillId: json['drillId'] as String?,
      drillName: json['drillName'] as String?,
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => SessionStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stats: SessionStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'totalBallsThrown': instance.totalBallsThrown,
      'totalDurationSec': instance.totalDurationSec,
      'drillId': instance.drillId,
      'drillName': instance.drillName,
      'steps': instance.steps,
      'stats': instance.stats,
    };

SessionStep _$SessionStepFromJson(Map<String, dynamic> json) => SessionStep(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      frequency: json['frequency'] as int,
      oscillation: json['oscillation'] as int,
      topspin: json['topspin'] as int,
      backspin: json['backspin'] as int,
      ballsThrown: json['ballsThrown'] as int? ?? 0,
    );

Map<String, dynamic> _$SessionStepToJson(SessionStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'frequency': instance.frequency,
      'oscillation': instance.oscillation,
      'topspin': instance.topspin,
      'backspin': instance.backspin,
      'ballsThrown': instance.ballsThrown,
    };

SessionStats _$SessionStatsFromJson(Map<String, dynamic> json) => SessionStats(
      totalSessions: json['totalSessions'] as int? ?? 0,
      totalBallsThrown: json['totalBallsThrown'] as int? ?? 0,
      totalDurationSec: json['totalDurationSec'] as int? ?? 0,
      averageBallsPerSession: (json['averageBallsPerSession'] as num?)?.toDouble() ?? 0.0,
      averageDurationPerSession: (json['averageDurationPerSession'] as num?)?.toDouble() ?? 0.0,
      lastSessionDate: json['lastSessionDate'] == null
          ? null
          : DateTime.parse(json['lastSessionDate'] as String),
      drillUsageCount: (json['drillUsageCount'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
    );

Map<String, dynamic> _$SessionStatsToJson(SessionStats instance) =>
    <String, dynamic>{
      'totalSessions': instance.totalSessions,
      'totalBallsThrown': instance.totalBallsThrown,
      'totalDurationSec': instance.totalDurationSec,
      'averageBallsPerSession': instance.averageBallsPerSession,
      'averageDurationPerSession': instance.averageDurationPerSession,
      'lastSessionDate': instance.lastSessionDate?.toIso8601String(),
      'drillUsageCount': instance.drillUsageCount,
    };