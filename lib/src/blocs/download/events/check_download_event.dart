import 'package:flutter/cupertino.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';

class CheckDownloadEvent extends DownloadEvent {
  CheckDownloadEvent({@required asset}) : super(asset);
}
