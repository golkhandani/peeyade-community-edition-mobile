import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pyd/helpers/from-hex-color.dart';
import 'package:pyd/pages/fake_data.dart';
import 'package:pyd/pages/global_theme_provider.dart';
import 'easter_egg_page.dart';
import 'explore_page.dart';

final Container search = Container(
  margin: EdgeInsets.only(top: 16),
  height: 48,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Container(
      color: white80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FlutterIcons.search1_ant,
            size: 25,
          ),
          SizedBox(width: 8),
          Text(
            "search",
            style: textStyle.copyWith(fontSize: 20),
          ),
        ],
      ),
    ),
  ),
);

final Color white80 = Colors.white.withOpacity(0.8);
final TextStyle textStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w400,
  letterSpacing: 1,
);

class PageViewer extends StatefulWidget {
  @override
  _PageViewerState createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {
  final int _selectedPageIndex = 1;
  late ApplicationPage _selectedPage;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _selectedPageIndex,
      keepPage: true,
    );
    _selectedPage = pages[_selectedPageIndex];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              allowImplicitScrolling: false,
              pageSnapping: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: pages.length,
              itemBuilder: (_, index) {
                return pages[index].widget;
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // color: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                constraints: BoxConstraints(
                    maxHeight: 72, minHeight: 72, maxWidth: 500, minWidth: 300),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: theme.boxColor,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: pages
                            .map(
                              (page) => IconButton(
                                onPressed: () => changePage(page),
                                iconSize: 40,
                                icon: Icon(
                                  page.iconData,
                                  color: page == _selectedPage
                                      ? page.color
                                      : theme.boxTextColor,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void changePage(ApplicationPage page) {
    setState(() {
      _selectedPage = page;
      _pageController.jumpToPage(
        pages.indexOf(_selectedPage),
      );
    });
  }
}
