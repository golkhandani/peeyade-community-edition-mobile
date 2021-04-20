import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart" as lt;
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:pyd/providers/home_page_provider.dart';

class BackgroundMap extends StatefulWidget {
  BackgroundMap();
  static const apiKey =
      "pk.eyJ1IjoiZ29sa2hhbmRhbmkiLCJhIjoiY2toZjBtcmg2MDN2ejJ5cXE5bjVzYW11eiJ9.QTEsmuIQeDTa3phTjiafpQ";

  @override
  State createState() => BackgroundMapState();
}

class BackgroundMapState extends State<BackgroundMap>
    with TickerProviderStateMixin {
  lt.LatLng center = lt.LatLng(35.6892, 51.3890);
  MapController _mapController = MapController();
  @override
  void initState() {
    super.initState();
  }

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
    // _controller.dispose();
  }

  List<lt.LatLng> positions = [
    lt.LatLng(35.6892, 51.3890),
    lt.LatLng(35.6892, 51.390),
  ];

  createMapOption(index) {
    return MapOptions(
      center: positions[index],
      zoom: 18.0,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    final provider = Provider.of<HomePageProvider>(context);
    int index = provider.selectedPostIndex % 2;
    bool myLocation = provider.myLocation;
    print("myLocation $myLocation");
    if (_mapController.ready) {
      print("_mapController ready");
      lt.LatLng center = positions[index];
      if (myLocation) {
        print("MY LOCATION");
        final m = provider.locationResult;
        if (m != null) _animatedMapMove(m, 18.0);
        provider.myLocation = false;
      } else {
        _animatedMapMove(center, 18.0);
      }
    }

    // _mapController.move(positions[index], 18);
    print("buildBackgroundMap $center");
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: createMapOption(index),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                // MarkerLayerOptions(
                //     markers: positions
                //         .map((e) => Marker(
                //               width: 80.0,
                //               height: 80.0,
                //               point: e,
                //               builder: (ctx) => Container(
                //                 decoration: BoxDecoration(
                //                   color: Colors.red,
                //                   borderRadius: BorderRadius.circular(100),
                //                 ),
                //               ),
                //             ))
                //         .toList()),
              ],
            ),
            // ElevatedButton(
            //     child: Container(
            //       width: 200,
            //       height: 200,
            //       color: Colors.red,
            //     ),
            //     onPressed: () {
            //       lt.LatLng center = positions[1];
            //       _mapController.move(center, 18);
            //     })
          ],
        );
      }),
    );
  }
}
