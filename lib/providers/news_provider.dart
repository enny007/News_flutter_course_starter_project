import 'package:flutter/material.dart';
import 'package:news_app_flutter_course/services/news_api.dart';

import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList {
    return newsList;
  }

  Future<List<NewsModel>> fetchAllNews(
      {required int pageIndex, required String sortedBy}) async {
    newsList = await NewsApiServices.getNews(
      page: pageIndex,
      sortBy: sortedBy,
    );
    return newsList;
  }

  Future<List<NewsModel>> fetchTopHeadlines() async {
    newsList = await NewsApiServices.getTopHeadlines();
    return newsList;
  }

  Future<List<NewsModel>> searchNewsProvider({required String query}) async {
    newsList = await NewsApiServices.searchNews(query: query);
    return newsList;
  }

  NewsModel findByDate({required String publishedAt}) {
    return newsList.firstWhere(
      (newsModel) => newsModel.publishedAt == publishedAt,
    );
  }
}
