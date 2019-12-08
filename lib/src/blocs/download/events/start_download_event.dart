import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';
import 'package:googleapis/poly/v1.dart';

class StartDownloadEvent extends DownloadEvent {
  Asset asset;
  String saveDir;

  StartDownloadEvent({@required this.asset, @required this.saveDir});
}
