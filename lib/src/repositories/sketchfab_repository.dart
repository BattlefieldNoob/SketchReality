import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sketchfab/models/list_assets_response.dart';
import 'package:flutter_unity_widget_example/src/repositories/base_repository.dart';

class SketchfabCompanion implements RepositoryCompanion {
  const SketchfabCompanion();

  @override
  SketchfabRepository create() {
    debugPrint("Create called!");
    return SketchfabRepository.protected();
  }
}

class SketchfabRepository implements BaseRepository {
  final String baseUrl = "https://api.sketchfab.com/v3/search?type=models";

  static Dio dio = Dio();

  SketchfabRepository.protected();

  factory SketchfabRepository.getRepo() {
    dio.options.headers
        .addAll({"Authorization": "Token 8b5363d4c7d14255824f82338dfb1200"});

    debugPrint("Sketchfab Get Repo!");
    return BaseRepository.getRepo<SketchfabRepository>();
  }

  @override
  Future<ListAssetsResponse> getDataByQuery(query) async {
    var response = await dio
        .get(baseUrl, queryParameters: {"q": query, "downloadable": true});
    var json = jsonDecode(response.toString());
    return ListAssetsResponse.fromJson(json);
  }
}
