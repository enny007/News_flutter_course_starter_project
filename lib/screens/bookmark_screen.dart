import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_flutter_course/utils/utils.dart';
import 'package:news_app_flutter_course/widgets/empty_screen.dart';

import '../widgets/articles.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return Scaffold(
      appBar: AppBar(
        //a way of making all your appbar icons have a uniform color
        iconTheme: IconThemeData(
          color: color,
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bookmarks',
          style: GoogleFonts.lobster(
            textStyle: TextStyle(
              fontSize: 20,
              letterSpacing: 0.6,
              color: color,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const EmptyNewsWidget(
        text: 'Your Bookmarks is empty',
        imagePath: 'assets/images/bookmark.png',
      ),
      // ListView.builder(
      //     itemCount: 20,
      //     itemBuilder: (_, index) {
      //       return const ArticlesWidget();
      //     }),
    );
  }
}
