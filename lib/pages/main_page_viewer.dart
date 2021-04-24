import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:pyd/communication/global_notifier.dart';
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
  int selectedPageIndex = 0;
  List<Widget> _pages = [];

  changePage(index) {
    setState(() {
      selectedPageIndex = index;
      _pageController.jumpToPage(
        index,
        // duration: Duration(milliseconds: 400),
        // curve: Curves.easeIn,
      );
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

  IndexedStack buildIndexedStack() {
    return IndexedStack(
      index: selectedPageIndex,
      children: _pages,
    );
  }

  PageView buildPageView() {
    return PageView.builder(
      controller: _pageController,
      allowImplicitScrolling: false,
      pageSnapping: false,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
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

class NavigationBarButton extends StatelessWidget {
  NavigationBarButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.enable,
  }) : super(key: key);
  final void Function()? onPressed;
  final IconData icon;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      animationDuration: Duration(milliseconds: 300),
      constraints: BoxConstraints(
          maxHeight: 64, maxWidth: 64, minHeight: 64, minWidth: 64),
      elevation: 6,
      splashColor: Colors.transparent,
      enableFeedback: true,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: enable ? Colors.black87 : Colors.black38),
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.elliptical(120, 100)),
          shape: BoxShape.rectangle,
        ),
        child: Icon(
          icon,
          color: enable ? Colors.black87 : Colors.black38,
          size: 25,
        ),
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
