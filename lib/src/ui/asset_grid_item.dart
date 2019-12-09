import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/events/check_download_event.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/poly_downloads_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_pending_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_progress_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_ready_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/download/states/download_state.dart';
import 'package:flutter_unity_widget_example/src/ui/Animation/fade_slide_transition.dart';
import 'package:googleapis/poly/v1.dart';
import 'package:rxdart/rxdart.dart';

typedef GestureAssetTapCallback = void Function(Asset);

class AssetGridItem extends StatefulWidget {
  final Asset _asset;
  final GestureAssetTapCallback onTap;
  final GestureAssetTapCallback onDeleteTap;
  final Observable<DownloadState> stream;

  const AssetGridItem(this._asset, {this.stream, this.onTap, this.onDeleteTap});

  @override
  State<StatefulWidget> createState() => AssetGridState();
}

class AssetGridState extends State<AssetGridItem> {
  PolyDownloadsBloc _polyDownloadsBloc;

  @override
  void initState() {
    super.initState();
    _polyDownloadsBloc = BlocProvider.of<PolyDownloadsBloc>(context);
    _polyDownloadsBloc.add(CheckDownloadEvent(asset: widget._asset));
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
                        widget._asset.thumbnail.url != null
                            ? Image.network(
                                widget._asset.thumbnail.url,
                                loadingBuilder: loadingBuilder,
                              )
                            : Image.asset("assets/placeholder.png"),
                        Flex(direction: Axis.vertical, children: <Widget>[
                          Expanded(
                              child:
                                  BlocBuilder<PolyDownloadsBloc, DownloadState>(
                                      condition: (prevState, state) {
                            return state.asset == widget._asset;
                          }, builder: (context, state) {
                            return Transform(
                                transform: Matrix4.identity()..scale(-1.0),
                                alignment: FractionalOffset.center,
                                child: getProgressIndicatorByState(state));
                          }))
                        ]),
                      ]))),
              SizedBox(
                  height: 37.0,
                  child: Stack(children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: Text(widget._asset.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .apply(fontSizeFactor: 0.8)),
                        )),
                    BlocBuilder<PolyDownloadsBloc, DownloadState>(
                        condition: (prevState, state) {
                      return state.asset == widget._asset;
                    }, builder: (context, state) {
                      if (state is DownloadReadyState) {
                        return Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () => widget.onDeleteTap(widget._asset),
                                child: Icon(Icons.delete)));
                      } else {
                        return SizedBox();
                      }
                    })
                  ]))
            ],
          )),
    );
  }

  LinearProgressIndicator getProgressIndicatorByState(DownloadState state) {
    if (state is DownloadProgressState) {
      return LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(92, 0, 0, 0)),
        value: 1 - state.progress,
      );
    } else if (state is DownloadPendingState) {
      return LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(92, 0, 0, 0)),
        value: 1.0,
      );
    } else {
      return LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(92, 0, 0, 0)),
        value: 0,
      );
    }
  }
}
