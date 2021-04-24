import 'dart:convert';

class Media {
  Media({
    required this.type,
    required this.url,
    required this.width,
    required this.height,
  });

  String type;
  String url;
  int width;
  int height;

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));
  factory Media.fromJson(Map<String, dynamic> json) => Media(
        type: json["type"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );
}

class Rate {
  Rate({
    required this.title,
    required this.iconUrl,
    required this.colorHex,
    required this.base,
    required this.value,
  });

  String title;
  String iconUrl;
  String colorHex;
  int base;
  double value;

  factory Rate.fromRawJson(String str) => Rate.fromJson(json.decode(str));
  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        title: json["title"],
        iconUrl: json["iconURL"],
        colorHex: json["colorHex"],
        base: json["base"],
        value: json["value"].toDouble(),
      );
}

class SummaryCard {
  SummaryCard({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.slug,
    required this.media,
    required this.rates,
    required this.maxTotalRate,
    required this.currenttotalRate,
  });

  String id;
  String type;
  String title;
  String subtitle;
  String slug;
  List<Media> media;
  List<Rate> rates;
  int maxTotalRate;
  double currenttotalRate;

  static const int maxStar = 5;

  static List<SummaryCard> listFromDynamic(list) =>
      List<SummaryCard>.from(list.map((item) => SummaryCard.fromJson(item)));
  static SummaryCard itemFromDynamic(item) => SummaryCard.fromJson(item);

  factory SummaryCard.fromRawJson(String str) =>
      SummaryCard.fromJson(json.decode(str));

  factory SummaryCard.fromJson(Map<String, dynamic> json) {
    int maxTotalRate = 0;
    double currentTotalRate = 0;
    List<Rate> rates = List<Rate>.from(json["rates"].map((x) {
      final rate = Rate.fromJson(x);
      maxTotalRate += rate.base ~/ json["rates"].length;
      currentTotalRate += rate.value / json["rates"].length;
      return rate;
    }));

    currentTotalRate = (currentTotalRate / maxTotalRate) * SummaryCard.maxStar;

    return SummaryCard(
      id: json["_id"],
      type: json["type"],
      title: json["title"],
      subtitle: json["subtitle"],
      slug: json["slug"],
      media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      rates: rates,
      maxTotalRate: SummaryCard.maxStar,
      currenttotalRate: currentTotalRate,
    );
  }
}
