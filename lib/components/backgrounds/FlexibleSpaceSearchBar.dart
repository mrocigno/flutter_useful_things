/*
* Created to flutter-components at 05/09/2020
*/
import "dart:developer" as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter_useful_things/components/inputs/InputController.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_useful_things/components/inputs/InputText.dart';
import 'package:flutter_useful_things/constants/Strings.dart';
import 'package:rxdart/rxdart.dart';

class FlexibleSpaceSearchBar extends StatefulWidget {

  final OnPerformSearch onPerformSearch;
  final String initialData;
  final Stream<bool> loadObserver;
  final Function(String text) onTextChanged;
  final String title;
  final String placeholder;
  final String heroTag;
  final InputThemes inputTheme;
  final Color titleColor;
  final String searchIconPath;

  FlexibleSpaceSearchBar({
    Key key,
    this.onPerformSearch,
    this.initialData,
    this.loadObserver,
    this.onTextChanged,
    this.title = "",
    this.placeholder = "",
    this.heroTag = "SearchField",
    this.inputTheme,
    this.titleColor = Colors.black,
    this.searchIconPath
  }) : super(key: key);

  @override
  FlexibleSpaceSearchBarState createState() => FlexibleSpaceSearchBarState();

}

typedef OnPerformSearch = Function(String search);

class FlexibleSpaceSearchBarState extends State<FlexibleSpaceSearchBar> {

  InputController _controller;
  String get searchText => _controller?.value?.text ?? "";
  set searchText(String value) => _controller.text = value;

  @override
  void initState() {
    super.initState();
    _controller = InputController(
      text: widget.initialData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final FlexibleSpaceBarSettings settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();

    final double deltaExtent = settings.maxExtent - settings.minExtent;

    // 1.0 -> Expanded
    // 0.0 -> Collapsed to toolbar
    final double t = (1 -(settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0) as double;

    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: Constants.Colors.BACKGROUND_MARBLE_LOW,
      padding: EdgeInsets.only(top: statusBarHeight),
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: (1 - t),
            child: Container(
              alignment: Alignment.center,
              height: 56,
              child: Text(widget.title, style: TextStyle(fontSize: 20, color: widget.titleColor),),
            )
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(left: (50 * t), right: (50 * t)),
            child: Hero(
              tag: widget.heroTag,
              child: Material(
                color: Colors.transparent,
                child: Input(widget.inputTheme ?? InputThemes.main,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  controller: _controller,
                  hint: widget.placeholder,
                  icon: widget.searchIconPath,
                  iconColor: Constants.Colors.PRIMARY_SWATCH,
                  onTextChanged: widget.onTextChanged,
                  onFieldSubmitted: (value) => widget.onPerformSearch?.call(value),
                  onTapIcon: (){
                    widget.onPerformSearch?.call(_controller.value.text);
                  },
                ),
              ),
            ),
          ),
          (widget.loadObserver != null? (
            Container(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<bool>(
                stream: widget.loadObserver,
                builder: (context, snapshot) {
                  if(snapshot.hasData && snapshot.data) return Container(height: 2, child: LinearProgressIndicator());
                  return Wrap();
                },
              ),
            )
          ) : (Wrap()))
        ],
      )
    );
  }

}