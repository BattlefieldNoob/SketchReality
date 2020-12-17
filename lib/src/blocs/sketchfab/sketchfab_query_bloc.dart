import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sketchfab/models/list_assets_response.dart';
import 'package:flutter_unity_widget_example/src/repositories/base_repository.dart';

import 'events/sketchfab_search_event.dart';
import 'events/sketchfab_update_query_search_event.dart';
import 'events/sketchfab_valid_query_search_event.dart';
import 'states/sketchfab_query_error_state.dart';
import 'states/sketchfab_query_initial_state.dart';
import 'states/sketchfab_query_loaded_state.dart';
import 'states/sketchfab_query_loading_state.dart';
import 'states/sketchfab_query_state.dart';

class SketchfabBloc extends Bloc<SketchfabSearchEvent, SketchfabQueryState> {
  BaseRepository repository;

  SketchfabBloc({@required this.repository})
      : super(SketchfabQueryInitialState());

  @override
  Stream<SketchfabQueryState> mapEventToState(
      SketchfabSearchEvent event) async* {
    print("event!");
    if (event is SketchfabValidQuerySearchEvent) {
      yield SketchfabQueryLoadingState();
      try {
        ListAssetsResponse result =
            await repository.getDataByQuery(event.query);
        if (result.results == null)
          yield SketchfabQueryErrorState(errorType: ErrorType.NoAssetsFound);
        else
          yield SketchfabQueryLoadedState(assetList: result);
        print("data is ready!");
      } catch (e) {
        yield SketchfabQueryErrorState(errorType: ErrorType.Exception);
      }
    } else if (event is SketchfabUpdateQuerySearchEvent) {
      print("loading!");
      yield SketchfabQueryLoadingState();
    } else {
      yield SketchfabQueryInitialState();
    }
  }
}
