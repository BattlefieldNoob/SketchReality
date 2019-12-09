import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/delete_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/start_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/poly_downloads_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/events/empty_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/events/update_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/events/valid_query_search_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/poly_query_bloc.dart';
import 'package:flutter_unity_widget_example/src/models/run_config.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:rxdart/rxdart.dart';

import '../poly_assets_grid.dart';

class PolyBlocHomeScreen extends StatefulWidget {
  @override
  _PolyBlocHomeScreenState createState() => _PolyBlocHomeScreenState();
}

class _PolyBlocHomeScreenState extends State<PolyBlocHomeScreen> {
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

  void onDeleteAssetClick(Asset asset) {
    _polyDownloadsBloc.add(DeleteDownloadEvent(asset));
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
      //downloadBloc.startDownload(asset.name, format, fullSavePath);
      _polyDownloadsBloc.add(StartDownloadEvent(asset: asset));
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
