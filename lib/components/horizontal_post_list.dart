import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:pyd/components/progressive_image_loader.dart';
import 'package:pyd/models/post_model.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HorizontalPostList extends StatefulWidget {
  HorizontalPostList({
    Key? key,
  }) : super(key: key);

  @override
  _HorizontalPostListState createState() => _HorizontalPostListState();
}

class _HorizontalPostListState extends State<HorizontalPostList> {
  late List<PostModel> posts;
  @override
  void initState() {
    posts = context.read<HomePageProvider>().posts as List<PostModel>;

    super.initState();
  }

  Widget? _widget;
  @override
  Widget build(BuildContext context) {
    print(
        "buildHorizontalPostList, ${PivotHomePageCard.containerHeight + PivotHomePageCard.cardRateBoxHeight}");
    final double contextWidth = MediaQuery.of(context).size.width;
    final originalFraction = (contextWidth - 16 - 16) / contextWidth;
    final fraction = MediaQuery.of(context).size.width > 720
        ? originalFraction / 3
        : originalFraction;
    if (_widget == null) {
      _widget = buildAlign(context, fraction);
    }

    return _widget!;
  }

  Align buildAlign(BuildContext context, double fraction) {
    return Align(
      alignment: MediaQuery.of(context).size.width > 720
          ? Alignment.centerRight
          : Alignment.bottomCenter,
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.width > 720
            ? MediaQuery.of(context).size.height
            : PivotHomePageCard.containerHeight +
                PivotHomePageCard.cardRateBoxHeight,
        width: MediaQuery.of(context).size.width > 720
            ? 400
            : MediaQuery.of(context).size.width,
        child: Swiper(
          scrollDirection: MediaQuery.of(context).size.width > 720
              ? Axis.vertical
              : Axis.horizontal,
          index: context.watch<HomePageProvider>().selectedPostIndex,
          onIndexChanged: (index) {
            context.read<HomePageProvider>().changeSelectedPostIndex(index);
            var provider = context.read<BackgroundMapProvider>();
            provider.goToLocation(provider.pins[index]);
          },
          physics: AlwaysScrollableScrollPhysics(),
          viewportFraction:
              MediaQuery.of(context).size.width > 720 ? .5 : fraction,
          //     MediaQuery.of(context).size.width > 1080 ? 0.3 : 0.9,
          autoplay: false,
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            final post = posts[index];
            return PivotHomePageCard(
              post: post,
            );
          },
        ),
      ),
    );
  }
}

class PivotHomePageCard extends StatelessWidget {
  PivotHomePageCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;
  static const double imageOutHeight = 32;
  static const double cardRateBoxHeight = 64.0;
  static const double containerHeight = 240.0;

  Widget? _widget;
  @override
  Widget build(BuildContext context) {
    if (_widget == null) {
      print("buildPivotHomePageCard ${post.media[0].url}");
      _widget = buildAlign();
    }

    return _widget!;
  }

  Align buildAlign() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: containerHeight,
        // constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black12,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: containerHeight - cardRateBoxHeight,
                        width: constraints.maxWidth / 2.5,
                        padding: EdgeInsets.only(left: 8.0),
                        child: OverflowBox(
                          alignment: Alignment.bottomLeft,
                          maxHeight: containerHeight -
                              cardRateBoxHeight +
                              imageOutHeight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: ProgressiveImage.assetNetwork(
                              placeholder: 'assets/placeholder.jpeg',
                              thumbnail: post.media[0].url
                                  .replaceAll("/x_width/y_height", "/180/180"),
                              image: post.media[0].url
                                  .replaceAll("/x_width/y_height", "/180/180"),
                              width: constraints.maxWidth / 2.5,
                              height: containerHeight -
                                  cardRateBoxHeight +
                                  imageOutHeight,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: containerHeight - cardRateBoxHeight,
                        width:
                            constraints.maxWidth - (constraints.maxWidth / 2.5),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              key: Key("CardStarAndHeartBox"),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBarIndicator(
                                  rating: post.currenttotalRate,
                                  unratedColor: Colors.amber[400],
                                  itemBuilder: (context, index) => Icon(
                                    index > post.currenttotalRate
                                        ? Icons.star_outline_rounded
                                        : index == post.currenttotalRate.toInt()
                                            ? Icons.star_half_rounded
                                            : Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 30.0,
                                  direction: Axis.horizontal,
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints:
                                      BoxConstraints(minHeight: 0, minWidth: 0),
                                  icon: Icon(
                                    context.watch<HomePageProvider>().isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<HomePageProvider>()
                                        .toggleLike();
                                  },
                                )
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                post.title,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                post.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: cardRateBoxHeight,
                  color: Colors.transparent,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RateGauge(
                        color: Colors.orange,
                        score: 2,
                      ),
                      RateGauge(
                        color: Colors.red,
                        score: 3.5,
                      ),
                      RateGauge(
                        color: Colors.blue,
                        score: 2.8,
                      ),
                      RateGauge(
                        color: Colors.purple,
                        score: 4.3,
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class RateGauge extends StatelessWidget {
  RateGauge({Key? key, required this.color, required this.score})
      : super(key: key);

  final Color color;
  final double score;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: SizedBox(
        height: PivotHomePageCard.cardRateBoxHeight - 16,
        width: PivotHomePageCard.cardRateBoxHeight - 16,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                axisLineStyle: AxisLineStyle(
                    color: color.withOpacity(0.4),
                    thickness: 0.2,
                    thicknessUnit: GaugeSizeUnit.factor),
                startAngle: 270,
                endAngle: 270,
                minimum: 0,
                maximum: 5,
                showTicks: false,
                canScaleToFit: true,
                showLabels: false,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startWidth: 4,
                    endWidth: 4,
                    startValue: 0,
                    endValue: score,
                    color: color,
                  ),
                ],
                // pointers: <GaugePointer>[
                //   NeedlePointer(value: 90)
                // ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    positionFactor: 0.1,
                    widget: Container(
                      child: Text(
                        score.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  )
                ])
          ],
        ),
      ),
    );
  }
}
