import 'package:json_annotation/json_annotation.dart';

import 'archives.dart';
import 'category.dart';
import 'tag.dart';
import 'thumbnails.dart';
import 'user.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  final String uri;
  final String uid;
  final String name;
  final String staffpickedAt;
  final int viewCount;
  final int likeCount;
  final int animationCount;
  final String viewerUrl;
  final String embedUrl;
  final int commentCount;
  final bool isDownloadable;
  final String publishedAt;
  final List<Tag> tags;
  final List<Category> categories;
  final Thumbnails thumbnails;
  final User user;
  final String description;
  final int faceCount;
  final String createdAt;
  final int vertexCount;
  final bool isAgeRestricted;
  final Archives archives;

  Asset(
      this.uri,
      this.uid,
      this.name,
      this.staffpickedAt,
      this.viewCount,
      this.likeCount,
      this.animationCount,
      this.viewerUrl,
      this.embedUrl,
      this.commentCount,
      this.isDownloadable,
      this.publishedAt,
      this.tags,
      this.categories,
      this.thumbnails,
      this.user,
      this.description,
      this.faceCount,
      this.createdAt,
      this.vertexCount,
      this.isAgeRestricted,
      this.archives);

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);
}
