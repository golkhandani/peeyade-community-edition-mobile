import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pyd/notifiers/network-notifier.dart';
import 'package:pyd/models/envlop.dart';

class ApiCall {
  static String baseURL = 'api.jsonbin.io';
  static String homePage = 'b/6072ba8fee971419c4d63894/7';
  static Future<T> fetch<T>(
    String endpoint,
    FutureOr<T> Function(dynamic) parser,
  ) async {
    try {
      networkNotifier.checkConnectivity();
      http.Response response = await http.get(Uri.https(baseURL, endpoint));
      Envelop envelop = Envelop.fromRawJson(response.body);
      return await compute(parser, envelop.data);
    } catch (e) {
      throw (e);
    }
  }
}
