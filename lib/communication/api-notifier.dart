import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'api.dart';

const kBaseUrl = "api.jsonbin.io";

class ApiCallNotifier with ChangeNotifier {
  static final ApiCallNotifier _instance = ApiCallNotifier._internal();

  ApiCallNotifier._internal();

  factory ApiCallNotifier() {
    return _instance;
  }

  ApiNotification? _notification;
  ApiNotification? getNotifiaction() {
    return _notification;
  }

  void updateNotification(ApiNotification notification) {
    if (_notification == null) {
      _notification = notification;
      notifyListeners();
    }
  }

  void clearNotification() {
    _notification = null;
  }

  static void showSnackBar(BuildContext context) {
    var notif = apiCallNotifier.getNotifiaction()!;
    var snackBar = SnackBar(
      content: Text(notif.message!),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

final apiCallNotifier = ApiCallNotifier();
