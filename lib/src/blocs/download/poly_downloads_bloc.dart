import 'dart:convert';
import 'dart:io' as dart;
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/check_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/delete_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/start_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_pending_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_state.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'states/download_progress_state.dart';
import 'states/download_ready_state.dart';

class PolyDownloadsBloc extends Bloc<DownloadEvent, DownloadState> {
  Map<Object, Object> assetNameToProgress;
  var idToFile = Map<String, File>();
  var fileToProgress = Map<File, double>();
  var fileToAsset = Map<File, Asset>();

  dart.File jsonDownloadFile;

  String dataDirectory;

  ReceivePort _port = ReceivePort();

  PolyDownloadsBloc() {
    FlutterDownloader.initialize().whenComplete(() {
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen(onDownloadIsolateMessage);
      FlutterDownloader.registerCallback(downloadCallback);
    });

    (dart.Platform.isAndroid
            ? getExternalStorageDirectory()
            : getApplicationDocumentsDirectory())
        .then((directory) {
      dataDirectory = directory.path;

      jsonDownloadFile = dart.File(path.join(dataDirectory, "downloads.json"));
      if (!jsonDownloadFile.existsSync()) {
        assetNameToProgress = Map<Object, Object>();
        jsonDownloadFile.writeAsStringSync(jsonEncode(assetNameToProgress));
      } else {
        assetNameToProgress = jsonDecode(jsonDownloadFile.readAsStringSync(),
            reviver: (key, value) {
          //viene chiamato per ogni entry ed infine per la lista delle entries, con "values" come map
          return value;
        });
      }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print("id:$id progress:${progress / 100}");
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void onDownloadIsolateMessage(dynamic data) {
    String id = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];
    if (progress < 0) {
      print("progress is less than 0!");
      progress = 0;
    }

    print("callback ids:" + idToFile.keys.join("_"));
    if (idToFile.containsKey(id)) {
      var file = idToFile[id];
      if (fileToProgress.containsKey(file)) {
        fileToProgress[file] = progress / 100;
        if (fileToAsset.containsKey(file)) {
          var asset = fileToAsset[file];
          var format = asset.formats
              .firstWhere((format) => format.formatType == "GLTF2");
          var sum = fileToProgress[format.root];
          format.resources.forEach((file) {
            sum += fileToProgress[file];
          });

          var totalProgress = sum / (format.resources.length + 1);
          if (assetNameToProgress.containsKey(asset.name))
            assetNameToProgress[asset.name] = totalProgress;

          add(CheckDownloadEvent(asset: asset));

          print("Total Progress:$totalProgress");
          if (totalProgress == 1.0) {
            print("Writing File!");
            if (jsonDownloadFile.existsSync())
              jsonDownloadFile
                  .writeAsStringSync(jsonEncode(assetNameToProgress));
          }
        }
      }
    }
  }

  @override
  DownloadState get initialState => DownloadPendingState(null);

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    if (event is CheckDownloadEvent) {
      print("Check Download Event!");
      if (assetNameToProgress.containsKey(event.asset.name)) {
        var assetProgress = assetNameToProgress[event.asset.name];
        if (assetProgress == 1.0) {
          yield DownloadReadyState(event.asset);
        } else {
          yield DownloadProgressState(event.asset,
              progress: assetProgress as double);
        }
      } else {
        yield DownloadPendingState(event.asset);
      }
    } else if (event is StartDownloadEvent) {
      await startAssetDownload(event);
      yield DownloadProgressState(event.asset, progress: 0.0);
    } else if (event is DeleteDownloadEvent) {
      deleteAssetAssetDownload(event);
      yield DownloadPendingState(event.asset);
    } else {
      throw Exception("event not recognized!");
    }
  }

  Future startAssetDownload(StartDownloadEvent event) async {
    if (!assetNameToProgress.containsKey(event.asset.name)) {
      assetNameToProgress.putIfAbsent(event.asset.name, () => 0);

      var format = event.asset.formats
          .firstWhere((format) => format.formatType == "GLTF2");

      fileToProgress.putIfAbsent(format.root, () => 0);
      fileToAsset.putIfAbsent(format.root, () => event.asset);

      format.resources.forEach((file) {
        fileToProgress.putIfAbsent(file, () => 0);
        fileToAsset.putIfAbsent(file, () => event.asset);
      });

      var saveFolder = event.asset.name.replaceFirst("assets/", "");
      print('folder:$saveFolder');

      var fullSavePath = path.join(dataDirectory, saveFolder);

      var dir = dart.Directory(fullSavePath);

      if (!dir.existsSync()) await dir.create();

      var rootid = await FlutterDownloader.enqueue(
          url: format.root.url,
          savedDir: fullSavePath,
          fileName: format.root.relativePath,
          headers: {"Accept-Encoding": "gzip,deflate"});

      print("put download into map, id:" + rootid);
      idToFile.putIfAbsent(rootid, () => format.root);

      format.resources.forEach((f) async {
        print("${f.relativePath}");
        var childid = await FlutterDownloader.enqueue(
            url: f.url,
            savedDir: fullSavePath,
            fileName: f.relativePath,
            headers: {"Accept-Encoding": "gzip,deflate"});
        idToFile.putIfAbsent(childid, () => f);
      });
    }
  }

  void deleteAssetAssetDownload(DeleteDownloadEvent event) {
    if (assetNameToProgress.containsKey(event.asset.name))
      assetNameToProgress.remove(event.asset.name);

    var format = event.asset.formats
        .firstWhere((format) => format.formatType == "GLTF2");

    if (fileToProgress.containsKey(format.root))
      fileToProgress.remove(format.root);

    if (fileToAsset.containsKey(format.root)) fileToAsset.remove(format.root);

    format.resources.forEach((file) {
      if (fileToProgress.containsKey(file)) fileToProgress.remove(file);

      if (fileToAsset.containsKey(file)) fileToAsset.remove(file);
    });

    idToFile.removeWhere((key, value) => value == format.root);

    format.resources.forEach((f) {
      idToFile.removeWhere((key, value) => value == f);
    });

    var saveFolder = event.asset.name.replaceFirst("assets/", "");
    print('folder:$saveFolder');

    var fullSavePath = path.join(dataDirectory, saveFolder);

    var dir = dart.Directory(fullSavePath);

    if (dir.existsSync()) dir.deleteSync(recursive: true);

    if (jsonDownloadFile.existsSync())
      jsonDownloadFile.writeAsStringSync(jsonEncode(assetNameToProgress));
  }
}
