import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pyd/components/progressive_image_loader.dart';
import 'package:pyd/components/rate-gauge.dart';
import 'package:pyd/constants.dart';
import 'package:pyd/models/summary-card.dart';
import 'package:pyd/pages/pivot_detail_page.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:pyd/providers/pivot_detail_page_provider.dart';

class SummaryCardBox extends StatefulWidget {
  SummaryCardBox({
    Key? key,
    required this.summaryCard,
  }) : super(key: key);

  final SummaryCard summaryCard;

  @override
  _SummaryCardBoxState createState() => _SummaryCardBoxState();
}

class _SummaryCardBoxState extends State<SummaryCardBox> {
  final rnd = Random();
  late String imageHeroTag = "ImageHeroTag${rnd.nextInt(100)}";
  @override
  Widget build(BuildContext context) {
    return buildSummaryCardContainer();
  }

  Widget buildSummaryCardContainer() {
    print("build => SummaryCardContainer => $imageHeroTag");
    return GestureDetector(
      onTap: () {
        print("Card => clicked!");
        context
            .read<PivotDetailPageProvider>()
            .setSelectedSummaryCard(widget.summaryCard);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PivotDetailPage(
              heroImageTag: imageHeroTag,
            ),
          ),
        );
      },
      child: Directionality(
        textDirection: context.watch<HomePageProvider>().direction,
        child: Align(
          // force swipper to have box height
          alignment: Alignment.bottomCenter,
          child: Container(
            height: kContainerHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            // space between card boxes
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
            child: buildLayoutBuilder(),
          ),
        ),
      ),
    );
  }

  LayoutBuilder buildLayoutBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight =
            kContainerHeight - kCardRateBoxHeight + kImageOutHeight;
        final imageWidth = constraints.maxWidth * 0.45 - 4;
        final infoWidth = constraints.maxWidth * 0.55 - 4;
        return Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSummaryCardImage(imageWidth, imageHeight),
                  buildSummaryCardDetail(infoWidth, context),
                ],
              ),
              // child: buildRowOfImageAndInfo(constraints, context),
            ),
            buildRateContainer()
          ],
        );
      },
    );
  }

  Container buildSummaryCardDetail(double infoWidth, BuildContext context) {
    return Container(
      width: infoWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildStarsAndHeart(context),
          buildSpace(),
          buildSummaryCardTitle(),
          buildSummaryCardSubtitle()
        ],
      ),
    );
  }

  Padding buildSummaryCardSubtitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        widget.summaryCard.subtitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black38,
          fontSize: 16,
        ),
      ),
    );
  }

  Padding buildSummaryCardTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        widget.summaryCard.title,
        style: TextStyle(
          color: Colors.black45,
          fontSize: 20,
        ),
      ),
    );
  }

  Expanded buildSpace() => Expanded(child: SizedBox());

  Row buildStarsAndHeart(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildStarsBar(),
        buildHeartButton(context),
      ],
    );
  }

  Padding buildHeartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minHeight: 0, minWidth: 0),
        icon: Icon(
          context.watch<HomePageProvider>().isLiked
              ? Icons.favorite
              : Icons.favorite_border,
          size: 25,
          color: Colors.red,
        ),
        onPressed: () {
          context.read<HomePageProvider>().toggleLike();
        },
      ),
    );
  }

  RatingBarIndicator buildStarsBar() {
    return RatingBarIndicator(
      rating: widget.summaryCard.currentTotalRate,
      unratedColor: Colors.amber[400],
      itemBuilder: (context, index) => Icon(
        index > widget.summaryCard.currentTotalRate
            ? Icons.star_outline_rounded
            : index == widget.summaryCard.currentTotalRate.toInt()
                ? Icons.star_half_rounded
                : Icons.star_rounded,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 30.0,
      direction: Axis.horizontal,
    );
  }

  Widget buildSummaryCardImage(double imageWidth, double imageHeight) {
    final direction = context.watch<HomePageProvider>().direction;
    double shadowDirection = direction == TextDirection.ltr ? -5 : 5;
    return Container(
      width: imageWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(shadowDirection, 2), // changes position of shadow
          ),
        ],
      ),
      child: OverflowBox(
        alignment: Alignment.bottomLeft,
        maxHeight: imageHeight,
        minWidth: imageWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Hero(
            tag: imageHeroTag,
            child: ProgressiveImage.assetNetwork(
              placeholder: 'assets/placeholder.jpeg',
              thumbnail: widget.summaryCard.media[0].url
                  .replaceAll("/x_width/y_height", "/180/180"),
              image: widget.summaryCard.media[0].url
                  .replaceAll("/x_width/y_height", "/180/180"),
              width: imageWidth,
              height: imageHeight,
            ),
          ),
        ),
      ),
    );
  }
}

Container buildRateContainer() {
  return Container(
    height: kCardRateBoxHeight,
    color: Colors.transparent,
    padding: EdgeInsets.only(top: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRateGauge(
          color: Colors.orange,
          score: 2,
        ),
        buildRateGauge(
          color: Colors.red,
          score: 2,
        ),
        buildRateGauge(
          color: Colors.lightGreen,
          score: 2,
        ),
        buildRateGauge(
          color: Colors.purple,
          score: 2,
        ),
      ],
    ),
  );
}

Row buildRateGauge({
  required Color color,
  required double score,
}) {
  return Row(
    children: [
      RateGauge(
        color: color,
        score: score,
      ),
      SizedBox(width: 8),
    ],
  );
}
