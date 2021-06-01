import 'package:equatable/equatable.dart';

abstract class BaseImage extends Equatable {
  final int id;
  final String path;

  const BaseImage({
    required this.id,
    required this.path,
  });

  @override
  List<Object?> get props => [id, path];
}
