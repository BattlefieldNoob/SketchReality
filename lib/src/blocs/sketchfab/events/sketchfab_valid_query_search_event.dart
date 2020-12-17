import 'package:flutter/foundation.dart';

import 'sketchfab_search_event.dart';

class SketchfabValidQuerySearchEvent extends SketchfabSearchEvent {
  String query;

  SketchfabValidQuerySearchEvent({@required this.query});
}
