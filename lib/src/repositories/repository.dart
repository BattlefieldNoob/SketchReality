import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/src/repositories/Polyrepository.dart';


class RepositoryCompanion{
  const RepositoryCompanion();
  BaseRepository create()=> throw "NO";
}

abstract class BaseRepository<T>{

  static const Map<Type,RepositoryCompanion> _companion={
    BaseRepository: const RepositoryCompanion(),
    PolyRepository: const PolyCompanion()
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

  Future<T> getDataByQuery(query);
}
