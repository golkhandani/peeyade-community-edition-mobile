import 'dart:convert';

class PostModel {
  PostModel({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.slug,
    required this.media,
    required this.rates,
    required this.maxTotalRate,
    required this.currenttotalRate,
  });

  static const int maxStar = 5;
  String id;
  String type;
  Status status;
  String title;
  String subtitle;
  String slug;
  List<Media> media;
  List<Rate> rates;
  int maxTotalRate;
  double currenttotalRate;

  static List<PostModel> listFromDynamic(list) =>
      List<PostModel>.from(list.map((item) => PostModel.fromJson(item)));

  static PostModel itemFromDynamic(item) => PostModel.fromJson(item);

  factory PostModel.fromRawJson(String str) =>
      PostModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostModel.fromJson(Map<String, dynamic> json) {
    int maxTotalRate = 0;
    double currenttotalRate = 0;
    List<Rate> rates = List<Rate>.from(json["rates"].map((x) {
      final rate = Rate.fromJson(x);
      maxTotalRate += rate.base ~/ json["rates"].length;
      currenttotalRate += rate.value / json["rates"].length;
      return rate;
    }));

    currenttotalRate = (currenttotalRate / maxTotalRate) * PostModel.maxStar;

    return PostModel(
      id: json["_id"],
      type: json["type"],
      status: Status.fromJson(json["status"]),
      title: json["title"],
      subtitle: json["subtitle"],
      slug: json["slug"],
      media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      rates: rates,
      maxTotalRate: PostModel.maxStar,
      currenttotalRate: currenttotalRate,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "status": status.toJson(),
        "title": title,
        "subtitle": subtitle,
        "slug": slug,
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      };
}

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

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        type: json["type"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "url": url,
        "width": width,
        "height": height,
      };
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

  String toRawJson() => json.encode(toJson());

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        title: json["title"],
        iconUrl: json["iconURL"],
        colorHex: json["colorHex"],
        base: json["base"],
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "iconURL": iconUrl,
        "colorHex": colorHex,
        "base": base,
        "value": value,
      };
}

class Status {
  Status({
    required this.type,
    required this.date,
  });

  String type;
  DateTime date;

  factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        type: json["type"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "date": date.toIso8601String(),
      };
}
