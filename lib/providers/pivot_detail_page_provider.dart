import 'package:flutter/material.dart';
import 'package:pyd/models/api.dart';
import 'package:pyd/models/summary-card.dart';

class PivotDetailPageProvider with ChangeNotifier {
  SummaryCard? selectedSummaryCard;

  setSelectedSummaryCard(SummaryCard summaryCard) {
    selectedSummaryCard = summaryCard;
    notifyListeners();
  }
}
