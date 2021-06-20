import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map/flutter_map.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pyd/components/progressive_image_loader.dart';
import 'package:pyd/helpers/animated-map-move.dart';
import 'package:pyd/pages/easter_egg_page.dart';
import 'package:pyd/pages/elements/page_header.dart';
import 'package:pyd/pages/fake_data.dart';
import 'package:pyd/pages/global_theme_provider.dart';
import 'package:pyd/pages/page_viewer.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:latlong/latlong.dart" as lt;
// ignore: import_of_legacy_library_into_null_safe
import 'package:pyd/constants.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final PageController _scrollController = PageController(viewportFraction: 1);

  late double height = 10.0;
  late double width = 10.0;

  late int selectedCardIndex = 0;
  late MapContainer _mapContainer;
  late List<String> selectedCategories = [defaultFilter];
  final _mapContainerProvider = MapContainerProvider();
  @override
  void initState() {
    _mapContainerProvider.setPins(cards.map((e) => e.geoLocation).toList());
    _mapContainerProvider.setCenter(cards[0].geoLocation);
    _mapContainer = MapContainer(provider: _mapContainerProvider);
    super.initState();
  }

  addCategory(String category) {
    if (category.toLowerCase().startsWith("all")) {
      selectedCategories = [defaultFilter];
    } else if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.remove(defaultFilter);
      selectedCategories.add(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.backgroundColor,
      padding: EdgeInsets.only(bottom: 64, top: 0, left: 0, right: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ExplorePageHeader(),
          ),
          Container /* Categories */ (
            // padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: 48 + 16,
            child: Builder(builder: (context) {
              var categories = mockCategories;
              var onCategoryTap = (category) {
                setState(() {
                  print(category);
                  addCategory(category);
                });
              };
              return CategoryFilterListView(
                categories: categories,
                selectedCategories: selectedCategories,
                onCategoryTap: onCategoryTap,
              );
            }),
          ),
          Expanded /* Map */ (
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Builder(builder: (context) {
                var onShowMeTap = () {
                  print("Show me!");
                  setState(() {
                    _mapContainerProvider.setUserToCenter();
                  });
                };
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      _mapContainer,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 100,
                          height: 40,
                          margin: EdgeInsets.all(8.0),
                          child: ClickableBox(
                            onPressed: () {
                              print("object");
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Show Map",
                                    style: textStyle.copyWith(
                                      fontSize: 12,
                                      color: theme.boxTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 100,
                          height: 40,
                          margin: EdgeInsets.all(8.0),
                          child: ClickableBox(
                            onPressed: onShowMeTap,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Show Me!",
                                    style: textStyle.copyWith(
                                      fontSize: 12,
                                      color: theme.boxTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Column(
            children: [
              Container /* Cards Dot */ (
                width: MediaQuery.of(context).size.width,
                height: 24,
                // color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.filled(cards.length, 1)
                      .asMap()
                      .map(
                        (i, e) => MapEntry(
                          i,
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: selectedCardIndex == i
                                  ? theme.accentColor
                                  : theme.boxColor,
                            ),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
              Container /* Cards  */ (
                width: MediaQuery.of(context).size.width,
                height: 196,
                constraints: BoxConstraints(minHeight: 120, maxHeight: 200),
                child: PageView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: cards.length,
                  onPageChanged: (index) {
                    var card = cards[index];
                    setState(() {
                      selectedCardIndex = index;
                      _mapContainerProvider.setCenter(card.geoLocation);
                    });
                  },
                  itemBuilder: (_, index) {
                    var card = cards[index];
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 180,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: ClickableBox(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage()),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: theme.boxColor,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Hero(
                                        tag: "MainHero",
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: ProgressiveImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            placeholder:
                                                'assets/placeholder.jpeg',
                                            thumbnail:
                                                "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                                            image:
                                                "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                32,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RatingBarIndicator(
                                            rating: card.score,
                                            unratedColor: Colors.amber[400],
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              index > card.score
                                                  ? FlutterIcons
                                                      .star_outline_mco
                                                  : index == card.score.floor()
                                                      ? FlutterIcons
                                                          .star_half_mco
                                                      : FlutterIcons.star_mco,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            card.title,
                                            style: textStyle.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: theme.boxTextColor),
                                          ),
                                          SizedBox(height: 4),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                card.subtitle,
                                                style: textStyle.copyWith(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: theme.boxTextColor),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryFilterListView extends StatelessWidget {
  const CategoryFilterListView({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategoryTap,
  }) : super(key: key);

  final List<String> categories;
  final List<String> selectedCategories;
  final void Function(String category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (_, i) => SizedBox(width: 8),
      itemBuilder: (_, i) {
        var category = categories[i];
        var selected = selectedCategories.contains(category);
        var onTap = () => onCategoryTap(category);
        return Padding(
          padding: EdgeInsets.only(
            left: i == 0 ? 16 : 0,
            right: i == categories.length - 1 ? 16 : 0,
          ),
          child: CategoryFilterBox(
            onTap: onTap,
            selected: selected,
            category: category,
          ),
        );
      },
    );
  }
}

class CategoryFilterBox extends StatelessWidget {
  const CategoryFilterBox({
    Key? key,
    required this.onTap,
    required this.selected,
    required this.category,
  }) : super(key: key);

  final void Function() onTap;
  final bool selected;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 48,
        child: ClickableBox(
          backgroundColor: selected ? theme.accentColor : theme.boxColor,
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                category,
                style: textStyle.copyWith(
                  fontSize: 12,
                  color: selected ? theme.accentTextColor : theme.boxTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    //   return GestureDetector(
    //     onTap: onTap,
    //     child: Container(
    //       margin: EdgeInsets.only(right: 8),
    //       padding: EdgeInsets.all(8.0),
    //       decoration: BoxDecoration(
    //         color: selected ? theme.accentColor : theme.boxColor,
    //         borderRadius: BorderRadius.circular(15),
    //       ),
    //       child: Center(
    //         child: Text(
    //           category,
    //           style: textStyle.copyWith(
    //             fontSize: 14,
    //             letterSpacing: 1.5,
    //             color: selected ? theme.accentTextColor : theme.boxTextColor,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }
}

class ExplorePageHeader extends StatelessWidget {
  const ExplorePageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      // back: true,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      },
      header: ExplorePageSearchBox(),
    );
  }
}

class ExplorePageSearchBox extends StatelessWidget {
  const ExplorePageSearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FlutterIcons.search_mdi,
          color: theme.boxTextColor,
        ),
        SizedBox(width: 8),
        Text(
          "Advance Search",
          style: textStyle.copyWith(
            fontSize: 18,
            color: theme.boxTextColor,
          ),
        )
      ],
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<String> selectedCategories = [defaultFilter];

  addCategory(String category) {
    if (category.toLowerCase().startsWith("all")) {
      selectedCategories = [defaultFilter];
    } else if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.remove(defaultFilter);
      selectedCategories.add(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: theme.backgroundColor,
          padding: EdgeInsets.only(
            bottom: 80,
            top: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          color: theme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: theme.boxColor),
                        ),
                        child: Center(
                            child: Icon(
                          FlutterIcons.arrow_back_mdi,
                          color: theme.boxTextColor,
                        )),
                      ),
                    ),
                    Expanded /* Search */ (
                      child: Hero(
                        tag: "SearchHero",
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Material(
                            color: theme.boxColor,
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FlutterIcons.search_mdi,
                                  color: theme.boxTextColor,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Advance Search",
                                  style: textStyle.copyWith(
                                    fontSize: 18,
                                    color: theme.boxTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container /* Categories */ (
                height: 48,
                margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                // color: Colors.red,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mockCategories.length,
                  itemBuilder: (_, index) {
                    var category = mockCategories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          print(category);
                          addCategory(category);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: selectedCategories.contains(category)
                              ? theme.accentColor
                              : theme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: textStyle.copyWith(
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: selectedCategories.contains(category)
                                  ? theme.accentTextColor
                                  : theme.boxTextColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      backgroundColor: theme.boxColor,
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
          .map((pin) => Marker(
              height: 50,
              width: 50,
              point: pin,
              builder: (ctx) => GestureDetector(
                    onTap: () {
                      print("Change item in map");
                      // _provider.changeSelectedIndex(summaryCard);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Icon(
                          FlutterIcons.map_marker_mco,
                          size: 50,
                          color: Colors.red,
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
}
