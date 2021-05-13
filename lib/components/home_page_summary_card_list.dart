import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pyd/components/summary_card.dart';
import 'package:pyd/constants.dart';
import 'package:pyd/models/summary-card.dart';
import 'package:pyd/providers/home_page_provider.dart';
import "package:latlong/latlong.dart" as lt;

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
  late List<SummaryCard> summaryCards;
  @override
  void initState() {
    _provider = context.read<HomePageProvider>();
    summaryCards = _provider.summaryCards;
    super.initState();
  }

  SwiperController _swiperController = SwiperController();
  _goToIndex() {
    _swiperController.move(_provider.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    print("build => HomePageSummaryCardList");
    _provider.addListener(_goToIndex);
    return buildAlign();
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
            controller: _swiperController,
            index: _provider.selectedIndex,
            onIndexChanged: (index) {
              var summaryCard = summaryCards[index];
              _provider.changeSelectedIndex(summaryCard);
              _provider.goToLocation(lt.LatLng(
                summaryCard.address.location.lat,
                summaryCard.address.location.lng,
              ));
            },
            viewportFraction: 0.9,
            autoplay: false,
            loop: false,
            itemCount: summaryCards.length,
            itemBuilder: (_, int index) {
              return SummaryCardBox(summaryCard: summaryCards[index]);
            },
          ),
        ),
      ),
    );
  }
}
