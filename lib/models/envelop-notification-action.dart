import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pyd/helpers/from-hex-color.dart';
import 'package:pyd/helpers/to-font-weight.dart';

class EnvelopNotificationAction {
  EnvelopNotificationAction({
    this.iconURL,
    required this.title,
    required this.titleWeight,
    this.titleColorHex = Colors.black,
    this.backgroundColorHex = Colors.amber,
    required this.link,
  });

  String? iconURL;
  String title;
  FontWeight titleWeight;
  Color titleColorHex;
  Color backgroundColorHex;
  String link;

  factory EnvelopNotificationAction.fromRawJson(String str) =>
      EnvelopNotificationAction.fromJson(json.decode(str));

  factory EnvelopNotificationAction.fromJson(Map<String, dynamic> json) {
    return EnvelopNotificationAction(
      iconURL: json["iconURL"] != null ? json["iconURL"] : null,
      title: json["title"],
      titleWeight: toFontWeight(json["titleWeight"]),
      titleColorHex: fromHexColor(json["titleColorHex"]),
      backgroundColorHex: json["backgroundColorHex"] != null
          ? fromHexColor(json["backgroundColorHex"])
          : Colors.amberAccent,
      link: json["link"],
    );
  }
}
