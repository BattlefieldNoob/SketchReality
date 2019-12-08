import 'package:flutter/cupertino.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';
import 'package:googleapis/poly/v1.dart';

class CheckDownloadEvent extends DownloadEvent {
  Asset asset;

  CheckDownloadEvent({@required this.asset});
}
