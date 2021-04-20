import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pyd/communication/api.dart';
import 'package:pyd/models/post_model.dart';
import "package:latlong/latlong.dart" as lt;

class HomePageProvider with ChangeNotifier {
  List<dynamic> posts = [];

  lt.LatLng? locationResult;
  bool myLocation = false;
  void goToMyLocation() {
    myLocation = true;
    notifyListeners();
  }

  void setMyLocaion(LocationData ld) {
    locationResult = lt.LatLng(ld.latitude, ld.longitude);
  }

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

  int selectedPageIndex = 0;
  void onItemTapped(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  Future<void> fetchHomePageData() async {
    final response = await Api.fetchHomePageData();
    posts = PostModel.listFromDynamic(response);
    notifyListeners();
  }
}
