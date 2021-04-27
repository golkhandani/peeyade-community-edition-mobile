import 'package:pyd/helpers/cached-tile-provider.dart';

const String kTileLayerUrl =
    "https://api.maptiler.com/maps/pastel/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK";
// "https://api.maptiler.com/maps/nl-cartiqo-light/256/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK",
// "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
const List<String> kTileLayerUrlSubdomain = ['a', 'b', 'c'];
const CachedTileProvider kCachedTileLayer = const CachedTileProvider();
const double kPostMapCardMinHeight = 216;
const double kPostMapCardMaxHeight = 256;

const double kImageOutHeight = 32;
const double kCardRateBoxHeight = 64.0;
const double kContainerHeight = 240.0;
