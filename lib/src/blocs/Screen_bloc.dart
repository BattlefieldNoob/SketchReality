import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/src/models/RunConfig.dart';
import 'package:flutter_unity_widget_example/src/repositories/MockRepository.dart';
import 'package:flutter_unity_widget_example/src/repositories/Polyrepository.dart';
import 'package:flutter_unity_widget_example/src/repositories/BaseRepository.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:rxdart/rxdart.dart';

class ScreenBloc {

  static final BaseRepository _repository =
  currentConfig.isOnline ? PolyRepository.getRepo() : MockRepository.getRepo();

  PublishSubject<String> _query;

  init() {
    print("Bloc Init");
    _query = PublishSubject<String>();
  }

  Observable<List<Asset>> get photosList =>
      _query.stream
          .debounceTime(Duration(milliseconds: 800))
          .where((String value) => value.isNotEmpty)
          .distinct()
          .transform(streamTransformer);

  final streamTransformer = StreamTransformer<String, List<Asset>>.fromHandlers(
      handleData: (query, sink) async {
        debugPrint("Transformer Called");
        ListAssetsResponse state = await _repository.getDataByQuery(query);
        if (state != null && state.totalSize != 0) {
          sink.add(state.assets);
        }
      });

  Function(String) get changeQuery => _query.sink.add;

  void dispose() {
    _query.close();
  }
}

final bloc = ScreenBloc();
