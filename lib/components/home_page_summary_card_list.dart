import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pyd/components/summary_card.dart';
import 'package:pyd/constants.dart';
import 'package:pyd/models/summary-card.dart';
import 'package:pyd/providers/home_page_provider.dart';

class HomePageSummaryCardList extends StatefulWidget {
  HomePageSummaryCardList({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageSummaryCardListState createState() =>
      _HomePageSummaryCardListState();
}

class _HomePageSummaryCardListState extends State<HomePageSummaryCardList> {
  late HomePageProvider _provider;
  late List<SummaryCard> _summaryCards;
  @override
  void initState() {
    _provider = context.read<HomePageProvider>();
    _summaryCards = _provider.summaryCards;
    super.initState();
  }

  Widget? _widget;
  @override
  Widget build(BuildContext context) {
    print("build => HomePageSummaryCardList");

    if (_widget == null) {
      _widget = buildAlign();
    }

    return _widget!;
  }

  Widget buildAlign() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(maxHeight: kContainerHeight),
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: 16.0),
        child: OverflowBox(
          // 8 is space between image box and rating box
          maxHeight: kContainerHeight + kImageOutHeight + 8,
          alignment: Alignment.bottomCenter,
          child: Swiper(
            index: _provider.selectedIndex,
            onIndexChanged: (index) {
              _provider.changeSelectedIndex(index);
              _provider.goToLocation(_provider.pins[index]);
            },
            viewportFraction: 0.9,
            autoplay: false,
            itemCount: _summaryCards.length,
            itemBuilder: (_, int index) {
              return SummaryCardBox(summaryCard: _summaryCards[index]);
            },
          ),
        ),
      ),
    );
  }
}
