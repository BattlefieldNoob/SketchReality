import 'package:flutter/foundation.dart';

import 'search_event.dart';

class ValidQuerySearchEvent extends SearchEvent {
  String query;

  ValidQuerySearchEvent({@required this.query});
}
