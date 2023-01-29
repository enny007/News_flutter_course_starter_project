import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:news_app_flutter_course/models/news_model.dart';
import 'package:news_app_flutter_course/screens/blog_details.dart';
import 'package:news_app_flutter_course/screens/news_details_webview.dart';
import 'package:news_app_flutter_course/utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../consts/styles.dart';

class ArticlesWidget extends StatelessWidget {
  const ArticlesWidget({
    super.key,
  });
  // final String imageUrl, title, url, dateToShow, readingTime;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final newsProvider = Provider.of<NewsModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            //we need an Id to isolate newsfeed in other to open the desciption page
            Navigator.pushNamed(
              context,
              NewsDetailsScreen.routeName,
              arguments: newsProvider.publishedAt,
            );
          },
          child: Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 60,
                  width: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: newsProvider.publishedAt,
                        child: FancyShimmerImage(
                          height: size.height * 0.12,
                          width: size.height * 0.12,
                          boxFit: BoxFit.fill,
                          imageUrl: newsProvider.urlToImage,
                          errorWidget:
                              Image.asset('assets/images/empty_image.png'),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newsProvider.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: smallTextStyle,
                          ),
                          const Gap(5),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '🧭 ${newsProvider.readingTimeText}',
                              style: smallTextStyle,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: NewsDetailWebView(
                                        url: newsProvider.url,
                                      ),
                                      inheritTheme: true,
                                      type: PageTransitionType.rightToLeft,
                                      ctx: context,
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.link,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                newsProvider.dateToShow,
                                maxLines: 1,
                                style: smallTextStyle,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
