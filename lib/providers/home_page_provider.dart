import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pyd/notifiers/location-notifier.dart';
import 'package:pyd/models/api.dart';
import 'package:pyd/models/summary-card.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:latlong/latlong.dart" as lt;

class HomePageProvider with ChangeNotifier {
  TextDirection direction = TextDirection.ltr;
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
    summaryCards = await ApiCall.fetch(
      ApiCall.homePage,
      SummaryCard.listFromDynamic,
    );
    notifyListeners();
  }

  lt.LatLng? _center;
  lt.LatLng get center => _center ?? lt.LatLng(35.6892, 51.3890);

  List<lt.LatLng> pins = [
    lt.LatLng(35.6892, 51.3890),
    lt.LatLng(35.6892, 51.390),
    lt.LatLng(35.6992, 51.390),
    lt.LatLng(35.6792, 51.390),
    lt.LatLng(35.6772, 51.390),
  ];
  goToUserLocation() {
    _center = locationNotifier.userLatLng;
    notifyListeners();
  }

  goToLocation(lt.LatLng latLng) {
    _center = latLng;
    notifyListeners();
  }

  int selectedIndex = 0;
  void changeSelectedIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isLiked = true;
  void toggleLike() {
    isLiked = !isLiked;
    notifyListeners();
  }
}

class BackgroundMapProvider extends ChangeNotifier {}
