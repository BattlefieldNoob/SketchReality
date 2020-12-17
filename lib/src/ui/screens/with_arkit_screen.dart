import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sketchfab/models/asset.dart';

class WithARkitScreen extends StatefulWidget {
  @override
  _WithARkitScreenState createState() => _WithARkitScreenState();
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.scene});

  String title;
  int scene;
}

class _WithARkitScreenState extends State<WithARkitScreen> {
  Asset asset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    asset = ModalRoute.of(context).settings.arguments as Asset;

    var url = asset.embedUrl +
        "?ui_infos=0&ui_watermark=0&ui_stop=1&ui_help=0&ui_vr=0&ui_settings=0&ui_inspector=0&ui_animations=0&ui_annotations=0&ui_hint=2&ui_theme=dark";

    debugPrint("argument:$asset");
    debugPrint("argument:${asset.embedUrl}");

    return Scaffold(
        appBar: AppBar(
          title: Text(asset.name),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            child: EasyWebView(
              src: url,
              // Use Html syntax
              isMarkdown: false,
              // Use markdown syntax
              convertToWidgets: false,
              // Try to convert to flutter widgets
              onLoaded: () {
                print("Loaded!");
              },
            )));
  }
}
