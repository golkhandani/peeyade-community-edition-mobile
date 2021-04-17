import 'package:flutter/material.dart';
import 'package:pyd/communication/api.dart';
import 'package:pyd/models/post_model.dart';

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
    final response = await Api.fetchHomePageData();
    posts = PostModel.listFromDynamic(response);
    notifyListeners();
  }
}
