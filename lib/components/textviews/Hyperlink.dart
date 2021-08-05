
import 'package:flutter/material.dart';
import 'package:flutter_useful_things/components/textviews/PaddingText.dart';

import 'TextStyles.dart';

class Hyperlink extends StatelessWidget {

  final String data;
  final TextStyle style;
  final onPress;
  final EdgeInsets padding;
  final WrapAlignment wrapAlignment;
  final TextAlign textAlign;

  Hyperlink(
    this.data, {
      this.onPress,
      this.style,
      this.wrapAlignment,
      this.textAlign,
      this.padding
    }
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: wrapAlignment ?? WrapAlignment.start,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPress,
            child: PaddingText(data, style: style, textAlign: textAlign, padding: padding)
          ),
        )
      ],
    );
  }
}