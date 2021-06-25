import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloth_tag_model.g.dart';

const _clothTagTypeEnumMap = {
  ClothTagType.clothKind: 'clothKind',
  ClothTagType.color: 'color',
  ClothTagType.other: 'other',
};

@JsonSerializable()
class ClothTagModel extends Equatable {
  final int id;
  final String type;
  final String name;

  const ClothTagModel({
    required this.id,
    required this.type,
    required this.name,
  });

  factory ClothTagModel.fromEntity(ClothTag clothTag) {
    return ClothTagModel(
      id: clothTag.id,
      type: _clothTagTypeEnumMap[clothTag.type]!,
      name: clothTag.name,
    );
  }

  ClothTag toEntity() {
    return ClothTag(
      id: id,
      type: _clothTagTypeEnumMap.entries
          .singleWhere(
            (e) => e.value == type,
            orElse: () => const MapEntry(ClothTagType.other, 'other'),
          )
          .key,
      name: name,
    );
  }

  factory ClothTagModel.fromJson(Map<String, dynamic> json) =>
      _$ClothTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClothTagModelToJson(this);

  @override
  List<Object?> get props => [id, type, name];
}
