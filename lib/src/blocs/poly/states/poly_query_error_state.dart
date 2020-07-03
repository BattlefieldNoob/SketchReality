import 'package:flutter/foundation.dart';

import '../states/poly_query_state.dart';

enum ErrorType { NoAssetsFound, Exception }

class PolyQueryErrorState extends PolyQueryState {
  ErrorType errorType;

  PolyQueryErrorState({@required this.errorType});
}
