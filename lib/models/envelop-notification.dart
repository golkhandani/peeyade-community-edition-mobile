import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pyd/enums/envelop-notification-action-type.dart';
import 'package:pyd/helpers/from-hex-color.dart';
import 'package:pyd/helpers/to-envelop-notification-action-type.dart';
import 'package:pyd/models/envelop-notification-action.dart';

class EnvelopNotification {
  EnvelopNotification({
    // identity
    required this.type,
    this.backgroundColorHex = Colors.white,
    this.backgroundImageURL,
    // message
    this.iconURL,
    this.title,
    required this.message,
    // action
    required this.actions,
    this.timeoutActionLink,
    this.duration,
  });

  EnvelopNotificationActionType type;
  Color backgroundColorHex;
  String? backgroundImageURL;

  String? iconURL;
  String? title;

  String message;

  List<EnvelopNotificationAction> actions;
  String? timeoutActionLink;
  Duration? duration;

  factory EnvelopNotification.fromRawJson(String str) =>
      EnvelopNotification.fromJson(json.decode(str));

  factory EnvelopNotification.fromJson(Map<String, dynamic> json) {
    return EnvelopNotification(
      type: toEnvelopNotificationActionType(json["type"]),
      backgroundColorHex: json["backgroundColorHex"] != null
          ? fromHexColor(json["backgroundColorHex"])
          : Colors.white,
      backgroundImageURL: json["backgroundImageURL"] != null
          ? json["backgroundImageURL"]
          : null,
      iconURL: json["iconURL"] != null ? json["iconURL"] : null,
      title: json["title"] != null ? json["title"] : null,
      message: json["message"],
      actions: json["actions"] != null
          ? json["actions"]
              .map<EnvelopNotificationAction>(
                (json) => EnvelopNotificationAction.fromJson(json),
              )
              .toList()
          : null,
      timeoutActionLink:
          json["timeoutActionLink"] != null ? json["timeoutActionLink"] : null,
      duration: json["duration"] != null
          ? Duration(milliseconds: json["duration"])
          : null,
    );
  }
}
