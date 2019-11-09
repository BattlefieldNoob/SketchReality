import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/src/repositories/MockRepository.dart';
import 'package:flutter_unity_widget_example/src/repositories/Polyrepository.dart';
import 'package:googleapis/poly/v1.dart';


class RepositoryCompanion{
  const RepositoryCompanion();
  BaseRepository create()=> throw "NO";
}

abstract class BaseRepository{

  static const Map<Type,RepositoryCompanion> _companion={
    PolyRepository: const PolyCompanion(),
    MockRepository: const MockCompanion(),
  };

  static RepositoryCompanion companion<X extends BaseRepository>()=>_companion[X];

  static BaseRepository _repository;

  static getRepo<V extends BaseRepository>(){
    debugPrint("base get Repo");
    if(_repository==null){
      debugPrint("Companion Create");
      _repository=companion<V>().create();
      debugPrint("type:"+_repository.runtimeType.toString());
    }
    return _repository;
  }

  Future<ListAssetsResponse> getDataByQuery(query);
}
