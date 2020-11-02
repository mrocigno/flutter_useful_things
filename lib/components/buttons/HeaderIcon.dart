/*
* Created to myfoodapp at 06/20/2020
*/
import "dart:developer" as dev;
import 'package:flutter/material.dart';
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;

class HeaderIcon extends StatelessWidget {

  final Color color;
  final IconData icon;
  final String imagePath;
  final Function onPressed;

  HeaderIcon({
    this.color,
    this.icon,
    this.imagePath = "",
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          icon: (imagePath == ""? (
            Icon(icon)
          ) : (
            Image.asset(imagePath, color: Colors.white)
          )),
          onPressed: onPressed,
          color: Colors.white
        ),
      ),
    );
  }
}
