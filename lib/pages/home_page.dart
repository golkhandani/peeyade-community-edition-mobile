import 'package:flutter/material.dart';
import 'package:pyd/communication/global_notifier.dart';
import 'package:provider/provider.dart';
import 'package:pyd/communication/location-notifier.dart';
import 'package:pyd/components/background_map.dart';
import 'package:pyd/components/horizontal_post_list.dart';
import 'package:pyd/pages/main_page_viewer.dart';
import 'package:pyd/providers/home_page_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // !Location Getter
  Future<void> _getLocation() async {
    if (locationNotifier.status == LocationStatus.available) {
      return;
    }
    try {
      locationNotifier.setMyLocation();
    } catch (err) {
      final notif = GlobalNotification(
        message: "Can't access location data!",
        notificationType: NotificationType.Dialog,
      );
      globalNotifier.create(notif);
    }
  }
  // !

  late Widget _topGradient = buildTopGradient();
  late Widget _topButton = buildTopButtonContainer();
  late Widget _postList = buildPostList();
  late Widget _backgroundMap = buildBackgroundMap();

  @override
  void initState() {
    print("init State => HomePage");
    super.initState();
    if (mounted) {
      _getLocation();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build => HomePage");
    return SafeArea(
      child: Stack(
        children: [
          // GestureDetector(
          //   onDoubleTap: () => print("double tap"),
          //   onTap: () => print("tap"),
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     color: Colors.red,
          //   ),
          // ),
          _backgroundMap,
          _postList,
          _topGradient,
          _topButton,
        ],
      ),
    );
  }

  HorizontalPostList buildPostList() {
    return HorizontalPostList();
  }

  BackgroundMap buildBackgroundMap() {
    return BackgroundMap();
  }

  Container buildTopButtonContainer() {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          NavigationBarButton(
            enable: false,
            icon: Icons.search,
            onPressed: () {
              final notif = GlobalNotification(
                message: "Search",
                notificationType: NotificationType.Dialog,
              );
              globalNotifier.create(notif);
            },
          ),
          NavigationBarButton(
            enable: false,
            icon: Icons.my_location,
            onPressed: () {
              context.read<BackgroundMapProvider>().goToUserLocation();
            },
          ),
        ],
      ),
    );
  }

  IgnorePointer buildTopGradient() {
    print("buildTopGradient");
    return IgnorePointer(
      child: Container(
        alignment: Alignment.topCenter,
        height: 160,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.0),
            ],
          ),
        ),
      ),
    );
  }
}
