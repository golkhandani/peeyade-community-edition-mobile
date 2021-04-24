import 'dart:convert';
import 'package:pyd/models/envelop-notification.dart';

class Envelop {
  Envelop({
    this.data,
    this.notification,
  });

  dynamic data;
  EnvelopNotification? notification;

  factory Envelop.fromRawJson(String str) => Envelop.fromJson(json.decode(str));

  factory Envelop.fromJson(Map<String, dynamic> json) {
    return Envelop(
      data: json["data"] == null ? null : json["data"],
      notification: json["notification"] == null
          ? null
          : EnvelopNotification.fromJson(json["notification"]),
    );
  }
}
