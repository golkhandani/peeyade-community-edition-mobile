import 'package:flutter/material.dart';
import 'package:pyd/models/api.dart';
import 'package:pyd/models/summary-card.dart';

class PivotDetailPageProvider with ChangeNotifier {
  SummaryCard? selectedSummaryCard;
  SummaryCard? pivot;
  setSelectedSummaryCard(SummaryCard summaryCard) {
    selectedSummaryCard = summaryCard;
    notifyListeners();
  }

  Future<void> fetchDetailPageData() async {
    var pivots = await Api.fetch(
      Api.homePage,
      SummaryCard.listFromDynamic,
    );
    pivot = pivots[0];
    notifyListeners();
  }
}
