import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/check_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/start_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_pending_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_state.dart';
import 'package:googleapis/poly/v1.dart';

import 'states/download_progress_state.dart';
import 'states/download_ready_state.dart';

class PolyDownloadsBloc extends Bloc<DownloadEvent, DownloadState> {
  var assetToProgress = Map<Asset, double>();
  var idToFile = Map<String, File>();
  var fileToProgress = Map<File, double>();
  var fileToAsset = Map<File, Asset>();

  ReceivePort _port = ReceivePort();

  PolyDownloadsBloc() {
    FlutterDownloader.initialize().whenComplete(() {
      IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      _port.listen(onDownloadIsolateMessage);
      FlutterDownloader.registerCallback(downloadCallback);
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
          if (assetToProgress.containsKey(asset))
            assetToProgress[asset] = sum / (format.resources.length + 1);

          add(CheckDownloadEvent(asset: asset));
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
      if (assetToProgress.containsKey(event.asset)) {
        var assetProgress = assetToProgress[event.asset];
        if (assetProgress == 1.0) {
          yield DownloadReadyState(event.asset);
        } else {
          yield DownloadProgressState(event.asset, progress: assetProgress);
        }
      } else {
        yield DownloadPendingState(event.asset);
      }
    } else if (event is StartDownloadEvent) {
      if (!assetToProgress.containsKey(event.asset)) {
        assetToProgress.putIfAbsent(event.asset, () => 0);

        var format = event.asset.formats
            .firstWhere((format) => format.formatType == "GLTF2");

        fileToProgress.putIfAbsent(format.root, () => 0);
        fileToAsset.putIfAbsent(format.root, () => event.asset);

        format.resources.forEach((file) {
          fileToProgress.putIfAbsent(file, () => 0);
          fileToAsset.putIfAbsent(file, () => event.asset);
        });

        print("adding download");
        var rootid = await FlutterDownloader.enqueue(
            url: format.root.url,
            savedDir: event.saveDir,
            fileName: format.root.relativePath,
            headers: {"Accept-Encoding": "gzip,deflate"});

        print("put download into map, id:" + rootid);
        idToFile.putIfAbsent(rootid, () => format.root);

        print("idtofile:" + idToFile.length.toString());

        print("ids:" + idToFile.keys.join("_"));
        format.resources.forEach((f) async {
          print("${f.relativePath}");
          var childid = await FlutterDownloader.enqueue(
              url: f.url,
              savedDir: event.saveDir,
              fileName: f.relativePath,
              headers: {"Accept-Encoding": "gzip,deflate"});
          idToFile.putIfAbsent(childid, () => f);
        });

        /* ([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0])
            .map((double) => Observable.just(double)
                .delay(Duration(milliseconds: 300 * (double * 10).toInt())))
            .forEach((observable) => observable.listen((value) {
                  print(value);
                  assetToProgress[event.asset] = value;
                  add(CheckDownloadEvent(asset: event.asset));
                }));*/
      }
    } else {
      throw Exception("event not recognized!");
    }
  }
}
