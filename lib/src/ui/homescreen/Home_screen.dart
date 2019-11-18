import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_unity_widget_example/src/blocs/Downloads_bloc.dart';
import 'package:flutter_unity_widget_example/src/models/RunConfig.dart';
import 'package:flutter_unity_widget_example/src/ui/AssetGridItem.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:path_provider/path_provider.dart';
import '../../blocs/Screen_bloc.dart';

import 'package:path/path.dart' as path;

class PolyHomeScreen extends StatefulWidget {
  @override
  _PolyHomeScreenState createState() => _PolyHomeScreenState();
}

class _PolyHomeScreenState extends State<PolyHomeScreen> {
  String dataDirectory;

  bool searchInProgress = false;

  bool isDownloaded=false;

  @override
  void initState() {
    super.initState();
    bloc.init();
    downloadBloc.init();

    if (Platform.isAndroid) {
      getExternalStorageDirectory().then((directory) {
        dataDirectory = directory.path;
      });
    } else {
      getApplicationDocumentsDirectory().then((directory) {
        dataDirectory = directory.path;
      });
    }

    /* bloc.query.debounceTime(Duration(microseconds: 600100)).listen((l) {
      if (l.isEmpty) {
        //if (searchInProgress)
          /*setState(() {
            searchInProgress = false;
          });*/
      } else {
        /*if (!searchInProgress) {
          print("DATA REQUESTED");
          setState(() {
            searchInProgress = true;
          });
        }*/
      }
    });

    bloc.assetList.listen((p) {
      print("DATA IS READY");
      setState(() {
        searchInProgress = false;
      });
    });*/
  }

  @override
  void dispose() {
    bloc.dispose();
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

      downloadBloc.startDownload(asset.name, format, fullSavePath);
      isDownloaded=true;
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
                      bloc.changeQuery(value);
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: StreamBuilder(
                    stream: bloc.assetList,
                    builder: (context, AsyncSnapshot<List<Asset>> snapshot) {
                      if (snapshot.hasData) {
                        return OrientationBuilder(
                            builder: (context, orientation) {
                          return GridView.builder(
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          orientation == Orientation.landscape
                                              ? 4
                                              : 2,
                                      childAspectRatio:
                                          orientation == Orientation.landscape
                                              ? 0.98
                                              : 1.1),
                              itemBuilder: (context, index) {
                                return AssetGridItem(snapshot.data[index],
                                    downloadBloc.downloadsEventStream,
                                    onTap: onAssetClick);
                              });
                        });
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Flexible(
                                  child: Text(
                                'Type a word',
                                style: Theme.of(context).textTheme.display1,
                              ))
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
