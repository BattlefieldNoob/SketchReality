import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:path_provider/path_provider.dart';
import '../../blocs/poly_screen_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;


class PolyHomeScreen extends StatefulWidget {
  @override
  _PolyHomeScreenState createState() => _PolyHomeScreenState();
}

class _PolyHomeScreenState extends State<PolyHomeScreen> {

  String dataDirectory;

  @override
  void initState() {
    super.initState();
    bloc.init();
    FlutterDownloader.initialize().whenComplete((){
      FlutterDownloader.registerCallback(downloadCallback);
    });

    getExternalStorageDirectory().then((directory){
      dataDirectory=directory.path;
    });
  }

  static void downloadCallback(id,status,progress){
    print("id:$id progress:$progress");
    print("id:$id status:$status");
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PixelPerfect'),
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
                        suffixIcon: Icon(Icons.search)),
                    onChanged: (value) {
                      bloc.changeQuery(value);
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: StreamBuilder(
                    stream: bloc.photosList,
                    builder: (context, AsyncSnapshot<List<Asset>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return listItem(snapshot.data[index],context);
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

  Widget listItem(Asset result, BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              debugPrint('ontap:${result.name}');
              //debugPrint("passing argument:${result.urls}");
              Navigator.pushNamed(context, "/unity",arguments: result);
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
            },
            child: Container(
              child: Image.network(result.thumbnail.url),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Text(result.displayName, style: Theme.of(context).textTheme.display2),
              GestureDetector(
                onTap: (){
                  debugPrint('ontap:${result.name}');
                  //debugPrint("passing argument:${result.urls}");
                  //Navigator.pushNamed(context, "/unity");
                  var format=result.formats.firstWhere((f)=>f.formatType.contains("GLTF2"));
                  debugPrint('format:${format.root.url}');
                  var saveFolder=result.name.replaceFirst("assets/", "");
                  debugPrint('folder:${saveFolder}');

                  var fullSavePath=path.join(dataDirectory,saveFolder);
                  var dir=Directory(fullSavePath);
                  if(!dir.existsSync())
                    dir.createSync();

                  FlutterDownloader.enqueue(url: format.root.url, savedDir: fullSavePath, fileName: format.root.relativePath);
                  format.resources.forEach((f){
                    debugPrint("${f.relativePath}");
                    FlutterDownloader.enqueue(url: f.url, savedDir: fullSavePath, fileName: f.relativePath);
                  });
                },
                child:Icon(Icons.file_download)
              )
            ]
          ),
        ],
      ),
    );
  }
}
