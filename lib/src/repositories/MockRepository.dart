import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget_example/src/repositories/BaseRepository.dart';
import 'package:googleapis/poly/v1.dart';

class MockCompanion implements RepositoryCompanion{

  const MockCompanion();

  @override
  MockRepository create() {
    debugPrint("Create called!");
    return MockRepository.protected();
  }
}

class MockRepository implements BaseRepository{

  static ListAssetsResponse instance;

  MockRepository.protected();

  factory MockRepository.getRepo() {
    debugPrint("Poly Get Repo!");
    return BaseRepository.getRepo<MockRepository>();
  }

  static Future<ListAssetsResponse> createFromJsonFile(String jsonFileToRead) async {
    if(instance==null) {
      var fileString = await rootBundle.loadString(jsonFileToRead);
      var _json = jsonDecode(fileString);
      instance = ListAssetsResponse.fromJson(_json);
    }
    return instance;
  }


  @override
  Future<ListAssetsResponse> getDataByQuery(query) =>
      createFromJsonFile("assets/MockData.json");

}
