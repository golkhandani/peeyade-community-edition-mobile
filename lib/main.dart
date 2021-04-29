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
      // home: LoadingPage(),
      // theme: ThemeData(
      //   fontFamily: GoogleFonts.adamina(fontStyle: FontStyle.italic).fontFamily,
      // ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
        // When navigating to the "/" route, build the FirstScreen widget.
        '/main': (context) => MainPageViewer(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/${PivotDetailPage.path}': (context) => PivotDetailPage(),
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

  FutureOr<void> fetchHomePage(result) async {
    await _provider.fetchHomePageData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPageViewer()),
    );
  }

  void initWidgetState() {
    _provider = Provider.of<HomePageProvider>(context, listen: false);
    if (mounted) {
      networkNotifier.initNetworkConnectivity().then(fetchHomePage);
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
      body: Center(
        child: SpinKitCircle(
          color: Colors.black,
          size: 50,
        ),
      ),
    );
  }
}
