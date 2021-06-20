import 'package:flutter/material.dart';
import 'package:pyd/constants.dart';

enum GlobalTheme { dark, light }

class GlobalThemeProvider extends ChangeNotifier {
  Color backgroundColor = Colors.grey[300]!;
  Color textColor = Colors.black;

  Color boxColor = Colors.white;
  Color boxShadowColor = Colors.black54;
  Color boxTextColor = Colors.black;

  Color accentColor = Colors.purple[300]!;
  Color accentTextColor = Colors.white;

  String mapTileLayer = kTileLayerUrl;

  Color mapUserPin = Colors.cyan;

  GlobalTheme currentTheme = GlobalTheme.light;
  switchTheme() {
    print(currentTheme);
    switch (this.currentTheme) {
      case GlobalTheme.light:
        changeThemeToDark();
        break;
      case GlobalTheme.dark:
        changeThemeToLight();
        break;
      default:
        changeThemeToLight();
    }
    notifyListeners();
  }

  changeThemeToDark() {
    backgroundColor = Colors.grey[900]!;
    textColor = Colors.white;
    boxColor = Colors.black;
    boxShadowColor = Colors.white54;
    boxTextColor = Colors.white;
    accentColor = Colors.purple[700]!;
    accentTextColor = Colors.white;
    mapTileLayer = kDarkTileLayerUrl;
    currentTheme = GlobalTheme.dark;
  }

  changeThemeToLight() {
    backgroundColor = Colors.grey[300]!;
    textColor = Colors.black;
    boxColor = Colors.white;
    boxShadowColor = Colors.black54;
    boxTextColor = Colors.black;
    accentColor = Colors.cyan[300]!;
    accentTextColor = Colors.black;
    mapTileLayer = kTileLayerUrl;
    currentTheme = GlobalTheme.light;
  }
}

final GlobalThemeProvider theme = GlobalThemeProvider();
