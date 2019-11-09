import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/screens/with_arkit_screen.dart';
import 'package:flutter_unity_widget_example/src/models/RunConfig.dart';
import 'package:flutter_unity_widget_example/src/ui/homescreen/Home_screen.dart';

void main() {
  RunConfig()
    ..isOnline = false
    ..unityActive = false;

  runApp(MaterialApp(
    title: "cavallo",
    initialRoute: '/',
    routes: {
      '/': (context) => PolyHomeScreen(),
      '/unity': (context) => WithARkitScreen()
    },
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff3A3B56),
        cardColor: Color(0xff40415D),
        scaffoldBackgroundColor: Color(0xff3A3B56)),
  ));
}
