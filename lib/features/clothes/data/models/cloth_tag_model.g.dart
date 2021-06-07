// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothTagModel _$ClothTagModelFromJson(Map<String, dynamic> json) {
  return ClothTagModel(
    id: json['id'] as int,
    type: json['type'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$ClothTagModelToJson(ClothTagModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
    };
