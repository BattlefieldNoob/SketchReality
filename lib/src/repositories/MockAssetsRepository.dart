import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget_example/src/repositories/BaseRepository.dart';
import 'package:googleapis/poly/v1.dart';

class MockAssetsCompanion implements RepositoryCompanion{

  const MockAssetsCompanion();

  @override
  MockAssetsRepository create() {
    debugPrint("Create called!");
    return MockAssetsRepository.protected();
  }
}

class MockAssetsRepository implements BaseRepository<ListAssetsResponse>{

  static ListAssetsResponse instance;

  MockAssetsRepository.protected();

  factory MockAssetsRepository.getRepo() {
    debugPrint("Mock Poly Get Repo!");
    return BaseRepository.getRepo<MockAssetsRepository>();
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
  Future<ListAssetsResponse> getDataByQuery(query) {
    print("Data Requested!");
    return createFromJsonFile("assets/MockData.json");
  }

}
