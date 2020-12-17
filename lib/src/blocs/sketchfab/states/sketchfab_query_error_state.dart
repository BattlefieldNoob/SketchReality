import 'package:flutter/foundation.dart';

import 'sketchfab_query_state.dart';

enum ErrorType { NoAssetsFound, Exception }

class SketchfabQueryErrorState extends SketchfabQueryState {
  ErrorType errorType;

  SketchfabQueryErrorState({@required this.errorType});
}
