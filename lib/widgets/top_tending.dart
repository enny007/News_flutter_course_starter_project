import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../models/news_model.dart';
import '../screens/blog_details.dart';
import '../screens/news_details_webview.dart';
import '../utils/utils.dart';

class TopTrendingWidget extends StatelessWidget {
  const TopTrendingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              NewsDetailsScreen.routeName,
              arguments: newsProvider.publishedAt,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  boxFit: BoxFit.fill,
                  errorWidget: Image.asset('assets/images/empty_image.png'),
                  imageUrl: newsProvider.url,
                  height: size.height * 0.33,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  newsProvider.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Flexible(
                child: Row(
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
                        icon: Icon(
                          Icons.link,
                          color: color,
                        )),
                    const Spacer(),
                    SelectableText(
                      newsProvider.dateToShow,
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
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
