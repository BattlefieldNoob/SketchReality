import 'package:flutter_unity_widget_example/src/blocs/download/events/download_event.dart';
import 'package:googleapis/poly/v1.dart';

class DeleteDownloadEvent extends DownloadEvent {
  DeleteDownloadEvent(Asset asset) : super(asset);
}
