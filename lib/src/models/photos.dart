// To parse this JSON data, do
//
//     final photos = photosFromJson(jsonString);

import 'dart:convert';

class Photos {
  int total;
  int totalPages;
  List<Result> results;

  Photos({
    this.total,
    this.totalPages,
    this.results,
  });

  factory Photos.fromRawJson(String str) => Photos.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Photos.fromJson(Map<String, dynamic> json){
    var results=json["data"]["result"];
    var total=results["total"];
    var items=results["items"];

    return new Photos(
      //image_json = response.getJSONObject("data").getJSONObject("result").getJSONArray("items");
      //ArrayList<models.ImageResult> a=models.ImageResult.parseJSON(image_json);
      total: total,
      //total: json["data"].json["results"].json["items"].length,
      totalPages: 1,
      results: new List<Result>.from(items.map((x) =>
              Result.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "total": total,
        "total_pages": totalPages,
        "results": new List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String id;
  int width;
  int height;
  String description;
  String urls;

  Result({
    this.id,
    this.width,
    this.height,
    this.description,
    this.urls,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => new Result(
        id: json["_id"],
        width: int.parse(json["width"]),
        height: int.parse(json["height"]),
        description: json["desc"],
        urls: json["media"]
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "width": width,
        "height": height,
        "description": description,
        "urls": urls
      };
}

