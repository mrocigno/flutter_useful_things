/*
* Created to myfoodapp at 07/18/2020
*/
import "dart:developer" as dev;
import 'package:flutter_useful_things/constants/Colors.dart' as Constants;

extension DoubleExtensions on double {

  String toFormattedString(int decimals, {String decimalSeparator = "."}) {
    return this.toStringAsFixed(decimals).replaceAll(".", decimalSeparator);
  }

}