import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';

enum NotificationType {
  Toast,
  Snack,
  Dialog,
}

class GlobalNotification {
  GlobalNotification({
    required this.notificationType,
    required this.message,
    this.backgroundColor = Colors.red,
    this.forgroundColor = Colors.white,
  });

  NotificationType notificationType;
  String message;
  Color backgroundColor;
  Color forgroundColor;
}

class GlobalNotifier with ChangeNotifier {
  static final GlobalNotifier _instance = GlobalNotifier._internal();

  GlobalNotifier._internal();

  factory GlobalNotifier() {
    return _instance;
  }

  GlobalNotification? _globalNotification;
  GlobalNotification? get globalNotification {
    return _globalNotification;
  }

  void create(GlobalNotification globalNotification) {
    _globalNotification = globalNotification;

    notifyListeners();
  }

  showSnackBar(BuildContext context) {
    final _snackBar = SnackBar(
      content: Text(
        _globalNotification!.message,
        style: TextStyle(
          color: _globalNotification!.forgroundColor,
        ),
      ),
      backgroundColor: _globalNotification!.backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  showToast(BuildContext context) {
    Toast.show(
      _globalNotification!.message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  showDialogBox(BuildContext context) async {
    final notif = globalNotifier._globalNotification;
    if (notif == null) return;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(notif.message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  clean() {
    _globalNotification = null;
  }

  show(BuildContext context) {
    switch (_globalNotification?.notificationType) {
      case NotificationType.Snack:
        globalNotifier.showSnackBar(context);
        break;
      case NotificationType.Toast:
        globalNotifier.showToast(context);
        break;
      case NotificationType.Dialog:
        globalNotifier.showDialogBox(context);
        break;
      default:
        globalNotifier.showToast(context);
    }
    clean();
  }
}

final globalNotifier = GlobalNotifier();
