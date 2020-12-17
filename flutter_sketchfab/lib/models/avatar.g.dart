// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Avatar _$AvatarFromJson(Map<String, dynamic> json) {
  return Avatar(
    json['uri'] as String,
    (json['images'] as List)
        ?.map(
            (e) => e == null ? null : Image.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'uri': instance.uri,
      'images': instance.images,
    };
