import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import "package:latlong/latlong.dart" as lt;

enum LocationStatus {
  notAvailable,
  available,
  notAllowed,
  pending,
}

class LocationNotifier extends ChangeNotifier {
  Location _location = Location();
  LocationData? _locationData;

  lt.LatLng? _userLatLng;
  lt.LatLng? get userLatLng => _userLatLng;

  LocationStatus _status = LocationStatus.notAvailable;
  LocationStatus get status => _status;

  Future<void> setMyLocation() async {
    _status = LocationStatus.pending;
    try {
      _locationData = await locationNotifier._location.getLocation();
      if (_locationData != null) {
        _status = LocationStatus.available;
        _userLatLng = lt.LatLng(
          locationNotifier._locationData!.latitude,
          locationNotifier._locationData!.longitude,
        );
        notifyListeners();
      }
    } catch (e) {
      _status = LocationStatus.notAllowed;
      throw (e);
    }
  }
}

final locationNotifier = LocationNotifier();
