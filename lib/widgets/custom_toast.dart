import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void show(
    String msg, {
    Color? bgColor,
    Color? textColor,
    int duration = 1,
    double fontSize = 16,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: bgColor ?? Colors.green,
      textColor: textColor ?? Colors.white,
      fontSize: fontSize,
    );
  }
}
