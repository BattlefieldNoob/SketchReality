import 'package:flutter/foundation.dart';
import 'package:flutter_sketchfab/models/list_assets_response.dart';

import 'sketchfab_query_state.dart';

class SketchfabQueryLoadedState extends SketchfabQueryState {
  final ListAssetsResponse assetList;

  SketchfabQueryLoadedState({@required this.assetList});
}
