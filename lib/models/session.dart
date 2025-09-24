import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalBallsThrown;
  final int totalDurationSec;
  final String? drillId;
  final String? drillName;
  final List<SessionStep> steps;
  final SessionStats stats;

  const Session({
    required this.id,
    required this.startTime,
    this.endTime,
    this.totalBallsThrown = 0,
    this.totalDurationSec = 0,
    this.drillId,
    this.drillName,
    this.steps = const [],
    required this.stats,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  Session copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? totalBallsThrown,
    int? totalDurationSec,
    String? drillId,
    String? drillName,
    List<SessionStep>? steps,
    SessionStats? stats,
  }) {
    return Session(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalBallsThrown: totalBallsThrown ?? this.totalBallsThrown,
      totalDurationSec: totalDurationSec ?? this.totalDurationSec,
      drillId: drillId ?? this.drillId,
      drillName: drillName ?? this.drillName,
      steps: steps ?? this.steps,
      stats: stats ?? this.stats,
    );
  }

  bool get isActive => endTime == null;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Session && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class SessionStep {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int frequency;
  final int oscillation;
  final int topspin;
  final int backspin;
  final int ballsThrown;

  const SessionStep({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.frequency,
    required this.oscillation,
    required this.topspin,
    required this.backspin,
    this.ballsThrown = 0,
  });

  factory SessionStep.fromJson(Map<String, dynamic> json) => _$SessionStepFromJson(json);
  Map<String, dynamic> toJson() => _$SessionStepToJson(this);

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionStep && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class SessionStats {
  final int totalSessions;
  final int totalBallsThrown;
  final int totalDurationSec;
  final double averageBallsPerSession;
  final double averageDurationPerSession;
  final DateTime? lastSessionDate;
  final Map<String, int> drillUsageCount;

  const SessionStats({
    this.totalSessions = 0,
    this.totalBallsThrown = 0,
    this.totalDurationSec = 0,
    this.averageBallsPerSession = 0.0,
    this.averageDurationPerSession = 0.0,
    this.lastSessionDate,
    this.drillUsageCount = const {},
  });

  factory SessionStats.fromJson(Map<String, dynamic> json) => _$SessionStatsFromJson(json);
  Map<String, dynamic> toJson() => _$SessionStatsToJson(this);

  SessionStats copyWith({
    int? totalSessions,
    int? totalBallsThrown,
    int? totalDurationSec,
    double? averageBallsPerSession,
    double? averageDurationPerSession,
    DateTime? lastSessionDate,
    Map<String, int>? drillUsageCount,
  }) {
    return SessionStats(
      totalSessions: totalSessions ?? this.totalSessions,
      totalBallsThrown: totalBallsThrown ?? this.totalBallsThrown,
      totalDurationSec: totalDurationSec ?? this.totalDurationSec,
      averageBallsPerSession: averageBallsPerSession ?? this.averageBallsPerSession,
      averageDurationPerSession: averageDurationPerSession ?? this.averageDurationPerSession,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      drillUsageCount: drillUsageCount ?? this.drillUsageCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SessionStats &&
        other.totalSessions == totalSessions &&
        other.totalBallsThrown == totalBallsThrown &&
        other.totalDurationSec == totalDurationSec &&
        other.averageBallsPerSession == averageBallsPerSession &&
        other.averageDurationPerSession == averageDurationPerSession &&
        other.lastSessionDate == lastSessionDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalSessions,
      totalBallsThrown,
      totalDurationSec,
      averageBallsPerSession,
      averageDurationPerSession,
      lastSessionDate,
    );
  }
}