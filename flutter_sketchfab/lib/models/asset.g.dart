// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return Asset(
    json['uri'] as String,
    json['uid'] as String,
    json['name'] as String,
    json['staffpickedAt'] as String,
    json['viewCount'] as int,
    json['likeCount'] as int,
    json['animationCount'] as int,
    json['viewerUrl'] as String,
    json['embedUrl'] as String,
    json['commentCount'] as int,
    json['isDownloadable'] as bool,
    json['publishedAt'] as String,
    (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : Category.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['thumbnails'] == null
        ? null
        : Thumbnails.fromJson(json['thumbnails'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['description'] as String,
    json['faceCount'] as int,
    json['createdAt'] as String,
    json['vertexCount'] as int,
    json['isAgeRestricted'] as bool,
    json['archives'] == null
        ? null
        : Archives.fromJson(json['archives'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'uri': instance.uri,
      'uid': instance.uid,
      'name': instance.name,
      'staffpickedAt': instance.staffpickedAt,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'animationCount': instance.animationCount,
      'viewerUrl': instance.viewerUrl,
      'embedUrl': instance.embedUrl,
      'commentCount': instance.commentCount,
      'isDownloadable': instance.isDownloadable,
      'publishedAt': instance.publishedAt,
      'tags': instance.tags,
      'categories': instance.categories,
      'thumbnails': instance.thumbnails,
      'user': instance.user,
      'description': instance.description,
      'faceCount': instance.faceCount,
      'createdAt': instance.createdAt,
      'vertexCount': instance.vertexCount,
      'isAgeRestricted': instance.isAgeRestricted,
      'archives': instance.archives,
    };
