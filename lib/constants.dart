import 'package:flutter/material.dart';
import 'package:pyd/helpers/cached-tile-provider.dart';
import 'package:pyd/pages/global_theme_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map_tile_caching/storage_caching_tile_provider.dart';

const String kTileLayerUrl =
    //"https://api.maptiler.com/maps/toner/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK";
    "https://api.maptiler.com/maps/pastel/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK";
// "https://api.maptiler.com/maps/nl-cartiqo-light/256/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK",
// "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
const String kDarkTileLayerUrl =
    "https://api.maptiler.com/maps/ch-swisstopo-lbm-dark/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK";
const List<String> kTileLayerUrlSubdomain = ['a', 'b', 'c'];
// StorageCachingTileProvider kCachedTileLayer =
//     StorageCachingTileProvider(cachedValidDuration: Duration(days: 1));
CachedTileProvider kCachedTileLayer = CachedTileProvider();
const double kPostMapCardMinHeight = 216;
const double kPostMapCardMaxHeight = 256;

const double kImageOutHeight = 32;
const double kCardRateBoxHeight = 64.0;
const double kContainerHeight = 240.0;
const double kElevation = 6.0;
const double kCornerRadius = 25;
