import 'dart:convert';

import 'package:flutter/material.dart';
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


  Asset asset;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    asset=ModalRoute.of(context).settings.arguments as Asset;

    debugPrint("argument:$asset");

    return Scaffold(
      appBar: AppBar(
        title: Text('ARKIT Demo'),
      ),
      body:Text("MOMOMOM"));
  }


  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    print("UNITY CREATED!");

    /*var binfile=File();
    binfile.url="BoxTextured0.bin";
    binfile.relativePath="BoxTextured0.bin";

    var texfile=File();
    texfile.url="CesiumLogoFlat.png";
    texfile.relativePath="CesiumLogoFlat.png";

    var format=Format();
    format.resources=List<File>();
    format.resources.add(binfile);
    format.resources.add(texfile);
    format.formatType="GLTF_2";
    format.formatComplexity=FormatComplexity();

    var root=File();
    root.url="BoxTextured.gltf";
    root.relativePath="BoxTextured.gltf";

    format.root=root;

    
    var formats=List<Format>();
    formats.add(format);

    var asset=Asset();
    asset.name="BoxTextured.gltf";
    asset.formats = formats;*/

   /* var message=MessageHandler();
    message.name="PolyAsset";
    message.data=jsonEncode(this.asset);

    _unityWidgetController.postMessageToManager(message);*/
  }
}
