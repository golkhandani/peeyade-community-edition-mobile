import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pyd/communication/api.dart';
import 'package:pyd/communication/location-notifier.dart';
import 'package:pyd/models/api.dart';
import 'package:pyd/models/card.dart';
import 'package:pyd/models/post_model.dart';
import "package:latlong/latlong.dart" as lt;

class HomePageProvider with ChangeNotifier {
  List<dynamic> posts = [];

  int selectedPostIndex = 0;

  void changeSelectedPostIndex(index) {
    selectedPostIndex = index;
    notifyListeners();
  }

  bool isLiked = true;

  void toggleLike() {
    isLiked = !isLiked;
    notifyListeners();
  }

  Future<void> fetchHomePageData() async {
    posts = await ApiCall.fetch(
      ApiCall.homePage,
      // SummaryCard.listFromDynamic,
      PostModel.listFromDynamic,
    );
    // print(data[0].slug);
    // final response = await Api.fetchHomePageData();
    // posts = await compute(PostModel.listFromDynamic, response);
    notifyListeners();
  }
}

class BackgroundMapProvider extends ChangeNotifier {
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
}
