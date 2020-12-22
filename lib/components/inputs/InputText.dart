
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_useful_things/components/inputs/FormValidate.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as dev;

import 'InputController.dart';

class EditText extends StatefulWidget {

  final InputThemes theme;
  final bool obscureText;
  final bool autoFocus;
  final String icon;
  final Color iconColor;
  final String hint;
  final TextInputType keyboardType;
  final Function(String value) onTapIcon;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;
  final InputController controller;
  final Function(String text) onTextChanged;

  EditText({
    this.theme,
    this.icon,
    this.iconColor,
    this.keyboardType = TextInputType.text,
    this.hint,
    this.onTapIcon,
    this.margin,
    this.padding,
    this.controller,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.focusNode,
    this.onTextChanged,
    this.autoFocus = false
  });

  @override
  EditTextState createState() => EditTextState();

}

class EditTextState extends State<EditText> {

  @override
  Widget build(BuildContext context) {
    final _theme = widget.theme ?? InputThemes.main;
    final _controller = widget.controller ?? InputController();
    if(widget.icon != null){
      _controller.setIcon(widget.icon);
    }

    FormValidateState.registerForValidate(context, this);

    return Container(
        padding: widget.padding,
        margin: widget.margin,
        child: Stack(
          alignment: Alignment.centerRight,
          overflow: Overflow.visible,
          children: [
            Container(
                height: 60,
                padding: EdgeInsets.only(
                    left: 20,
                    right: (widget.icon != null? 50 : 20)
                ),
                alignment: Alignment.center,
                decoration: _theme.background,
                child: Wrap(
                  children: [
                    TextFormField(
                      controller: _controller,
                      cursorColor: _theme.style.color,
                      keyboardType: widget.keyboardType,
                      obscureText: widget.obscureText,
                      focusNode: widget.focusNode,
                      onFieldSubmitted: widget.onFieldSubmitted,
                      validator: (value) {
                        _controller.validate();
                        return;
                      },
                      style: _theme.style,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hint,
                          hintStyle: TextStyle(
                              color: _theme.hintColor
                          )
                      ),
                      onChanged: (value) {
                        _controller.setError(null);
                        _controller.handleMask(value);
                        widget.onTextChanged?.call(value);
                      },
                    ),
                    StreamBuilder<String>(
                      stream: _controller.getErrorStream(),
                      builder: (ctx, snapshot) {
                        String errorMsg = snapshot.data;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: _controller.hasError? 20 : 0,
                          curve: Curves.ease,
                          transform: Matrix4.translationValues(0, (_controller.hasError? -10 : 10), 0),
                          child: Text(errorMsg ?? "",
                              style: TextStyle(color: Constants.Colors.RED_ERROR)
                          ),
                        );
                      },
                    )
                  ],
                )
            ),
            StreamBuilder<String>(
              stream: _controller.getIconStream(),
              builder: (ctx, snapshot) {
                if(!_controller.hasIcon) return Container();
                String path = snapshot.data;
                return Material(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: IconButton(
                      icon: Image.asset(path ?? widget.icon,
                        width: 30,
                        height: 30,
                        fit: _theme.iconFit,
                        color: widget.iconColor,
                      ),
                      onPressed: () => widget.onTapIcon?.call(_controller.text)
                  ),
                );
              },
            )
          ],
        )
    );
  }

}

class InputThemes {
  InputThemes({
    this.background, this.hintColor, this.iconFit, this.style
  });

  static InputThemes main = InputThemes(
      hintColor: Color.fromRGBO(0, 0, 0, .5),
      iconFit: BoxFit.scaleDown,
      background: BoxDecoration(
        color: Colors.white
      ),
    style: TextStyle(
      color: Colors.black,
    )
  );

  final BoxDecoration background;
  final Color hintColor;
  final BoxFit iconFit;
  final TextStyle style;
}