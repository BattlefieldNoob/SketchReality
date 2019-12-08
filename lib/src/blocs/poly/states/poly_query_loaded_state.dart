import 'package:flutter/foundation.dart';
import 'package:googleapis/poly/v1.dart';

import 'poly_query_state.dart';

class PolyQueryLoadedState extends PolyQueryState {
  ListAssetsResponse assetList;

  PolyQueryLoadedState({@required this.assetList});
}
