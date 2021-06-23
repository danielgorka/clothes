import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:equatable/equatable.dart';

class Cloth extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<ClothImage> images;
  final List<ClothTag> tags;
  final bool favourite;
  final int order;
  final DateTime creationDate;

  const Cloth({
    required this.id,
    this.name = '',
    this.description = '',
    this.images = const [],
    this.tags = const [],
    this.favourite = false,
    this.order = 0,
    required this.creationDate,
  });

  factory Cloth.empty() => Cloth(id: 0, creationDate: DateTime.now());

  Cloth copyWith({
    int? id,
    String? name,
    String? description,
    List<ClothImage>? images,
    List<ClothTag>? tags,
    bool? favourite,
    int? order,
    DateTime? creationDate,
  }) {
    return Cloth(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      favourite: favourite ?? this.favourite,
      order: order ?? this.order,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        images,
        tags,
        favourite,
        order,
        creationDate,
      ];
}
