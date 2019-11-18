import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
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

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'AR World Map', scene: 0),
  CustomPopupMenu(title: 'Face Mesh', scene: 1),
  CustomPopupMenu(title: 'Check Support', scene: 2),
  CustomPopupMenu(title: 'Camera Image', scene: 3),
  CustomPopupMenu(title: 'Environment Probes', scene: 4),
  CustomPopupMenu(title: 'AR Core Face Regions', scene: 5),
  CustomPopupMenu(title: 'ARKit Face Blend Shapes', scene: 6),
  CustomPopupMenu(title: 'Face Pose', scene: 7),
  CustomPopupMenu(title: 'Human Body Tracking 2D', scene: 8),
  CustomPopupMenu(title: 'Human Body Tracking 3D', scene: 9),
  CustomPopupMenu(title: 'Human Segmentation Images', scene: 10),
  CustomPopupMenu(title: 'Image Tracking', scene: 11),
  CustomPopupMenu(title: 'Light Estimation', scene: 12),
  CustomPopupMenu(title: 'Object Tracking', scene: 13),
  CustomPopupMenu(title: 'Feathered planes', scene: 14),
  CustomPopupMenu(title: 'Toggle Plane Detection', scene: 15),
  CustomPopupMenu(title: 'Scale', scene: 16),
  CustomPopupMenu(title: 'Simple AR', scene: 17),
];

class _WithARkitScreenState extends State<WithARkitScreen> {

  UnityWidgetController _unityWidgetController;

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
      body:UnityWidget(
              onUnityViewCreated: onUnityCreated,
              isARScene: true,
              onUnityMessage: onUnityMessage,
            ),
        );
  }


  void onUnityMessage(controller, message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this._unityWidgetController = controller;

    print("UNITY CREATED!");

    var binfile=File();
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
    asset.formats = formats;

    var message=MessageHandler();
    message.name="PolyAsset";
    message.data=jsonEncode(this.asset);

    _unityWidgetController.postMessageToManager(message);
  }
}
