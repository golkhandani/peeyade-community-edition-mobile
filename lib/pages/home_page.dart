import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:pyd/communication/api-notifier.dart';
import 'package:pyd/communication/snackbar-notifier.dart';
import 'package:pyd/components/background_map.dart';
import 'package:pyd/components/bottom_navigation_bar.dart';
import 'package:pyd/components/horizontal_post_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HorizontalPostList _horizontalPostList = HorizontalPostList();
  BackgroundMap _backgroundMap = BackgroundMap();
  BottomNavigationRow _bottomNavigationRow = BottomNavigationRow();

  @override
  void initState() {
    snackBarNotifier.addListener(() => SnackBarNotifier.showSnackBar(context));
    apiCallNotifier.addListener(() => ApiCallNotifier.showSnackBar(context));
    super.initState();
  }

  @override
  void dispose() {
    snackBarNotifier
        .removeListener(() => SnackBarNotifier.showSnackBar(context));
    apiCallNotifier.removeListener(() => ApiCallNotifier.showSnackBar(context));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("buildHomePAge");
    return Scaffold(
      body: Stack(
        children: [
          _backgroundMap,
          _horizontalPostList,
        ],
      ),
      bottomNavigationBar: _bottomNavigationRow,
    );
  }
}
