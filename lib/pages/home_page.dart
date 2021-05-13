import 'package:flutter/material.dart';
import 'package:pyd/components/navigation-bar-button.dart';
import 'package:pyd/notifiers/global_notifier.dart';
import 'package:provider/provider.dart';
import 'package:pyd/notifiers/location-notifier.dart';
import 'package:pyd/components/background_map.dart';
import 'package:pyd/components/home_page_summary_card_list.dart';
import 'package:pyd/providers/home_page_provider.dart';

Future<void> getLocation() async {
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // !Location Getter

  // !

  late Widget _topGradient = buildTopGradient();
  late Widget _bottomGradient = buildBottomGradient();
  late Widget _topButton = buildTopButtonContainer();
  late Widget _postList = buildPostList();
  late Widget _backgroundMap = buildBackgroundMap();

  @override
  void initState() {
    print("init State => HomePage");

    super.initState();
    if (mounted) {
      getLocation();
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
          _backgroundMap,
          _bottomGradient,
          _topGradient,
          _postList,
          _topButton,
          Align(
            alignment: Alignment.topLeft,
            child: Switch(
              value: context.watch<HomePageProvider>().direction ==
                  TextDirection.ltr,
              onChanged: (value) {
                setState(() {
                  context.read<HomePageProvider>().changeDirection();
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  HomePageSummaryCardList buildPostList() {
    return HomePageSummaryCardList();
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
              context.read<HomePageProvider>().goToUserLocation();
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

  IgnorePointer buildBottomGradient() {
    print("buildTopGradient");
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 160,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
