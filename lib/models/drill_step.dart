import 'package:json_annotation/json_annotation.dart';

part 'drill_step.g.dart';

@JsonSerializable()
class RandomRange {
  final int min;
  final int max;

  const RandomRange({
    required this.min,
    required this.max,
  });

  factory RandomRange.fromJson(Map<String, dynamic> json) => _$RandomRangeFromJson(json);
  Map<String, dynamic> toJson() => _$RandomRangeToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RandomRange && other.min == min && other.max == max;
  }

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}

@JsonSerializable()
class DrillStep {
  final String id;
  final int durationSec;
  final int frequency;
  final int oscillation;
  final int topspin;
  final int backspin;
  final RandomRange? frequencyRange;
  final RandomRange? oscillationRange;
  final RandomRange? topspinRange;
  final RandomRange? backspinRange;
  final String? description;

  const DrillStep({
    required this.id,
    required this.durationSec,
    required this.frequency,
    required this.oscillation,
    required this.topspin,
    required this.backspin,
    this.frequencyRange,
    this.oscillationRange,
    this.topspinRange,
    this.backspinRange,
    this.description,
  });

  factory DrillStep.fromJson(Map<String, dynamic> json) => _$DrillStepFromJson(json);
  Map<String, dynamic> toJson() => _$DrillStepToJson(this);

  DrillStep copyWith({
    String? id,
    int? durationSec,
    int? frequency,
    int? oscillation,
    int? topspin,
    int? backspin,
    RandomRange? frequencyRange,
    RandomRange? oscillationRange,
    RandomRange? topspinRange,
    RandomRange? backspinRange,
    String? description,
  }) {
    return DrillStep(
      id: id ?? this.id,
      durationSec: durationSec ?? this.durationSec,
      frequency: frequency ?? this.frequency,
      oscillation: oscillation ?? this.oscillation,
      topspin: topspin ?? this.topspin,
      backspin: backspin ?? this.backspin,
      frequencyRange: frequencyRange ?? this.frequencyRange,
      oscillationRange: oscillationRange ?? this.oscillationRange,
      topspinRange: topspinRange ?? this.topspinRange,
      backspinRange: backspinRange ?? this.backspinRange,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrillStep && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DrillStep(id: $id, durationSec: $durationSec, frequency: $frequency, oscillation: $oscillation, topspin: $topspin, backspin: $backspin)';
  }
}