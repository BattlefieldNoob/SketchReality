import 'package:json_annotation/json_annotation.dart';

import 'avatar.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String username;
  final String displayName;
  final String profileUrl;
  final String account;
  final Avatar avatar;
  final String uri;

  User(this.uid, this.username, this.displayName, this.profileUrl, this.account,
      this.avatar, this.uri);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
