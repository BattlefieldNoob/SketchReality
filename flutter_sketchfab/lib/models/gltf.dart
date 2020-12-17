import 'package:json_annotation/json_annotation.dart';

part 'gltf.g.dart';

@JsonSerializable()
class Gltf {
  final int size;

  Gltf(this.size);

  factory Gltf.fromJson(Map<String, dynamic> json) => _$GltfFromJson(json);
  Map<String, dynamic> toJson() => _$GltfToJson(this);
}
