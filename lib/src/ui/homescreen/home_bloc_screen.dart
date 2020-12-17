import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sketchfab/models/asset.dart';
import 'package:flutter_unity_widget_example/src/blocs/sketchfab/events/sketchfab_empty_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/sketchfab/events/sketchfab_update_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/sketchfab/events/sketchfab_valid_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/sketchfab/sketchfab_query_bloc.dart';
import 'package:flutter_unity_widget_example/src/models/run_config.dart';
import 'package:rxdart/rxdart.dart';

import '../assets_grid.dart';

class BlocHomeScreen extends StatefulWidget {
  @override
  _BlocHomeScreenState createState() => _BlocHomeScreenState();
}

class _BlocHomeScreenState extends State<BlocHomeScreen> {
  bool searchInProgress = false;

  bool isDownloaded = false;

  SketchfabBloc _Bloc;

  static Subject<String> querySubject = PublishSubject();

  Observable<String> queryStream =
      querySubject.debounceTime(Duration(milliseconds: 150)).distinct();

  Observable<String> debouncedQueryStream =
      querySubject.debounceTime(Duration(milliseconds: 800)).distinct();

  @override
  void initState() {
    super.initState();

    _Bloc = BlocProvider.of<SketchfabBloc>(context);
    _Bloc.add(SketchfabEmptyQuerySearchEvent());

    debouncedQueryStream.listen((query) {
      if (query.isEmpty || query.length <= 3) {
        print("empty query");
        _Bloc.add(SketchfabEmptyQuerySearchEvent());
      } else {
        print("valid query:" + query);
        _Bloc.add(SketchfabValidQuerySearchEvent(query: query));
      }
    });

    queryStream.listen((query) async {
      if (query.isEmpty || query.length <= 3) {
        print("empty query");
        _Bloc.add(SketchfabEmptyQuerySearchEvent());
      } else {
        print("updated query:" + query);
        _Bloc.add(SketchfabUpdateQuerySearchEvent());
      }
    });
  }

  @override
  void dispose() {
    querySubject.close();
    super.dispose();
  }

  void onDeleteAssetClick(Asset asset) {}

  void onAssetClick(Asset asset) {
    /*if (!_polyDownloadsBloc
        .isAssetDownloaded(CheckDownloadEvent(asset: asset))) {
      debugPrint("Downloading!");
      if (!currentConfig.isOnline) {
        debugPrint("Cannot Download on offline build");
        return;
      }
      //DOWNLOAD CODE!!!
      debugPrint('ontap:${asset.name}');
      //debugPrint("passing argument:${result.urls}");
      //Navigator.pushNamed(context, "/unity");
      //downloadBloc.startDownload(asset.name, format, fullSavePath);
      _polyDownloadsBloc.add(StartDownloadEvent(asset: asset));
      //isDownloaded = true;
    } else {*/
    debugPrint("Open Unity!");
    //OPEN UNITY CODE!
    if (!currentConfig.unityActive) {
      debugPrint("unity is not active");
      return;
    }

    debugPrint('ontap:${asset.name}');
    //debugPrint("passing argument:${result.urls}");
    Navigator.pushNamed(context, "/unity", arguments: asset);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SketchReality'),
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
              Expanded(
                  flex: 6,
                  child: PolyAssetsGrid(
                    onTap: onAssetClick,
                    onDeleteTap: onDeleteAssetClick,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
