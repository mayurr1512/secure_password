import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension Utility on String {
  toast() {
    return Fluttertoast.showToast(
      msg: this,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
  toastError() {
    Fluttertoast.showToast(
        msg: this,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red
    );
  }
}