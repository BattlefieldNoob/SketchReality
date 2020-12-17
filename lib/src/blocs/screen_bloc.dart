import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_sketchfab/models/asset.dart';
import 'package:flutter_sketchfab/models/list_assets_response.dart';
import 'package:flutter_unity_widget_example/src/models/run_config.dart';
import 'package:flutter_unity_widget_example/src/repositories/base_repository.dart';
import 'package:flutter_unity_widget_example/src/repositories/mock_assets_repository.dart';
import 'package:flutter_unity_widget_example/src/repositories/sketchfab_repository.dart';
import 'package:rxdart/rxdart.dart';

class ScreenBloc {
  static final BaseRepository _repository = currentConfig.isOnline
      ? SketchfabRepository.getRepo()
      : MockAssetsRepository.getRepo();

  PublishSubject<String> query;

  init() {
    print("Bloc Init");
    query = PublishSubject<String>();
  }

  Observable<List<Asset>> get assetList => query.stream
      .where((test) => test.isNotEmpty)
      .debounceTime(Duration(milliseconds: 600))
      .distinct()
      .transform(streamTransformer);

  final streamTransformer = StreamTransformer<String, List<Asset>>.fromHandlers(
      handleData: (query, sink) async {
    debugPrint("Transformer called with query:" + query);
    /* if(query.isEmpty){
          sink.add(List());
          return;
        }*/

    ListAssetsResponse state = await _repository.getDataByQuery(query);

    if (state != null) {
      sink.add(state.results);
    } else {
      sink.addError("State is null!");
    }
  });

  Function(String) get changeQuery => query.sink.add;

  void dispose() {
    query.close();
  }
}

final bloc = ScreenBloc();
