import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pyd/communication/api-notifier.dart';
import 'package:pyd/communication/network-notifier.dart';

class ApiNotification {
  ApiNotification({
    this.message,
    this.type,
  });

  String? message;
  String? type;

  factory ApiNotification.fromRawJson(String str) =>
      ApiNotification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiNotification.fromJson(Map<String, dynamic> json) =>
      ApiNotification(
        message: json["message"] == null ? null : json["message"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "type": type == null ? null : type,
      };
}

class ApiMeta {
  ApiMeta({
    this.status,
    this.date,
  });

  int? status;
  DateTime? date;

  factory ApiMeta.fromRawJson(String str) => ApiMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiMeta.fromJson(Map<String, dynamic> json) => ApiMeta(
        status: json["status"] == null ? null : json["status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "date": date == null ? null : date?.toIso8601String(),
      };
}

class Api {
  Api({
    this.data,
    this.meta,
    this.notification,
  });

  dynamic? data;
  ApiMeta? meta;
  ApiNotification? notification;

  factory Api.fromRawJson(String str) => Api.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      data: json["data"] == null ? null : json["data"],
      meta: json["meta"] == null ? null : ApiMeta.fromJson(json["meta"]),
      notification: json["notification"] == null
          ? null
          : ApiNotification.fromJson(json["notification"]),
    );
  }

  Map<String, dynamic> toJson() {
    dynamic jData;
    if (data! is List) {
      jData = (data! as List<dynamic>).map((x) => x.toJson()).toList();
    } else {
      jData = (data! as dynamic).toJson();
    }
    return {
      "data": data == null ? null : jData,
      "meta": meta == null ? null : meta!.toJson(),
      "notification": notification == null ? null : notification!.toJson(),
    };
  }

  static Future<T> fetch<T>() async {
    const endpoint = "b/6072ba8fee971419c4d63894/7";
    return await sendGetRequest(endpoint);
  }

  static Future fetchHomePageData() async {
    const endpoint = "b/6072ba8fee971419c4d63894/7";
    // Connection Issue => Retry
    // Response can not be parsed => server error => add notification if not exists
    // It is a ok response => should be parsed and send data to user
    return await sendGetRequest(endpoint);
  }
}

void checkResponse(int statusCode, dynamic response) {
  if (200 <= statusCode && statusCode < 400) {
    if (response?.data == null) {
      throw ("Data is Empty");
    }
  }
  // It is a bad request error => show error based on your notifications
  else if (statusCode == 400) {
    throw ("2 Device Not Connected to internet");
  }
  // It is a not found error => show not found error (page)
  else if (statusCode == 404) {
    final notification = response?.notification ??
        ApiNotification(
          message: "404 not found",
          type: "Banner",
        );
    apiCallNotifier.updateNotification(notification);
    throw ("2 Device Not Connected to internet");
  }
  // Is a server error!
  else {
    final notification = response?.notification ??
        ApiNotification(
          message: "Server Error",
          type: "Banner",
        );
    apiCallNotifier.updateNotification(notification);
    throw ("2 Device Not Connected to internet");
  }
}

void handleSocketException(ApiNotification? notification) {
  final _notification = notification ??
      ApiNotification(
        message: "Timeout Error",
        type: "Banner",
      );
  apiCallNotifier.updateNotification(_notification);
}

void handleServerException(ApiNotification? notification) {
  final _notification = notification ??
      ApiNotification(
        message: "Unknown Error",
        type: "Banner",
      );
  apiCallNotifier.updateNotification(_notification);
}

Future<dynamic> sendGetRequest(String endpoint) async {
  dynamic response;
  apiCallNotifier.clearNotification();
  checkConnectivity();

  try {
    http.Response res = await http.get(Uri.https(kBaseUrl, endpoint));
    response = Api.fromRawJson(res.body);
    checkResponse(res.statusCode, response);
    return response.data!;
  } on SocketException catch (e) {
    handleSocketException(response?.notification);
    throw (e);
  } catch (e) {
    handleServerException(response?.notification);
    throw (e);
  }
}
