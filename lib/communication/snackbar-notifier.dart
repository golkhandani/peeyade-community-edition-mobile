import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api.dart';

const kBaseUrl = "api.jsonbin.io";

class SnackBarNotifier with ChangeNotifier {
  static final SnackBarNotifier _instance = SnackBarNotifier._internal();

  SnackBarNotifier._internal();

  factory SnackBarNotifier() {
    return _instance;
  }

  SnackBar? _snackBar;
  void createSnackBar(String message, Color color) {
    _snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    notifyListeners();
  }

  static void showSnackBar(BuildContext context) {
    if (snackBarNotifier._snackBar != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarNotifier._snackBar!);
    }
  }
}

final snackBarNotifier = SnackBarNotifier();
