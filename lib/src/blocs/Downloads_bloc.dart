import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_unity_widget_example/src/repositories/MockDownloadsRepository.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:rxdart/rxdart.dart';

class DownloadBloc {
  static final MockDownloadsRepository _repository =
  MockDownloadsRepository.getRepo();

  static PublishSubject<DownloadState> downloads;

  static Map<String, double> downloadIdToProgress = Map();
  static Map<String, List<String>> parentIdToChildren = Map();
  static Map<String, String> parentIdToName = Map();

  init() {
    print("Download Bloc Init");
    downloads = PublishSubject<DownloadState>();
    downloads.where((state) => state.error || state.completed).listen((state) {
      _repository.setData(state);
    });

    FlutterDownloader.initialize().whenComplete(() {
      FlutterDownloader.registerCallback(downloadCallback);
    });
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    print("id:$id progress:${progress/100}");
    print("id:$id status:${status.value}");

    if(progress<=0)
      return;

    if (downloadIdToProgress.containsKey(id)) {
      downloadIdToProgress[id] = progress/100;
    } else {
      downloadIdToProgress.putIfAbsent(id, () => progress/100);
    }


    //il download progress è del main asset
    if (parentIdToChildren.containsKey(id)) {
      print("updating stream");
      var list = parentIdToChildren[id].map((
          childid) => downloadIdToProgress[childid]).toList();
      list.add(downloadIdToProgress[id]);
      var progress= list.reduce((p1,p2)=>p1+p2)/list.length;
      downloads.sink.add(DownloadState.withProgress(parentIdToName[id], progress/100));
    }
  }

  Observable<DownloadState> get downloadsEventStream =>
      downloads.stream.distinct();

  Function(DownloadState) get changeQuery => downloads.sink.add;

  Future<DownloadState> getDownloadStateByAssetName(String name) =>
      _repository.getDataByQuery(name);

  startDownload(String name, Format format, String saveDir) async {
    var parentid = await FlutterDownloader.enqueue(
        url: format.root.url,
        savedDir: saveDir,
        fileName: format.root.relativePath);

    parentIdToName.putIfAbsent(parentid, ()=>name);

    var childrenId = List<String>();
    format.resources.forEach((f) async {
      print("${f.relativePath}");
      var childid = await FlutterDownloader.enqueue(
          url: f.url, savedDir: saveDir, fileName: f.relativePath);
      childrenId.add(childid);
    });

    parentIdToChildren.putIfAbsent(parentid, () => childrenId);
  }

  void dispose() {
    downloads.close();
  }
}

final downloadBloc = DownloadBloc();
