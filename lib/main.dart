import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:pyd/communication/api-notifier.dart';
import 'package:pyd/communication/api.dart';
import 'package:pyd/communication/global_notifier.dart';
import 'package:pyd/communication/network-notifier.dart';
import 'package:pyd/pages/main_page_viewer.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:pyd/providers/main_page_viewer_provider.dart';

/// This is a reimplementation of the default Flutter application using provider + [ChangeNotifier].

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => MainPageViewerProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundMapProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState<T> extends State<LoadingPage>
    with TickerProviderStateMixin {
  final Location location = Location();

  late HomePageProvider _provider;

  late AnimationController _animationController =
      AnimationController(vsync: this, duration: Duration(seconds: 3));

  // To handle loading progress
  Widget _widget = Container();
  late Widget _loading;

  void enableLoading() {
    setState(() {
      if (_animationController.isAnimating) _animationController.dispose();
      _widget = _loading;
    });
  }

  void fetchHomePageData() async {
    try {
      enableLoading();

      await _provider.fetchHomePageData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPageViewer()),
      );
    } catch (e) {
      final notification = apiCallNotifier.getNotifiaction() ??
          ApiNotification(
            message: e.toString(),
            type: 'Banner',
          );
      setState(() {
        _widget = _createRetry(notification, fetchHomePageData);
      });
    }
  }

  FutureOr<Null> thenNetworkInit(result) {
    fetchHomePageData();
  }

  catchNetworkInit(e) {
    final notification = apiCallNotifier.getNotifiaction() ??
        ApiNotification(
          message: e.toString(),
          type: 'Banner',
        );
    setState(() {
      _widget = _createRetry(notification, fetchHomePageData);
    });
  }

  void initWidgetState() {
    _loading = _createLoading();
    _provider = Provider.of<HomePageProvider>(context, listen: false);
    if (mounted) {
      networkNotifier
          .initNetworkConnectivity()
          .then(thenNetworkInit)
          .catchError(catchNetworkInit);
    }
  }

  @override
  void initState() {
    initWidgetState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.white, child: _widget),
    );
  }

  Center _createLoading() {
    return Center(
      child: SpinKitCircle(
        color: Colors.black,
        size: 50,
        controller: _animationController,
      ),
    );
  }

  Center _createRetry(ApiNotification notification, Function retry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(notification.message!),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: fetchHomePageData,
            child: Container(
              child: Text("Retry"),
            ),
          ),
        ],
      ),
    );
  }
}
