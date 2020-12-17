import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/sketchfab/sketchfab_query_bloc.dart';
import 'package:flutter_unity_widget_example/src/models/run_config.dart';
import 'package:flutter_unity_widget_example/src/repositories/mock_assets_repository.dart';
import 'package:flutter_unity_widget_example/src/ui/homescreen/home_bloc_screen.dart';
import 'package:flutter_unity_widget_example/src/ui/screens/with_arkit_screen.dart';

void main() {
  RunConfig()
    ..isOnline = false
    ..unityActive = true;

  runApp(MaterialApp(
    title: "cavallo",
    initialRoute: '/',
    routes: {
      '/': (context) => BlocProvider(
          create: (context) =>
              SketchfabBloc(repository: MockAssetsRepository.getRepo()),
          child: BlocHomeScreen()),
      '/unity': (context) => WithARkitScreen()
    },
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff3A3B56),
        cardColor: Color(0xff40415D),
        scaffoldBackgroundColor: Color(0xff3A3B56)),
  ));
}
