import 'package:json_annotation/json_annotation.dart';

import 'asset.dart';
import 'cursors.dart';

part 'list_assets_response.g.dart';

@JsonSerializable()
class ListAssetsResponse {
  final Cursors cursors;
  final String next;
  final String previous;
  final List<Asset> results;

  ListAssetsResponse(this.cursors, this.next, this.previous, this.results);

  factory ListAssetsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListAssetsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListAssetsResponseToJson(this);
}
