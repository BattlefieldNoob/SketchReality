import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/src/repositories/BaseRepository.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class PolyCompanion implements RepositoryCompanion {
  const PolyCompanion();

  @override
  PolyRepository create() {
    debugPrint("Create called!");
    return PolyRepository.protected();
  }
}

class PolyRepository implements BaseRepository {
  static final client =
      clientViaApiKey("AIzaSyDfghpbxrIRgos0Jgc5T1OB5t98uXS2ImA");

  final PolyApi _api = PolyApi(client);

  PolyRepository.protected();

  factory PolyRepository.getRepo() {
    debugPrint("Poly Get Repo!");
    return BaseRepository.getRepo<PolyRepository>();
  }

  @override
  Future<ListAssetsResponse> getDataByQuery(query) async =>
      _api.assets.list(keywords: query, format: "gltf2");
}
