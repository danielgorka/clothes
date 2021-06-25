import 'package:equatable/equatable.dart';

enum ClothTagType { clothKind, color, other }

class ClothTag extends Equatable {
  final int id;
  final ClothTagType type;
  final String name;

  const ClothTag({
    required this.id,
    required this.type,
    this.name = '',
  });

  @override
  List<Object?> get props => [id, type, name];
}
