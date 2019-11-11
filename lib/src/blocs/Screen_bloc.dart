import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/src/models/RunConfig.dart';
import 'package:flutter_unity_widget_example/src/repositories/MockAssetsRepository.dart';
import 'package:flutter_unity_widget_example/src/repositories/PolyRepository.dart';
import 'package:flutter_unity_widget_example/src/repositories/BaseRepository.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:rxdart/rxdart.dart';

class ScreenBloc {

  static final BaseRepository _repository =
  currentConfig.isOnline ? PolyRepository.getRepo() : MockAssetsRepository.getRepo();

  PublishSubject<String> query;

  init() {
    print("Bloc Init");
    query = PublishSubject<String>();
  }

  Observable<List<Asset>> get assetList =>
      query.stream
          .where((test)=>test.isNotEmpty)
          .debounceTime(Duration(milliseconds: 600))
          .distinct()
          .transform(streamTransformer);


  final streamTransformer = StreamTransformer<String, List<Asset>>.fromHandlers(
      handleData: (query, sink) async {
        debugPrint("Transformer called with query:"+query);
       /* if(query.isEmpty){
          sink.add(List());
          return;
        }*/
        
        ListAssetsResponse state = await _repository.getDataByQuery(query);
        
        if (state != null) {
          sink.add(state.assets);
        }else{
          sink.addError("State is null!");
        }
      });

  Function(String) get changeQuery => query.sink.add;

  void dispose() {
    query.close();
  }
}

final bloc = ScreenBloc();
