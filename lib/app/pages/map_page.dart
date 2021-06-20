import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:pyd/constants.dart';
import 'package:pyd/helpers/animated-map-move.dart';
import 'package:pyd/pages/fake_data.dart';
import 'package:pyd/pages/global_theme_provider.dart';
import "package:latlong/latlong.dart" as lt;
import 'package:pyd/pages/page_viewer.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapContainer _mapContainer;
  final MapContainerProvider _mapContainerProvider = MapContainerProvider();

  @override
  void initState() {
    _mapContainerProvider.setPins(cards.map((e) => e.geoLocation).toList());
    _mapContainerProvider.setCenter(cards[0].geoLocation);
    _mapContainer = MapContainer(provider: _mapContainerProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: theme.boxColor,
          padding: EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 80),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kCornerRadius),
            child: Container(
              color: Colors.red,
              child: Stack(
                children: [
                  _mapContainer,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MapClickablePin extends StatelessWidget {
  const MapClickablePin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      child: CustomPaint(
        painter: CurvePainter(),
        child: Center(
          child: Text(
            "Click Me!",
            style: textStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: theme.accentTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = theme.accentColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    double radius = 20;
    double curve = 35;
    double nip = 5;
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);

    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);

    path.lineTo(size.width - curve, size.height);

    path.quadraticBezierTo((size.width / 2) + 5, (size.height + 0),
        (size.width / 2), size.height + nip);

    //path.lineTo((size.width / 2), size.height + radius);
    //path.lineTo((size.width / 2) + radius, size.height);
    path.quadraticBezierTo(
        (size.width / 2) - 5, (size.height + 0), curve, size.height);
    path.lineTo(radius, size.height);
    // path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MapContainerProvider extends ChangeNotifier {
  lt.LatLng? center;
  lt.LatLng _user = lt.LatLng(35.7892, 51.3890);
  List<lt.LatLng>? pins;

  setPins(List<lt.LatLng> pins) {
    print("setPins");
    this.pins = pins;
    notifyListeners();
  }

  setCenter(lt.LatLng center) {
    print("setCenter");
    this.center = center;
    notifyListeners();
  }

  setUser(lt.LatLng user) {
    print("setUser");
    this._user = user;
    notifyListeners();
  }

  setUserToCenter() {
    print("setUserToCenter");
    this.center = this._user;
    notifyListeners();
  }

  getUser() {
    print("getUser");
    return this._user;
  }
}

class MapContainer extends StatefulWidget {
  MapContainer({
    required this.provider,
  });
  final MapContainerProvider provider;
  @override
  State createState() => MapContainerState();
}

class MapContainerState extends State<MapContainer>
    with TickerProviderStateMixin {
  late MapController _mapController = MapController();

  lt.LatLng center = lt.LatLng(35.7892, 51.3890);
  _goToLocation() {
    if (_provider.center != null) {
      print("Change in center");
      print(_provider.center);
      animatedMapMove(_provider.center!, 16.0, _mapController, this);
    } else {
      print("No Change in center");
    }
  }

  late MapContainerProvider _provider = widget.provider;
  @override
  void initState() {
    print("Init map state");
    print(widget.provider.center);
    // _goToLocation();
    if (_provider.center != null) {
      center = _provider.center!;
    }
    _provider.addListener(_goToLocation);
    // _provider.addListener(_createLocations);

    super.initState();
  }

  @override
  void dispose() {
    // _provider.removeListener(_goToLocation);
    // locationNotifier.removeListener(_userLocationReady);
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    print("build => BackgroundMap");
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: center,
        zoom: 16.0,
        plugins: [
          MarkerClusterPlugin(),
        ],
      ),
      layers: [
        buildTileLayerOptions(),
        buildMarkerClusterLayerOptions(),
        buildUserMarkerLayerOptions(),
      ],
    );
  }

  TileLayerOptions buildTileLayerOptions() {
    return TileLayerOptions(
      backgroundColor: theme.backgroundColor,
      urlTemplate: theme.mapTileLayer,
      subdomains: kTileLayerUrlSubdomain,
      tileProvider: kCachedTileLayer,
    );
  }

  MarkerLayerOptions buildUserMarkerLayerOptions() {
    return MarkerLayerOptions(markers: [
      Marker(
        width: 80.0,
        height: 80.0,
        point: _provider.getUser(),
        builder: (ctx) => Icon(
          FlutterIcons.map_marker_circle_mco,
          size: 50,
          color: theme.mapUserPin,
        ),
      ),
    ]);
  }

  MarkerClusterLayerOptions buildMarkerClusterLayerOptions() {
    return MarkerClusterLayerOptions(
      maxClusterRadius: 60,
      fitBoundsOptions: FitBoundsOptions(
        padding: EdgeInsets.all(50),
      ),
      markers: (_provider.pins ?? [])
          .map(
            (pin) => Marker(
              height: 48,
              width: 96,
              point: pin,
              builder: (ctx) => GestureDetector(
                onTap: () {
                  print("Change item in map");
                  // _provider.changeSelectedIndex(summaryCard);
                },
                child: MapClickablePin(),
              ),
            ),
          )
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
}
