import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:pyd/components/progressive_image_loader.dart';
import 'package:pyd/components/summary_card.dart';
import 'package:pyd/models/summary-card.dart';
import 'package:pyd/providers/home_page_provider.dart';
import 'package:pyd/providers/pivot_detail_page_provider.dart';

class PivotDetailPage extends StatefulWidget {
  static String path = "PivotDetailPage";
  PivotDetailPage({
    this.heroImageTag = "HeroImage",
    this.pivotId,
  });

  final String heroImageTag;
  final String? pivotId;
  @override
  _PivotDetailPageState createState() => _PivotDetailPageState();
}

class _PivotDetailPageState extends State<PivotDetailPage> {
  late SummaryCard pivot;
  late PivotDetailPageProvider _provider;

  @override
  void initState() {
    // TODO: implement initState
    _provider = Provider.of<PivotDetailPageProvider>(context, listen: false);

    if (_provider.selectedSummaryCard != null) {
      pivot = _provider.selectedSummaryCard!;
    }
    print("DETAIL DATA HAS BEEN FETCHED 1");
    _provider.fetchDetailPageData().then((_) {
      print("DETAIL DATA HAS BEEN FETCHED 2");
      setState(() {
        print("DETAIL DATA HAS BEEN FETCHED 3");
        pivot = _provider.pivot!;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: context.watch<HomePageProvider>().direction,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.green,
              expandedHeight: MediaQuery.of(context).size.height / 3,
              pinned: true,
              flexibleSpace: Swiper(
                index: 0,
                viewportFraction: 0.8,
                autoplay: false,
                loop: true,
                itemCount: pivot.media.length,
                itemBuilder: (_, int index) {
                  var imageURL = pivot.media[index].url;
                  if (index == 0) {
                    return Hero(
                      tag: widget.heroImageTag,
                      child: buildProgressiveImage(imageURL, context),
                    );
                  } else {
                    return buildProgressiveImage(imageURL, context);
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRateContainer(pivot.rates),
                    SizedBox(height: 16),
                    Text(
                      pivot.title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      pivot.subtitle,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    SizedBox(height: 16),
                    ...pivot.contacts.map((contact) {
                      return Text(
                        "${pivot.contacts[0].url}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      );
                    }),
                    SizedBox(height: 16),
                    Text(
                      "Published on 2021 Monday",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.blueAccent,
                height: 300,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.amber,
                height: 300,
              ),
            )
            // Container(
            //   color: Colors.amber,
            //   child: Swiper(
            //     index: 0,
            //     viewportFraction: 0.9,
            //     autoplay: false,
            //     loop: false,
            //     itemCount: pivot.media.length,
            //     itemBuilder: (_, int index) {
            //       if (index == 0) {
            //         return Hero(
            //           tag: widget.heroImageTag,
            //           child: ProgressiveImage.assetNetwork(
            //             placeholder: 'assets/placeholder.jpeg',
            //             thumbnail: pivot.media[0].url
            //                 .replaceAll("/x_width/y_height", "/180/180"),
            //             image: pivot.media[0].url
            //                 .replaceAll("/x_width/y_height", "/300/400"),
            //             width: 300,
            //             height: 400,
            //           ),
            //         );
            //       } else {
            //         return ProgressiveImage.assetNetwork(
            //           placeholder: 'assets/placeholder.jpeg',
            //           thumbnail: pivot.media[0].url
            //               .replaceAll("/x_width/y_height", "/180/180"),
            //           image: pivot.media[0].url
            //               .replaceAll("/x_width/y_height", "/300/400"),
            //           width: 300,
            //           height: 400,
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  ProgressiveImage buildProgressiveImage(
      String imageURL, BuildContext context) {
    return ProgressiveImage.assetNetwork(
      placeholder: 'assets/placeholder.jpeg',
      thumbnail: imageURL.replaceAll("/x_width/y_height", "/180/180"),
      image: imageURL.replaceAll("/x_width/y_height", "/800/500"),
      width: 0.8 * MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }
}
