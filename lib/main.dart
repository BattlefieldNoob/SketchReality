import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/poly_downloads_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/poly_query_bloc.dart';
import 'package:flutter_unity_widget_example/src/repositories/poly_repository.dart';
import 'package:flutter_unity_widget_example/src/ui/homescreen/home_bloc_screen.dart';
import 'package:flutter_unity_widget_example/src/ui/screens/with_arkit_screen.dart';

void main() => runApp(MaterialApp(
      title: "cavallo",
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
            create: (context) => PolyDownloadsBloc(),
            child: BlocProvider(
                create: (context) =>
                    PolyBloc(repository: PolyRepository.getRepo()),
                child: PolyBlocHomeScreen())),
        '/unity': (context) => WithARkitScreen()
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xff3A3B56),
          cardColor: Color(0xff40415D),
          scaffoldBackgroundColor: Color(0xff3A3B56)),
    ));
