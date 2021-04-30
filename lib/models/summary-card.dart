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

class Status {
  Status({
    required this.type,
    required this.date,
  });

  String type;
  String date;

  factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      type: json["type"],
      date: json["date"],
    );
  }
}

enum ContactType {
  phone,
  web,
  instagram,
  email,
}

class Contact {
  Contact({
    required this.type,
    required this.iconURL,
    required this.url,
    required this.verified,
  });

  static ContactType stringToContactType(String str) {
    return ContactType.values.firstWhere(
      (e) => e.toString().split('.')[1] == str,
    );
  }

  ContactType type;
  String iconURL;
  String url;
  bool verified;

  factory Contact.fromRawJson(String str) => Contact.fromJson(json.decode(str));
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      type: Contact.stringToContactType(json["type"]),
      iconURL: json["iconURL"],
      url: json["url"],
      verified: json["verified"],
    );
  }
}

class ContentWriter {
  ContentWriter({
    required this.id,
    required this.name,
    required this.avatar,
  });

  String id;
  String name;
  Media avatar;

  factory ContentWriter.fromRawJson(String str) =>
      ContentWriter.fromJson(json.decode(str));
  factory ContentWriter.fromJson(Map<String, dynamic> json) {
    return ContentWriter(
      id: json["_id"],
      name: json["name"],
      avatar: Media.fromJson(json["avatar"]),
    );
  }
}

class GeoLocation {
  GeoLocation({
    this.type = "Point",
    required this.coordinates,
    required this.lat,
    required this.lng,
  });

  String type;
  List<double> coordinates;
  double lat;
  double lng;

  factory GeoLocation.fromRawJson(String str) =>
      GeoLocation.fromJson(json.decode(str));
  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      type: json["type"],
      coordinates: List<double>.from(
        json["coordinates"].map(
          (x) => x.toDouble(),
        ),
      ),
      lat: json["coordinates"][1],
      lng: json["coordinates"][0],
    );
  }
}

class Address {
  Address({
    required this.country,
    required this.city,
    required this.state,
    required this.street,
    required this.location,
    required this.neighborhood,
  });

  String country;
  String city;
  String state;
  String street;
  GeoLocation location;
  String neighborhood;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: json["country"],
      city: json["city"],
      state: json["state"],
      street: json["street"],
      location: GeoLocation.fromJson(json["location"]),
      neighborhood: json["neighborhood"],
    );
  }
}

class SummaryCard {
  SummaryCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.status,
    required this.contacts,
    required this.rates,
    required this.type,
    required this.contentWriter,
    required this.address,
    required this.slug,
    required this.media,
    required this.maxTotalRate,
    required this.currentTotalRate,
  });

  String id;
  String title;
  String subtitle;
  String description;
  Status status;
  List<Contact> contacts;
  List<Rate> rates;
  String type;
  ContentWriter contentWriter;
  Address address;
  List<Media> media;
  String slug;

  int maxTotalRate;
  double currentTotalRate;

  static const int maxStar = 5;

  static List<SummaryCard> listFromDynamic(list) =>
      List<SummaryCard>.from(list.map((item) => SummaryCard.fromJson(item)));
  static SummaryCard itemFromDynamic(item) => SummaryCard.fromJson(item);

  factory SummaryCard.fromRawJson(String str) =>
      SummaryCard.fromJson(json.decode(str));
  factory SummaryCard.fromJson(Map<String, dynamic> json) {
    // RATE
    int maxTotalRate = 0;
    double currentTotalRate = 0;
    var rates = List<Rate>.from(json["rates"].map((x) {
      final rate = Rate.fromJson(x);
      maxTotalRate += rate.base ~/ json["rates"].length;
      currentTotalRate += rate.value / json["rates"].length;
      return rate;
    }));
    currentTotalRate = (currentTotalRate / maxTotalRate) * SummaryCard.maxStar;
    // END RATE;

    // CONTACTS
    var contacts =
        List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x)));

    var media = List<Media>.from(json["media"].map((x) => Media.fromJson(x)));
    return SummaryCard(
      id: json["_id"],
      title: json["title"],
      subtitle: json["subtitle"],
      description: json["description"],
      status: Status.fromJson(json["status"]),
      contacts: contacts,
      rates: rates,
      type: json["type"],
      contentWriter: ContentWriter.fromJson(json["contentWriter"]),
      address: Address.fromJson(json["address"]),
      slug: json["slug"],
      media: media,
      maxTotalRate: SummaryCard.maxStar,
      currentTotalRate: currentTotalRate,
    );
  }
}
