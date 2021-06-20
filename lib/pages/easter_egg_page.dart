import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pyd/components/progressive_image_loader.dart';
import 'package:pyd/helpers/from-hex-color.dart';
import 'package:pyd/pages/elements/page_header.dart';
import 'package:pyd/pages/explore_page.dart';
import 'package:pyd/pages/global_theme_provider.dart';
import 'package:pyd/pages/page_viewer.dart';

class EasterEggPage extends StatefulWidget {
  @override
  _EasterEggPageState createState() => _EasterEggPageState();
}

class _EasterEggPageState extends State<EasterEggPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.backgroundColor,
      padding: EdgeInsets.only(bottom: 80, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PageHeader(
            header: PageHeaderTitle(
              title: "Easter egg of the day!",
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
              child: Hero(
                tag: "MainHero",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: ProgressiveImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/placeholder.jpeg',
                    thumbnail:
                        "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                    image:
                        "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height - 32,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: theme.boxColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '"Cafe Godo" will care you after a hard day! Marshmallow toffee sesame snaps liquorice fruitcake. Carrot cake chupa chups dragée. Jelly-o tart liquorice marshmallow fruitcake bear claw bonbon lollipop cake.',
                style: textStyle.copyWith(fontSize: 16, color: theme.textColor),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("Navigate to DetailPage");
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true, builder: (context) => DetailPage()),
              );
            },
            child: Container(
              height: 48,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.boxColor,
                ),
                child: FittedBox(
                  fit: BoxFit.none,
                  child: Center(
                    child: Text(
                      "See details of Godo cafe!",
                      style: textStyle.copyWith(
                        fontSize: 14,
                        color: theme.boxTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 48,
            margin: EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      print("Navigate to EasterEggHistoryPage");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EasterEggHistoryPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 48,
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: theme.boxColor,
                      ),
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: Center(
                          child: Text(
                            "See easter eggs history!",
                            style: textStyle.copyWith(
                              fontSize: 14,
                              color: theme.boxTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: theme.boxColor,
                    ),
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Center(
                        child: Text(
                          "See next!",
                          style: textStyle.copyWith(
                            fontSize: 14,
                            color: theme.boxTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int selectedIndex = 0;
  late MapContainer _mapContainer;

  @override
  void initState() {
    var _mapContainerProvider = MapContainerProvider();
    _mapContainer = MapContainer(provider: _mapContainerProvider);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: theme.backgroundColor,
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Column(
            children: [
              Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: PageHeader(
                  back: true,
                  header: PageHeaderTitle(
                    title: "Cafe France",
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  child: ListView(
                    children: [
                      Container(
                        height: 300,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          onPageChanged: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          itemBuilder: (_, index) {
                            return Container(
                              margin: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Hero(
                                tag: "MainHero",
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: ProgressiveImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/placeholder.jpeg',
                                    thumbnail:
                                        "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                                    image:
                                        "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    height:
                                        MediaQuery.of(context).size.height - 32,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 32,
                        // color: Colors.pink,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.filled(4, 1)
                              .asMap()
                              .map(
                                (i, e) => MapEntry(
                                  i,
                                  Container(
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: selectedIndex == i
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
                      Container(
                        height: 200,
                        margin: EdgeInsets.only(left: 16, right: 16),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: theme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Wafer candy brownie gummi bears halvah jelly candy dessert.",
                              style: textStyle.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: theme.boxTextColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Candy chupa chups danish. Candy biscuit bear claw liquorice jelly-o brownie.",
                              style: textStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.boxTextColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Working hours: 1 to 4 A.M.",
                              style: textStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: theme.boxTextColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Last update: Saturday, March 18, 2021",
                              style: textStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: theme.boxTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: theme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '''
Jujubes candy dessert marshmallow ice cream jelly beans. Sweet cotton candy gummies. Lollipop lemon drops chocolate cake sweet roll jujubes cotton candy lemon drops tart fruitcake.
Gummi bears fruitcake toffee lollipop. Toffee chocolate jujubes jelly cake chocolate sweet roll. Donut cotton candy sesame snaps cake cupcake cake jujubes.

Caramels chupa chups marzipan. Oat cake marzipan cotton candy toffee. Danish macaroon cake bear claw macaroon. Dessert candy candy canes tootsie roll caramels sweet cake croissant.

Wafer candy brownie gummi bears halvah jelly candy dessert. Candy chupa chups danish. Candy biscuit bear claw liquorice jelly-o brownie.

Jelly oat cake cake candy canes sweet roll powder tootsie roll. Marzipan topping cake apple pie pudding. Cupcake biscuit muffin bear claw ice cream.
                        ''',
                          style: textStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.boxTextColor,
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(children: [
                            _mapContainer,
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 100,
                                height: 40,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: theme.boxColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 100,
                                height: 40,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: theme.boxColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                            )
                          ]),
                        ),
                      ),
                      Container(
                        height: 200,
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.boxColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EasterEggHistoryPage extends StatefulWidget {
  const EasterEggHistoryPage({Key? key}) : super(key: key);

  @override
  _EasterEggHistoryPageState createState() => _EasterEggHistoryPageState();
}

class _EasterEggHistoryPageState extends State<EasterEggHistoryPage> {
  late Color primaryColor = Colors.blueGrey[100]!;
  late Color secondryColor = white80;
  late Color backColor = Colors.blueGrey[900]!;
  @override
  void initState() {
    secondryColor =
        primaryColor.computeLuminance() > 0.5 ? backColor : secondryColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: primaryColor,
          padding: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.transparent,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: backColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: backColor),
                        ),
                        child: Center(
                            child: Icon(
                          FlutterIcons.arrow_back_mdi,
                          color: primaryColor,
                        )),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 56,
                        margin: EdgeInsets.only(left: 8),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Easter Egg History!",
                            textAlign: TextAlign.center,
                            style: textStyle.copyWith(
                              fontSize: 34,
                              color: secondryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
                  child: ListView.builder(
                      itemExtent: 200,
                      itemCount: 10,
                      itemBuilder: (_, index) {
                        var tag = "MainHero";
                        print(tag);
                        var clipRRect = ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: ProgressiveImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/placeholder.jpeg',
                            thumbnail:
                                "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                            image:
                                "https://images.unsplash.com/photo-1493210977798-4f655ac200a9?auto=format&fit=crop&w=562&q=80",
                            width: MediaQuery.of(context).size.width - 32,
                            height: MediaQuery.of(context).size.width - 32,
                          ),
                        );
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: white80,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: index == 0
                                        ? Hero(
                                            tag: tag,
                                            child: clipRRect,
                                          )
                                        : clipRRect,
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
                                            rating: 3.4,
                                            unratedColor: Colors.amber[400],
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              index > 3.4
                                                  ? FlutterIcons
                                                      .star_outline_mco
                                                  : index == 3
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
                                            "Godo Cafe",
                                            style: textStyle.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                "Tootsie roll gingerbread chocolate bar sesame snaps donut tootsie roll.",
                                                style: textStyle.copyWith(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.normal,
                                                ),
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
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
