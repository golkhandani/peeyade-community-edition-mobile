import 'package:flutter/material.dart';
import 'package:pyd/models/api.dart';
import 'package:pyd/models/summary-card.dart';

class MainPageViewerProvider with ChangeNotifier {
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

  int selectedPageIndex = 0;
  void onItemTapped(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  // Future<void> fetchMainPageViewerData() async {
  //   final response = await Api.fetch();
  //   posts = SummaryCard.listFromDynamic(response);
  //   notifyListeners();
  // }
}
