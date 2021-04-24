import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

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
      throw (e);
    } finally {
      _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        _connectivityResult = result;
      });
    }
  }

  void checkConnectivity() {
    if (networkNotifier.getConnectionResult() == ConnectivityResult.none) {
      throw ("Your device has no active internet");
    }
  }
}

final networkNotifier = NetworkNotifier();
