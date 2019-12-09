import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/src/repositories/base_repository.dart';
import 'package:googleapis/poly/v1.dart';

import 'events/search_event.dart';
import 'events/update_query_search_event.dart';
import 'events/valid_query_search_event.dart';
import 'states/poly_query_initial_state.dart';
import 'states/poly_query_loaded_state.dart';
import 'states/poly_query_loading_state.dart';
import 'states/poly_query_state.dart';

class PolyBloc extends Bloc<SearchEvent, PolyQueryState> {
  BaseRepository repository;

  PolyBloc({@required this.repository});

  @override
  PolyQueryState get initialState => PolyQueryInitialState();

  @override
  Stream<PolyQueryState> mapEventToState(SearchEvent event) async* {
    print("event!");
    if (event is ValidQuerySearchEvent) {
      yield PolyQueryLoadingState();
      try {
        ListAssetsResponse result =
            await repository.getDataByQuery(event.query);
        yield PolyQueryLoadedState(assetList: result);
        print("data is ready!");
      } catch (e) {}
    } else if (event is UpdateQuerySearchEvent) {
      print("loading!");
      yield PolyQueryLoadingState();
    } else {
      yield PolyQueryInitialState();
    }
  }
}
