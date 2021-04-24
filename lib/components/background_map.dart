import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart" as lt;
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:pyd/communication/location-notifier.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class BackgroundMap extends StatefulWidget {
  BackgroundMap();

  @override
  State createState() => BackgroundMapState();
}

class BackgroundMapState extends State<BackgroundMap>
    with TickerProviderStateMixin {
  MapController _mapController = MapController();

  void _animatedMapMove(lt.LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    AnimationController _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);

    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    _controller.addListener(() {
      _mapController.move(
          lt.LatLng(
              _latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        _controller.dispose();
      }
    });

    _controller.forward();
  }

  Marker? _buildUserLocationMarker() {
    if (locationNotifier.userLatLng != null)
      return Marker(
          width: 80.0,
          height: 80.0,
          point: locationNotifier.userLatLng,
          builder: (ctx) => Icon(
                Icons.crib,
                size: 25,
                color: Colors.lightBlue,
              ));
  }

  late Marker? _userLocationMarker = _buildUserLocationMarker();
  _userLocationReady() {
    print(locationNotifier.userLatLng);
    if (locationNotifier.status == LocationStatus.available &&
        _userLocationMarker == null) {
      setState(() {
        _userLocationMarker = _buildUserLocationMarker();
      });
    }
  }

  _goToLocation() {
    _animatedMapMove(_provider.center, 16.0);
  }

  _createMapOption() {
    return MapOptions(
      center: _provider.center,
      zoom: 16.0,
      plugins: [
        MarkerClusterPlugin(),
      ],
    );
  }

  late BackgroundMapProvider _provider;
  @override
  void initState() {
    _provider = Provider.of<BackgroundMapProvider>(context, listen: false);
    _provider.addListener(_goToLocation);
    locationNotifier.addListener(_userLocationReady);
    print(locationNotifier.userLatLng);
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
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: _createMapOption(),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.maptiler.com/maps/pastel/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK",
                  // "https://api.maptiler.com/maps/nl-cartiqo-light/256/{z}/{x}/{y}.png?key=J4ktALZX8GCz9Hw7i0tK",
                  // "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  tileProvider: const CachedTileProvider(),
                ),
                MarkerClusterLayerOptions(
                  maxClusterRadius: 30,
                  fitBoundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: _provider.pins
                      .map((e) => Marker(
                          point: e,
                          // anchorPos: ,
                          builder: (ctx) => Icon(
                                Icons.location_pin,
                                size: 50,
                                color: Colors.redAccent,
                              )))
                      .toList(),
                  polygonOptions: PolygonOptions(
                    borderColor: Colors.amber,
                    color: Colors.black,
                  ),
                  builder: (context, markers) {
                    return Icon(
                      Icons.group_work,
                      size: 60,
                      color: Colors.amberAccent,
                    );
                  },
                ),
                MarkerLayerOptions(markers: [
                  if (_userLocationMarker != null) _userLocationMarker!,
                ]),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    final url = getTileUrl(coords, options);
    print("___MAP => url: $url");
    return NetworkImage(url);
  }
}
