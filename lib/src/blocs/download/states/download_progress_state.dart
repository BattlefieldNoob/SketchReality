import 'package:flutter/cupertino.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_state.dart';

class DownloadProgressState extends DownloadState {
  double progress = 0;

  DownloadProgressState(asset, {@required this.progress}) : super(asset);
}
