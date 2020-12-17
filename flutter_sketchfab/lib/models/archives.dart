import 'package:json_annotation/json_annotation.dart';

import 'gltf.dart';

part 'archives.g.dart';

@JsonSerializable()
class Archives {
  final Gltf gltf;

  Archives(this.gltf);

  factory Archives.fromJson(Map<String, dynamic> json) =>
      _$ArchivesFromJson(json);
  Map<String, dynamic> toJson() => _$ArchivesToJson(this);
}
