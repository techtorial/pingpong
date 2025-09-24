// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drill_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomRange _$RandomRangeFromJson(Map<String, dynamic> json) => RandomRange(
      min: json['min'] as int,
      max: json['max'] as int,
    );

Map<String, dynamic> _$RandomRangeToJson(RandomRange instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

DrillStep _$DrillStepFromJson(Map<String, dynamic> json) => DrillStep(
      id: json['id'] as String,
      durationSec: json['durationSec'] as int,
      frequency: json['frequency'] as int,
      oscillation: json['oscillation'] as int,
      topspin: json['topspin'] as int,
      backspin: json['backspin'] as int,
      frequencyRange: json['frequencyRange'] == null
          ? null
          : RandomRange.fromJson(json['frequencyRange'] as Map<String, dynamic>),
      oscillationRange: json['oscillationRange'] == null
          ? null
          : RandomRange.fromJson(json['oscillationRange'] as Map<String, dynamic>),
      topspinRange: json['topspinRange'] == null
          ? null
          : RandomRange.fromJson(json['topspinRange'] as Map<String, dynamic>),
      backspinRange: json['backspinRange'] == null
          ? null
          : RandomRange.fromJson(json['backspinRange'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DrillStepToJson(DrillStep instance) => <String, dynamic>{
      'id': instance.id,
      'durationSec': instance.durationSec,
      'frequency': instance.frequency,
      'oscillation': instance.oscillation,
      'topspin': instance.topspin,
      'backspin': instance.backspin,
      'frequencyRange': instance.frequencyRange,
      'oscillationRange': instance.oscillationRange,
      'topspinRange': instance.topspinRange,
      'backspinRange': instance.backspinRange,
      'description': instance.description,
    };