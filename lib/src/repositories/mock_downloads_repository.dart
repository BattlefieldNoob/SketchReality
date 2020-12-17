/*class MockDownloadsCompanion implements RepositoryCompanion {
  const MockDownloadsCompanion();

  @override
  MockDownloadsRepository create() {
    debugPrint("Create called!");
    return MockDownloadsRepository.protected();
  }
}

class DownloadStateList {
  List<MockDownloadState> downloads;

  DownloadStateList.fromJson(Map _json) {
    if (_json.containsKey("downloads")) {
      downloads = (_json["downloads"] as List)
          .map<MockDownloadState>((value) => MockDownloadState.fromJson(value))
          .toList();
    }
  }
}

class MockDownloadState {
  String name;
  bool completed;
  bool error;
  double progress;

  MockDownloadState._private(
      {this.name, this.completed, this.error, this.progress});

  MockDownloadState.fromJson(Map _json) {
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

  factory MockDownloadState.completed(String name) =>
      MockDownloadState._private(name: name, completed: true, progress: 1);

  factory MockDownloadState.withProgress(String name, double progress) =>
      MockDownloadState._private(name: name, progress: progress);

  factory MockDownloadState.error(String name) =>
      MockDownloadState._private(name: name, error: true);
}

class MockDownloadsRepository implements BaseRepository<MockDownloadState> {
  static Map<String, MockDownloadState> instance;

  MockDownloadsRepository.protected();

  factory MockDownloadsRepository.getRepo() {
    debugPrint("Poly Get Repo!");
    return BaseRepository.getRepo<MockDownloadsRepository>();
  }

  static Future<MockDownloadState> createFromJsonFile(
      String jsonFileToRead, String query) async {
    if (instance == null) {
      var fileString = await rootBundle.loadString(jsonFileToRead);
      var _json = jsonDecode(fileString);
      var downloadList = DownloadStateList.fromJson(_json);
      instance = downloadList.downloads.asMap().map<String, MockDownloadState>(
          (int, value) => MapEntry(value.name, value));
    }

    if (instance.containsKey(query))
      return instance[query];
    else
      return null;
  }

  setData(MockDownloadState state) {
    if (instance.containsKey(state.name))
      instance[state.name] = state;
    else
      instance.putIfAbsent(state.name, () => state);
  }

  @override
  Future<MockDownloadState> getDataByQuery(query) {
    print("Download Requested!");
    return createFromJsonFile("assets/MockData.json", query);
  }
}*/
