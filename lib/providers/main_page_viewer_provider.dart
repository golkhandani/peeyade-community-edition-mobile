import 'package:flutter/material.dart';
import 'package:pyd/notifiers/api.dart';
import 'package:pyd/models/post_model.dart';

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

  Future<void> fetchMainPageViewerData() async {
    final response = await Api.fetchHomePageData();
    posts = PostModel.listFromDynamic(response);
    notifyListeners();
  }
}
