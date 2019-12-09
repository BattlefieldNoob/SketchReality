import 'package:googleapis/poly/v1.dart';

abstract class DownloadEvent {
  Asset asset;

  DownloadEvent(this.asset);
}
