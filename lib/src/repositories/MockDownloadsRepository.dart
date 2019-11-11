import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget_example/src/repositories/BaseRepository.dart';
import 'package:googleapis/poly/v1.dart';

class MockDownloadsCompanion implements RepositoryCompanion {
  const MockDownloadsCompanion();

  @override
  MockDownloadsRepository create() {
    debugPrint("Create called!");
    return MockDownloadsRepository.protected();
  }
}

class DownloadStateList {
  List<DownloadState> downloads;

  DownloadStateList.fromJson(Map _json) {
    if (_json.containsKey("downloads")) {
      downloads = (_json["downloads"] as List)
          .map<DownloadState>((value) => DownloadState.fromJson(value))
          .toList();
    }
  }
}

class DownloadState {
  String name;
  bool completed;
  bool error;
  double progress;

  DownloadState._private(
      {this.name, this.completed, this.error, this.progress});

  DownloadState.fromJson(Map _json) {
    if (_json.containsKey("name")) {
      name = _json["name"] as String;
    }
    if (_json.containsKey("completed")) {
      completed = _json["completed"] as bool;
    }
    if (_json.containsKey("error")) {
      error = _json["error"] as bool;
    }
    if (_json.containsKey("progress")) {
      progress = _json["progress"] as double;
    }
  }

  factory DownloadState.completed(String name) =>
      DownloadState._private(name: name, completed: true, progress: 1);

  factory DownloadState.withProgress(String name, double progress) =>
      DownloadState._private(name: name, progress: progress);

  factory DownloadState.error(String name) =>
      DownloadState._private(name: name, error: true);
}

class MockDownloadsRepository implements BaseRepository<DownloadState> {

  static Map<String, DownloadState> instance;

  MockDownloadsRepository.protected();

  factory MockDownloadsRepository.getRepo() {
    debugPrint("Poly Get Repo!");
    return BaseRepository.getRepo<MockDownloadsRepository>();
  }

  static Future<DownloadState> createFromJsonFile(
      String jsonFileToRead,String query) async {
    if (instance == null) {
      var fileString = await rootBundle.loadString(jsonFileToRead);
      var _json = jsonDecode(fileString);
      var downloadList = DownloadStateList.fromJson(_json);
      instance=downloadList.downloads.asMap().map<String, DownloadState>((int, value) =>
          MapEntry(value.name, value));
    }

    if(instance.containsKey(query))
      return instance[query];
    else
      return null;
  }

  setData(DownloadState state){
    if(instance.containsKey(state.name))
      instance[state.name]=state;
    else
      instance.putIfAbsent(state.name, ()=>state);
  }

  @override
  Future<DownloadState> getDataByQuery(query) {
    print("Download Requested!");
    return createFromJsonFile("assets/MockData.json",query);
  }
}
