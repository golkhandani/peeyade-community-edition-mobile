import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map/flutter_map.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:latlong/latlong.dart" as lt;
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:pyd/constants.dart';
import 'package:pyd/helpers/animated-map-move.dart';
import 'package:pyd/notifiers/location-notifier.dart';
import 'package:pyd/providers/home_page_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class BackgroundMap extends StatefulWidget {
  BackgroundMap();

  @override
  State createState() => BackgroundMapState();
}

class BackgroundMapState extends State<BackgroundMap>
    with TickerProviderStateMixin {
  late HomePageProvider _provider =
      Provider.of<HomePageProvider>(context, listen: false);
  late Marker? _userLocationMarker = buildUserLocationMarker();
  late MapController _mapController = MapController();

  /// create user location marker when location is ready
  _userLocationReady() {
    if (locationNotifier.status == LocationStatus.available &&
        _userLocationMarker == null) {
      setState(() {
        _userLocationMarker = buildUserLocationMarker();
      });
    }
  }

  _goToLocation() {
    animatedMapMove(_provider.center, 16.0, _mapController, this);
  }

  @override
  void initState() {
    _provider.addListener(_goToLocation);
    locationNotifier.addListener(_userLocationReady);
    super.initState();
  }

  @override
  void dispose() {
    _provider.removeListener(_goToLocation);
    locationNotifier.removeListener(_userLocationReady);
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    print("build => BackgroundMap");
    return SafeArea(
      child: FlutterMap(
        mapController: _mapController,
        options: buildMapOptions(),
        layers: [
          buildTileLayerOptions(),
          buildMarkerClusterLayerOptions(),
          buildUserMarkerLayerOptions(),
        ],
      ),
    );
  }

  MapOptions buildMapOptions() {
    return MapOptions(
      center: _provider.center,
      zoom: 16.0,
      plugins: [
        MarkerClusterPlugin(),
      ],
    );
  }

  Marker? buildUserLocationMarker() {
    if (locationNotifier.userLatLng != null) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: locationNotifier.userLatLng,
        builder: (ctx) => Icon(
          Icons.pin,
          size: 25,
          color: Colors.lightBlue,
        ),
      );
    }
  }

  MarkerLayerOptions buildUserMarkerLayerOptions() {
    return MarkerLayerOptions(markers: [
      if (_userLocationMarker != null) _userLocationMarker!,
    ]);
  }

  MarkerClusterLayerOptions buildMarkerClusterLayerOptions() {
    return MarkerClusterLayerOptions(
      maxClusterRadius: 60,
      fitBoundsOptions: FitBoundsOptions(
        padding: EdgeInsets.all(50),
      ),
      markers: _provider.summaryCards
          .map((summaryCard) => Marker(
              height: 50,
              width: 50,
              point: lt.LatLng(
                summaryCard.address.location.lat,
                summaryCard.address.location.lng,
              ),
              builder: (ctx) => GestureDetector(
                    onTap: () {
                      print(_provider.summaryCards.indexOf(summaryCard));
                      _provider.changeSelectedIndex(summaryCard);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.location_pin,
                          size: 50,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  )))
          .toList(),
      polygonOptions: PolygonOptions(
        borderColor: Colors.amber,
        color: Colors.black,
      ),
      builder: (context, markers) {
        return FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Text(
            markers.length.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: null,
        );
      },
    );
  }

  TileLayerOptions buildTileLayerOptions() {
    return TileLayerOptions(
      urlTemplate: kTileLayerUrl,
      subdomains: kTileLayerUrlSubdomain,
      tileProvider: kCachedTileLayer,
    );
  }
}
