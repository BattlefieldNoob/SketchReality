import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/start_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/poly_downloads_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/events/empty_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/events/update_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/events/valid_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/poly_query_bloc.dart';
import 'package:flutter_unity_widget_example/src/models/RunConfig.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../poly_assets_grid.dart';

class PolyBlocHomeScreen extends StatefulWidget {
  @override
  _PolyBlocHomeScreenState createState() => _PolyBlocHomeScreenState();
}

class _PolyBlocHomeScreenState extends State<PolyBlocHomeScreen> {
  String dataDirectory;

  bool searchInProgress = false;

  bool isDownloaded = false;

  PolyBloc _polyBloc;

  PolyDownloadsBloc _polyDownloadsBloc;

  static Subject<String> querySubject = PublishSubject();

  Observable<String> queryStream =
      querySubject.debounceTime(Duration(milliseconds: 150)).distinct();

  Observable<String> debouncedQueryStream =
      querySubject.debounceTime(Duration(milliseconds: 800)).distinct();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      getExternalStorageDirectory().then((directory) {
        dataDirectory = directory.path;
      });
    } else {
      getApplicationDocumentsDirectory().then((directory) {
        dataDirectory = directory.path;
      });
    }

    _polyBloc = BlocProvider.of<PolyBloc>(context);
    _polyBloc.add(EmptyQuerySearchEvent());

    _polyDownloadsBloc = BlocProvider.of<PolyDownloadsBloc>(context);

    debouncedQueryStream.listen((query) {
      if (query.isEmpty || query.length <= 3) {
        print("empty query");
        _polyBloc.add(EmptyQuerySearchEvent());
      } else {
        print("valid query:" + query);
        _polyBloc.add(ValidQuerySearchEvent(query: query));
      }
    });

    queryStream.listen((query) async {
      if (query.isEmpty || query.length <= 3) {
        print("empty query");
        _polyBloc.add(EmptyQuerySearchEvent());
      } else {
        print("updated query:" + query);
        _polyBloc.add(UpdateQuerySearchEvent());
      }
    });
  }

  @override
  void dispose() {
    querySubject.close();
    super.dispose();
  }

  void onAssetClick(Asset asset) {
    if (!isDownloaded) {
      if (!currentConfig.isOnline) {
        debugPrint("Cannot Download on offline build");
        return;
      }
      //DOWNLOAD CODE!!!
      debugPrint('ontap:${asset.name}');
      //debugPrint("passing argument:${result.urls}");
      //Navigator.pushNamed(context, "/unity");
      var format =
          asset.formats.firstWhere((f) => f.formatType.contains("GLTF2"));
      debugPrint('format:${format.root.url}');
      var saveFolder = asset.name.replaceFirst("assets/", "");
      debugPrint('folder:${saveFolder}');

      var fullSavePath = path.join(dataDirectory, saveFolder);
      var dir = Directory(fullSavePath);
      if (!dir.existsSync()) dir.createSync();

      //downloadBloc.startDownload(asset.name, format, fullSavePath);
      _polyDownloadsBloc
          .add(StartDownloadEvent(asset: asset, saveDir: dataDirectory));
      //isDownloaded = true;
    } else {
      //OPEN UNITY CODE!
      if (!currentConfig.unityActive) {
        debugPrint("unity is not active");
        return;
      }

      debugPrint('ontap:${asset.name}');
      //debugPrint("passing argument:${result.urls}");
      Navigator.pushNamed(context, "/unity", arguments: asset);
      /*var format=result.formats.firstWhere((f)=>f.formatType.contains("GLTF2"));
              debugPrint('format:${format.root.url}');
              var saveFolder=result.name.replaceFirst("assets/", "");
              debugPrint('folder:${saveFolder}');

              var fullSavePath=path.join(dataDirectory,saveFolder);
              var dir=Directory(fullSavePath);
              if(!dir.existsSync())
                dir.createSync();

              FlutterDownloader.enqueue(url: format.root.url, savedDir: fullSavePath, fileName: path.basename(format.root.relativePath));
              format.resources.forEach((f){
                debugPrint("${result.displayName}${path.extension(f.relativePath)}");
                FlutterDownloader.enqueue(url: f.url, savedDir: fullSavePath, fileName: path.basename(f.relativePath));
              });*/

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poly AR'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter a word',
                        suffixIcon: Stack(children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 32,
                          ),
                          if (searchInProgress)
                            CircularProgressIndicator(strokeWidth: 2)
                        ])),
                    onChanged: (value) {
                      print("query:$value!");
                      querySubject.add(value);
                      //bloc.changeQuery(value);
                    },
                  ),
                ),
              ),
              Expanded(flex: 6, child: PolyAssetsGrid(onTap: onAssetClick)),
            ],
          ),
        ),
      ),
    );
  }
}
