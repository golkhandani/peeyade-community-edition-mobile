import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pyd/communication/global_notifier.dart';
import 'package:provider/provider.dart';
import 'package:pyd/components/background_map.dart';
import 'package:pyd/components/horizontal_post_list.dart';
import 'package:pyd/pages/main_page_viewer.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _horizontalPostList = HorizontalPostList();
  final _backgroundMap = BackgroundMap();

  // !Location Getter
  final Location location = Location();
  Future<void> _getLocation() async {
    try {
      final LocationData _locationResult = await location.getLocation();
      _homePageProvider.setMyLocaion(_locationResult);
    } catch (err) {
      final notif = GlobalNotification(
        message: "Can't access location data!",
        notificationType: NotificationType.Dialog,
      );
      globalNotifier.create(notif);
    }
  }

  // !

  Widget? _widget;

  late HomePageProvider _homePageProvider;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (mounted) {
      _homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
      _getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_widget == null) {
      print("build => HomePage");
      _widget = SafeArea(
        child: Stack(
          children: [
            ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color),
                child: _backgroundMap),
            _horizontalPostList,
            IgnorePointer(
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
            ),
            Container(
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
                      // final notif = GlobalNotification(
                      //   message: "Search",
                      //   notificationType: NotificationType.Dialog,
                      // );
                      // globalNotifier.create(notif);
                      context.read<HomePageProvider>().goToMyLocation();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    return _widget!;
  }
}
