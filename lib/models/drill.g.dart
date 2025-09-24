// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drill _$DrillFromJson(Map<String, dynamic> json) => Drill(
      id: json['id'] as String,
      name: json['name'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => DrillStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      loops: json['loops'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DrillToJson(Drill instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'steps': instance.steps,
      'loops': instance.loops,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'description': instance.description,
    };