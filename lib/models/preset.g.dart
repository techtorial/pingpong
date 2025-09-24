// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preset _$PresetFromJson(Map<String, dynamic> json) => Preset(
      id: json['id'] as String,
      name: json['name'] as String,
      frequency: json['frequency'] as int,
      oscillation: json['oscillation'] as int,
      topspin: json['topspin'] as int,
      backspin: json['backspin'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PresetToJson(Preset instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'frequency': instance.frequency,
      'oscillation': instance.oscillation,
      'topspin': instance.topspin,
      'backspin': instance.backspin,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };