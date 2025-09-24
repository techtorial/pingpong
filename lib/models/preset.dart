import 'package:json_annotation/json_annotation.dart';

part 'preset.g.dart';

@JsonSerializable()
class Preset {
  final String id;
  final String name;
  final int frequency;
  final int oscillation;
  final int topspin;
  final int backspin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Preset({
    required this.id,
    required this.name,
    required this.frequency,
    required this.oscillation,
    required this.topspin,
    required this.backspin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Preset.fromJson(Map<String, dynamic> json) => _$PresetFromJson(json);
  Map<String, dynamic> toJson() => _$PresetToJson(this);

  Preset copyWith({
    String? id,
    String? name,
    int? frequency,
    int? oscillation,
    int? topspin,
    int? backspin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      oscillation: oscillation ?? this.oscillation,
      topspin: topspin ?? this.topspin,
      backspin: backspin ?? this.backspin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Preset && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Preset(id: $id, name: $name, frequency: $frequency, oscillation: $oscillation, topspin: $topspin, backspin: $backspin)';
  }
}