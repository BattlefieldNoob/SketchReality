import 'package:json_annotation/json_annotation.dart';

part 'cursors.g.dart';

@JsonSerializable()
class Cursors {
  final String next;
  final String previous;

  Cursors(this.next, this.previous);

  factory Cursors.fromJson(Map<String, dynamic> json) =>
      _$CursorsFromJson(json);
  Map<String, dynamic> toJson() => _$CursorsToJson(this);
}
