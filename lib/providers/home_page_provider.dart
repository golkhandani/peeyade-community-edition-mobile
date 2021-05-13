import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pyd/notifiers/location-notifier.dart';
import 'package:pyd/models/api.dart';
import 'package:pyd/models/summary-card.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:latlong/latlong.dart" as lt;

class HomePageProvider with ChangeNotifier {
  TextDirection direction = TextDirection.rtl;
  changeDirection() {
    if (direction == TextDirection.ltr) {
      direction = TextDirection.rtl;
    } else {
      direction = TextDirection.ltr;
    }
    print(direction);
    notifyListeners();
  }

  List<SummaryCard> summaryCards = [];
  Future<void> fetchHomePageData() async {
    summaryCards = await Api.fetch(
      Api.homePage,
      SummaryCard.listFromDynamic,
    );

    notifyListeners();
  }

  lt.LatLng? _center;
  lt.LatLng get center =>
      _center ??
      lt.LatLng(
        summaryCards[0].address.location.lat,
        summaryCards[0].address.location.lng,
      );

  goToUserLocation() {
    _center = locationNotifier.userLatLng;
    notifyListeners();
  }

  goToLocation(lt.LatLng latLng) {
    _center = latLng;
    notifyListeners();
  }

  int selectedIndex = 0;
  void changeSelectedIndex(SummaryCard summaryCard) {
    selectedIndex = summaryCards.indexOf(summaryCard);
    print("selectedIndex $selectedIndex");
    _center = lt.LatLng(
      summaryCard.address.location.lat,
      summaryCard.address.location.lng,
    );
    notifyListeners();
  }

  bool isLiked = true;
  void toggleLike() {
    isLiked = !isLiked;
    notifyListeners();
  }
}

class BackgroundMapProvider extends ChangeNotifier {}
