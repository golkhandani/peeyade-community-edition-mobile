import 'package:flutter/material.dart';
import 'package:pyd/components/navigation-bar-button.dart';
// import 'package:provider/provider.dart';
import 'package:pyd/notifiers/global_notifier.dart';
import 'package:pyd/pages/home_page.dart';

class MainPageViewer extends StatefulWidget {
  @override
  _MainPageViewerState createState() => _MainPageViewerState();
}

class _MainPageViewerState extends State<MainPageViewer> {
  void showGlobalNotification() => globalNotifier.show(context);
  final _homePage = HomePage();
  final _globalNotificationTests = GlobalNotificationTests();
  final _page3 = SizedBox.expand(
    child: Container(
      color: Colors.amber,
    ),
  );
  final _page4 = SizedBox.expand(
    child: Container(
      color: Colors.red,
    ),
  );
  final _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.999,
  );

  List<Widget> _pages = [];
  int selectedPageIndex = 0;
  changePage(index) {
    setState(() {
      selectedPageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    print("_MainPageViewerState");
    globalNotifier.addListener(showGlobalNotification);
    _pages = [
      _homePage,
      _globalNotificationTests,
      _page3,
      _page4,
    ];
    super.initState();
  }

  @override
  void dispose() {
    globalNotifier.removeListener(showGlobalNotification);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build => MainPageViewer");
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  PageView buildPageView() {
    return PageView.builder(
      controller: _pageController,
      allowImplicitScrolling: false,
      pageSnapping: false,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, index) {
        return _pages[index];
      },
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      height: 64,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavigationBarButton(
            onPressed: () => changePage(0),
            icon: Icons.home,
            enable: selectedPageIndex == 0,
          ),
          NavigationBarButton(
            onPressed: () => changePage(1),
            icon: Icons.list,
            enable: selectedPageIndex == 1,
          ),
          NavigationBarButton(
            onPressed: () => changePage(2),
            icon: Icons.favorite_border,
            enable: selectedPageIndex == 2,
          ),
          NavigationBarButton(
            onPressed: () => changePage(3),
            icon: Icons.person,
            enable: selectedPageIndex == 3,
          ),
        ],
      ),
    );
  }
}

class GlobalNotificationTests extends StatelessWidget {
  const GlobalNotificationTests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("GlobalNotificationTests");
    return Container(
      color: Colors.green,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Snackbar"),
            onPressed: () {
              final notif = GlobalNotification(
                notificationType: NotificationType.Snack,
                message: "message",
              );
              globalNotifier.create(notif);
            },
          ),
          ElevatedButton(
            child: Text("Toast"),
            onPressed: () {
              final notif = GlobalNotification(
                notificationType: NotificationType.Toast,
                message: "message",
              );
              globalNotifier.create(notif);
            },
          ),
          ElevatedButton(
            child: Text("Dialog"),
            onPressed: () {
              final notif = GlobalNotification(
                notificationType: NotificationType.Dialog,
                message: "message",
              );
              globalNotifier.create(notif);
            },
          )
        ],
      ),
    );
  }
}
