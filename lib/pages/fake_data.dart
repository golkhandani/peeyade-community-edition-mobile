import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import "package:latlong/latlong.dart" as lt;
import 'package:pyd/app/pages/map_page.dart';
import 'package:pyd/helpers/from-hex-color.dart';
import 'package:pyd/pages/easter_egg_page.dart';
import 'package:pyd/pages/explore_page.dart';
import 'package:pyd/pages/global_theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.backgroundColor,
      child: CupertinoSwitch(
        value: theme.currentTheme == GlobalTheme.dark ? true : false,
        onChanged: (value) {
          setState(() {
            theme.switchTheme();
          });
        },
      ),
    );
  }
}

class ApplicationPage {
  ApplicationPage({
    required this.widget,
    required this.name,
    required this.path,
    required this.iconData,
    this.color,
  });

  Widget widget;
  String name;
  String path;
  IconData iconData;
  Color? color = Colors.amber;
}

final List<ApplicationPage> pages = [
  ApplicationPage(
    widget: MapPage(),
    name: "map",
    path: 'map',
    iconData: FlutterIcons.pin_drop_mdi,
    color: Colors.purple,
  ),
  ApplicationPage(
    widget: EasterEggPage(),
    name: "EasterEgg",
    path: "easter-egg",
    iconData: FlutterIcons.egg_easter_mco,
    color: fromHexColor("#3fd576"),
  ),
  ApplicationPage(
    widget: ExplorePage(),
    name: "Explore",
    path: "explore",
    iconData: FlutterIcons.map_mco,
    color: Colors.cyan,
  ),
  ApplicationPage(
    widget: Container(color: Colors.pinkAccent),
    name: "Explore",
    path: "explore",
    iconData: FlutterIcons.face_profile_mco,
    color: Colors.pinkAccent,
  ),
  ApplicationPage(
      widget: SettingPage(),
      name: "Explore",
      path: "explore",
      iconData: FlutterIcons.settings_mco,
      color: Colors.deepOrange),
  ApplicationPage(
      widget: Container(color: Colors.teal),
      name: "Explore",
      path: "explore",
      iconData: FlutterIcons.heart_mco,
      color: Colors.teal)
];

final String defaultFilter = "All (No filter)";
final List<String> mockCategories = [
  defaultFilter,
  "Fruit and vegetables",
  "Starchy food",
  "Dairy",
  "Protein",
  "Fat",
  "Yoghurt"
];

class Card {
  double score;
  String title;
  String subtitle;
  lt.LatLng geoLocation;
  Card({
    required this.score,
    required this.title,
    required this.subtitle,
    required this.geoLocation,
  });
}

final List<Card> cards = [
  Card(
    title: "Cafe France",
    subtitle:
        "Tootsie roll gingerbread chocolate bar sesame snaps donut tootsie roll.",
    score: 4.2,
    geoLocation: lt.LatLng(35.6892, 51.3990),
  ),
  Card(
    title: "Cafe Diamond",
    subtitle:
        "Tootsie roll gingerbread chocolate bar sesame snaps donut tootsie roll.",
    score: 4.2,
    geoLocation: lt.LatLng(35.6792, 51.3890),
  ),
  Card(
    title: "Cafe Godo",
    subtitle:
        "Tootsie roll gingerbread chocolate bar sesame snaps donut tootsie roll.",
    score: 4.2,
    geoLocation: lt.LatLng(35.6872, 51.3892),
  ),
  Card(
    title: "Cafe Graph",
    subtitle:
        "Tootsie roll gingerbread chocolate bar sesame snaps donut tootsie roll.",
    score: 4.2,
    geoLocation: lt.LatLng(35.6899, 51.3898),
  )
];
