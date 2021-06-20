import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:pyd/notifiers/network-notifier.dart';
import 'package:pyd/pages/main_page_viewer.dart';
import 'package:pyd/pages/page_viewer.dart';
import 'package:pyd/pages/pivot_detail_page.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:pyd/providers/main_page_viewer_provider.dart';
import 'package:pyd/providers/pivot_detail_page_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => MainPageViewerProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundMapProvider()),
        ChangeNotifierProvider(create: (_) => PivotDetailPageProvider()),
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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        backgroundColor: Colors.black,
        fontFamily: GoogleFonts.nunito(
                // fontStyle: FontStyle.normal,
                // height: 1.6,
                // letterSpacing: 2,
                // wordSpacing: 1,
                )
            .fontFamily,
      ),
      initialRoute: '/',
      routes: {
        '/main': (context) => MainPageViewer(),
        '/PivotDetailPage': (context) => PivotDetailPage(),
      },
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

  String? message;
  bool showRetry = false;
  FutureOr<void> fetchHomePage() async {
    try {
      // await _provider.fetchHomePageData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageViewer()),
      );
    } catch (e) {
      setState(() {
        message = e.toString();
        showRetry = true;
      });
    }
  }

  void connectivityError(error) {
    setState(() {
      showRetry = true;
      message = error.toString();
    });
  }

  void initWidgetState() {
    _provider = Provider.of<HomePageProvider>(context, listen: false);
    if (mounted) {
      networkNotifier
          .initNetworkConnectivity()
          .then((result) => fetchHomePage())
          .catchError((error) => connectivityError(error));
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
    print(showRetry);
    return Scaffold(
      body: Stack(
        children: [
          Visibility(
            visible: !showRetry,
            child: Center(
              child: SpinKitCircle(
                color: Colors.red,
                size: 50,
              ),
            ),
          ),
          Visibility(
            visible: showRetry,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(message ?? ""),
                  ElevatedButton(
                    child: Text("Retry"),
                    onPressed: retryFetch,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void retryFetch() {
    fetchHomePage();
    setState(() {
      showRetry = false;
      message = null;
    });
  }
}
