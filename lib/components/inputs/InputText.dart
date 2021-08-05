
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
  final bool readOnly;
  final String icon;
  final double iconSize;
  final Color iconColor;
  final String hint;
  final String labelHint;
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
    this.iconSize = 30,
    this.iconColor,
    this.keyboardType = TextInputType.text,
    this.hint,
    this.labelHint,
    this.onTapIcon,
    this.margin,
    this.padding = const EdgeInsets.all(0),
    this.controller,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.focusNode,
    this.onTextChanged,
    this.autoFocus = false,
    this.readOnly = false,
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
        margin: widget.margin,
        child: Stack(
          alignment: Alignment.centerRight,
          overflow: Overflow.visible,
          children: [
            Container(
                padding: widget.padding.copyWith(
                  right: (widget.icon != null? 30 : widget.padding.right)
                ),
                alignment: Alignment.center,
                decoration: _theme.background,
                child: Wrap(
                  children: [
                    TextFormField(
                      readOnly: widget.readOnly,
                      controller: _controller,
                      cursorColor: _theme.style.color,
                      keyboardType: widget.keyboardType,
                      obscureText: widget.obscureText,
                      focusNode: widget.focusNode,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_controller?.mask?.length ?? 100)
                      ],
                      onFieldSubmitted: widget.onFieldSubmitted,
                      validator: (value) {
                        _controller.validate();
                        return;
                      },
                      style: _theme.style,
                      decoration: _theme.inputDecoration.copyWith(
                        hintText: widget.hint,
                        labelText: widget.labelHint
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
                          transform: Matrix4.translationValues(0, (_controller.hasError? 0 : 10), 0),
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
                      width: widget.iconSize,
                      height: widget.iconSize,
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
  const InputThemes({
    this.background,
    this.iconFit,
    this.style,
    this.inputDecoration
  });

  static InputThemes main = InputThemes(
    iconFit: BoxFit.scaleDown,
    background: BoxDecoration(
      color: Colors.white
    ),
    style: TextStyle(
      color: Colors.black,
    ),
    inputDecoration: InputDecoration(
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: Color.fromRGBO(0, 0, 0, .5)
      )
    )
  );

  final BoxDecoration background;
  final InputDecoration inputDecoration;
  final BoxFit iconFit;
  final TextStyle style;
}