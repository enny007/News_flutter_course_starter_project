import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_flutter_course/consts/enums.dart';
import 'package:news_app_flutter_course/models/news_model.dart';
import 'package:news_app_flutter_course/providers/news_provider.dart';
import 'package:news_app_flutter_course/screens/search_screen.dart';
import 'package:news_app_flutter_course/utils/utils.dart';
import 'package:news_app_flutter_course/widgets/articles.dart';
import 'package:news_app_flutter_course/widgets/drawer_widget.dart';
import 'package:news_app_flutter_course/widgets/empty_screen.dart';
import 'package:news_app_flutter_course/widgets/loading_widget.dart';
import 'package:news_app_flutter_course/widgets/tabs.dart';
import 'package:news_app_flutter_course/widgets/top_tending.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPage = 0;
  String sortBy = SortByEnum.publishedAt.name;
  // List<NewsModel> newslist = [];
  // @override
  // void didChangeDependencies() {
  //   getNewsList();
  //   super.didChangeDependencies();
  // }

  // Future<List<NewsModel>> getNewsList() async {
  //   List<NewsModel> newslist = await NewsApiServices.getNews();
  //   return newslist;
  // }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    final Size size = Utils(context).getScreenSize;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //a way of making all your appbar icons have a uniform color
          iconTheme: IconThemeData(
            color: color,
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'News App',
            style: GoogleFonts.lobster(
              textStyle: TextStyle(
                fontSize: 20,
                letterSpacing: 0.6,
                color: color,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              onPressed: () {
                //simulate smooth transition
                Navigator.push(
                  context,
                  PageTransition(
                    child: const SearchScreen(),
                    inheritTheme: true,
                    type: PageTransitionType.rightToLeft,
                    ctx: context,
                  ),
                );
              },
              icon: const Icon(IconlyLight.search),
            )
          ],
        ),
        drawer: const DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  TabsWidget(
                    text: 'All news',
                    color: newsType == NewsType.allNews
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    fontSize: newsType == NewsType.allNews ? 22 : 14,
                    fct: () {
                      if (newsType == NewsType.allNews) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.allNews;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TabsWidget(
                    text: 'Top trending',
                    color: newsType == NewsType.topTrending
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    fontSize: newsType == NewsType.topTrending ? 22 : 14,
                    fct: () {
                      if (newsType == NewsType.topTrending) {
                        return;
                      }
                      setState(
                        () => newsType = NewsType.topTrending,
                      );
                    },
                  ),
                ],
              ),
              const Gap(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PaginationButton(
                            function: () {
                              if (currentPage == 0) {
                                return;
                              }
                              setState(() {
                                currentPage -= 1;
                              });
                            },
                            action: 'Prev',
                          ),
                          Flexible(
                            flex: 2,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    color: currentPage == index
                                        ? Colors.blue
                                        : Theme.of(context).cardColor,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentPage = index;
                                        });
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('${index + 1}'),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          PaginationButton(
                            action: 'Next',
                            function: () {
                              if (currentPage == 4) {
                                return;
                              }
                              setState(() {
                                currentPage += 1;
                              });
                            },
                          )
                        ],
                      ),
                    ),
              const Gap(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: DropdownButton(
                            value: sortBy,
                            items: dropDownItems,
                            onChanged: (String? value) {
                              setState(() {
                                sortBy = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
              FutureBuilder<List<NewsModel>>(
                  future: newsType == NewsType.topTrending
                      ? newsProvider.fetchTopHeadlines()
                      : newsProvider.fetchAllNews(
                          pageIndex: currentPage + 1,
                          sortedBy: sortBy,
                        ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return newsType == NewsType.allNews
                          ? LoadingWidget(newsType: newsType)
                          : Expanded(
                              child: LoadingWidget(newsType: newsType),
                            );
                    } else if (snapshot.hasError) {
                      return Expanded(
                        child: EmptyNewsWidget(
                          text: 'an error occured ${snapshot.error}',
                          imagePath: 'assets/images/no_news.png',
                        ),
                      );
                    } else if (snapshot.data == null) {
                      return const Expanded(
                        child: EmptyNewsWidget(
                          text: 'no news found',
                          imagePath: 'assets/images/no_news.png',
                        ),
                      );
                    }
                    return newsType == NewsType.allNews
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (ctx, index) {
                                return ChangeNotifierProvider.value(
                                  value: snapshot.data![index],
                                  child: const ArticlesWidget(),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            height: size.height * 0.6,
                            child: Swiper(
                              autoplayDelay: 8000,
                              autoplay: false,
                              itemWidth: size.width * 0.9,
                              layout: SwiperLayout.STACK,
                              viewportFraction: 0.9,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return ChangeNotifierProvider.value(
                                  value: snapshot.data![index],
                                  child: const TopTrendingWidget(),
                                );
                              },
                            ),
                          );
                  })
            ],
            //LoadingWidget(newType: newsType),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return menuItems;
  }
}

class PaginationButton extends StatelessWidget {
  final String action;
  final Function()? function;
  const PaginationButton({
    Key? key,
    required this.action,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.all(6),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(action),
    );
  }
}
