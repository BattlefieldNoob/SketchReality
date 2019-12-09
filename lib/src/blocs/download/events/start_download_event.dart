import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';

class StartDownloadEvent extends DownloadEvent {
  StartDownloadEvent({@required asset}) : super(asset);
}
