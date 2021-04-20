import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pyd/communication/api-notifier.dart';
import 'package:pyd/communication/api.dart';

class NetworkNotifier with ChangeNotifier {
  static final NetworkNotifier _instance = NetworkNotifier._internal();

  NetworkNotifier._internal();

  factory NetworkNotifier() {
    return _instance;
  }

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  ConnectivityResult getConnectionResult() {
    return _connectivityResult;
  }

  Connectivity _connectivity = Connectivity();
  Future initNetworkConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _connectivityResult = await _connectivity.checkConnectivity();
      if (_connectivityResult == ConnectivityResult.none) {
        throw ("Your device has no active internet");
      }
    } catch (e) {
      // snackBarNotifier.createSnackBar(e.toString(), Colors.redAccent);
      throw (e);
    } finally {
      _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        _connectivityResult = result;
        if (_connectivityResult == ConnectivityResult.none) {
          // snackBarNotifier.createSnackBar(
          //   "Your device has no active internet",
          //   Colors.redAccent,
          // );
        } else {
          // snackBarNotifier.createSnackBar(
          //   "Your device connected internet",
          //   Colors.greenAccent,
          // );
        }
      });
    }
  }
}

final networkNotifier = NetworkNotifier();

void checkConnectivity() {
  if (networkNotifier.getConnectionResult() == ConnectivityResult.none) {
    throw ("Your device has no active internet");
  }
}
