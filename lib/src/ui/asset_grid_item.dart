import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sketchfab/models/asset.dart';
import 'package:flutter_unity_widget_example/src/ui/Animation/fade_slide_transition.dart';

typedef GestureAssetTapCallback = void Function(Asset);

class AssetGridItem extends StatefulWidget {
  final Asset _asset;
  final GestureAssetTapCallback onTap;
  final GestureAssetTapCallback onDeleteTap;

  const AssetGridItem(this._asset, {this.onTap, this.onDeleteTap});

  @override
  State<StatefulWidget> createState() => AssetGridState();
}

class AssetGridState extends State<AssetGridItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget loadingBuilder(
      BuildContext context, Widget original, ImageChunkEvent imageChunk) {
    if (imageChunk == null)
      return original;
    else
      return CircularProgressIndicator(
          value:
              imageChunk.cumulativeBytesLoaded / imageChunk.expectedTotalBytes);
  }

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10.0,
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: 180,
                  child: GestureDetector(
                      onTap: () => widget.onTap(widget._asset),
                      child:
                          Stack(alignment: Alignment.center, children: <Widget>[
                        widget._asset.thumbnails.images.first.url != null
                            ? Image.network(
                                widget._asset.thumbnails.images.first.url,
                                loadingBuilder: loadingBuilder,
                              )
                            : Image.asset("assets/placeholder.png"),
                      ]))),
              SizedBox(
                  height: 37.0,
                  child: Stack(children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: Text(widget._asset.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .apply(fontSizeFactor: 0.8)),
                        ))
                  ]))
            ],
          )),
    );
  }
}
