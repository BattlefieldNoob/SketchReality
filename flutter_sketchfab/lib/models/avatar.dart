import 'package:json_annotation/json_annotation.dart';

import 'image.dart';

part 'avatar.g.dart';

@JsonSerializable()
class Avatar {
  final String uri;
  final List<Image> images;

  Avatar(this.uri, this.images);

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
  Map<String, dynamic> toJson() => _$AvatarToJson(this);
}
