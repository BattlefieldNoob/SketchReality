
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/src/sprintf.dart';
import 'package:googleapis/poly/v1.dart';

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


  final String html = '''
  <!-- Import the component -->
   <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
  <script nomodule src="https://unpkg.com/@google/model-viewer/dist/model-viewer-legacy.js"></script>
  <!-- Use it like any other HTML element -->
  <model-viewer style="height:100%;width:100%;input:focus{outline: none;};" src="{{src}}" alt="A 3D model of an astronaut" auto-rotate ar camera-controls></model-viewer>"
  ''';

  Asset asset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    asset = ModalRoute.of(context).settings.arguments as Asset;
    asset.formats.forEach((element) {print(element.formatType);});
    var modelUrl = asset.formats.firstWhere((element) => element.formatType.contains("GLTF2"))?.root?.url;

    print(modelUrl);
    if(modelUrl==null){
      modelUrl="https://poly.googleapis.com/downloads/fp/1582670587239591/dtVRCEkNeK4/0xqBfdm5b3i/error%20pyramid.gltf";
    }
    var src=sprintf(html, [modelUrl]);

    debugPrint("argument:$asset");

    return Scaffold(
        appBar: AppBar(
          title: Text('ARKIT Demo'),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            child: EasyWebView(
          src: src,
          isHtml: true,
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
