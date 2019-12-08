import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/poly_query_bloc.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/states/poly_query_initial_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/states/poly_query_loaded_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/states/poly_query_loading_state.dart';
import 'package:flutter_unity_widget_example/src/blocs/poly/states/poly_query_state.dart';

import 'AssetGridItem.dart';

class PolyAssetsGrid extends StatelessWidget {
  const PolyAssetsGrid({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final GestureAssetTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return BlocBuilder<PolyBloc, PolyQueryState>(condition: (prevState, state) {
      if (state is PolyQueryLoadingState) {
        return !(prevState is PolyQueryLoadedState);
      }
      return true;
    }, builder: (
      context,
      state,
    ) {
      if (state is PolyQueryInitialState) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              Flexible(
                  child: Text(
                'Type a word',
                style: Theme.of(context).textTheme.display1,
              ))
            ],
          ),
        );
      } else if (state is PolyQueryLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is PolyQueryLoadedState) {
        return GridView.builder(
            itemCount: state.assetList.assets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.landscape ? 4 : 2,
                childAspectRatio:
                    orientation == Orientation.landscape ? 0.98 : 1.1),
            itemBuilder: (context, index) {
              return AssetGridItem(state.assetList.assets[index],
                  //downloadBloc.downloadsEventStream,
                  onTap: onTap);
            });
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              Flexible(
                  child: Text(
                'Type a word',
                style: Theme.of(context).textTheme.display1,
              ))
            ],
          ),
        );
      }
    });
  }
}
