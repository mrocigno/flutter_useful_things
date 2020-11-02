/*
* Created to myfoodapp at 06/13/2020
*/
import "dart:developer" as dev;

import 'package:flutter/material.dart';
import 'package:flutter_useful_things/components/textviews/TextStyles.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;
import 'package:flutter_useful_things/utils/Functions.dart';

class CardFolded extends StatelessWidget {

  final Widget child;
  final Color foldColor;
  final double foldSize;
  final Color backgroundColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsets padding;
  final String title;
  final String subtitle;
  final Function onMorePressed;

  CardFolded({
    @required this.title,
    @required this.foldColor,
    @required this.child,
    this.backgroundColor = Constants.Colors.BACKGROUND_MARBLE_HIGH,
    this.borderRadius = 5,
    this.elevation = 5,
    this.foldSize = 20,
    this.padding = const EdgeInsets.all(10),
    this.onMorePressed,
    this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    double foldSizePercent = foldSize * 100 / widthByPercent(context, 100);

    return Padding(
      padding: EdgeInsets.all(elevation),
      child: Material(
          elevation: elevation,
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    foldColor,
                    backgroundColor
                  ],
                  stops: [
                    (foldSizePercent / 100), 0
                  ],
                )
            ),
            padding: EdgeInsets.only(
                left: widthByPercent(context, foldSizePercent) + padding.left,
                right: padding.right,
                top: padding.top,
                bottom: padding.bottom
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title.toUpperCase(), style: TextStyles.poppinsBoldMedium),
                  (subtitle != null? (
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(subtitle, style: TextStyles.poppinsSmall),
                    )
                  ) : Wrap()),
                  Container(
                    height: 1,
                    color: Constants.Colors.BLACK_TRANSPARENT_LOWER,
                  ),
                  Container(
                    width: double.infinity,
                    child: child,
                  ),
                  (onMorePressed != null? (
                      Center(
                        child: SizedBox(
                          height: 30, width: 30,
                          child: IconButton(
                              icon: Icon(Icons.more_horiz),
                              onPressed: onMorePressed
                          ),
                        ),
                      )
                  ) : Wrap())
                ]
            ),
          )
      ),
    );
  }
}
