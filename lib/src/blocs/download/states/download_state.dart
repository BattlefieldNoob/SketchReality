import 'package:googleapis/poly/v1.dart';

abstract class DownloadState {
  Asset asset;

  DownloadState(this.asset);
}
