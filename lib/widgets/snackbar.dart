import 'package:flutter/material.dart';

class MyMessangeHandler {
  static void showSnackbar(var scaffoldKey, String message) {
    scaffoldKey.currentState!.hideCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(
          seconds: 3,
        ),
        backgroundColor: Colors.amber,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        )));
  }
}
