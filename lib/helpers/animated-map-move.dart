import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map/flutter_map.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:latlong/latlong.dart" as lt;

animatedMapMove(
  lt.LatLng destLocation,
  double destZoom,
  MapController mapController,
  TickerProvider vsync,
) {
  // Create some tweens. These serve to split up the transition from one location to another.
  // In our case, we want to split the transition be<tween> our current map center and the destination.
  final _latTween = Tween<double>(
      begin: mapController.center.latitude, end: destLocation.latitude);
  final _lngTween = Tween<double>(
      begin: mapController.center.longitude, end: destLocation.longitude);
  final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

  // Create a animation controller that has a duration and a TickerProvider.
  AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 700), vsync: vsync);

  // The animation determines what path the animation will take. You can try different Curves values, although I found
  // fastOutSlowIn to be my favorite.
  Animation<double> animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  _controller.addListener(() {
    mapController.move(
        lt.LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
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
