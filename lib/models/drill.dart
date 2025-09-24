import 'package:json_annotation/json_annotation.dart';
import 'drill_step.dart';

part 'drill.g.dart';

@JsonSerializable()
class Drill {
  final String id;
  final String name;
  final List<DrillStep> steps;
  final int loops;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;

  const Drill({
    required this.id,
    required this.name,
    required this.steps,
    required this.loops,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  factory Drill.fromJson(Map<String, dynamic> json) => _$DrillFromJson(json);
  Map<String, dynamic> toJson() => _$DrillToJson(this);

  Drill copyWith({
    String? id,
    String? name,
    List<DrillStep>? steps,
    int? loops,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
  }) {
    return Drill(
      id: id ?? this.id,
      name: name ?? this.name,
      steps: steps ?? this.steps,
      loops: loops ?? this.loops,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
    );
  }

  int get totalDuration {
    return steps.fold(0, (total, step) => total + step.durationSec);
  }

  int get totalDurationWithLoops {
    return totalDuration * loops;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Drill && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Drill(id: $id, name: $name, steps: ${steps.length}, loops: $loops)';
  }
}