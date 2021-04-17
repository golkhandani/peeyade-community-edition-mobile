import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pyd/communication/api-notifier.dart';
import 'package:pyd/communication/api.dart';
import 'package:pyd/communication/network-notifier.dart';
import 'package:pyd/communication/snackbar-notifier.dart';
import 'package:pyd/pages/home_page.dart';
import 'package:pyd/providers/home_page_provider.dart';

/// This is a reimplementation of the default Flutter application using provider + [ChangeNotifier].

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
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

  void showSnackBar() => SnackBarNotifier.showSnackBar(context);

  void registerApiNotifier() {
    snackBarNotifier.addListener(showSnackBar);
  }

  void unregisterApiNotifier() {
    snackBarNotifier.removeListener(showSnackBar);
  }

  void fetchHomePageData() async {
    try {
      enableLoading();
      await _provider.fetchHomePageData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
      registerApiNotifier();
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
    unregisterApiNotifier();
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
