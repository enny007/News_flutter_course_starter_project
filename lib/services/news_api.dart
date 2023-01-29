import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_flutter_course/consts/api_const.dart';
import 'package:news_app_flutter_course/consts/https_exception.dart';
import 'package:news_app_flutter_course/models/news_model.dart';

class NewsApiServices {
  static Future<List<NewsModel>> getNews(
      {required int page, required String sortBy}) async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=ebfc27a6a5004d538280b8c37ffdc360');
    try {
      var uri = Uri.https(
        BASE_URL,
        'v2/everything',
        {
          'q': 'bitcoin',
          'pageSize': '5',
          'domain': 'bbc.co.uk, techcrunch.com, engadget.com',
          // 'apiKey': Api_key,
          'page': page.toString(),
          'sortBy': sortBy.toString(),
        },
      );
      var response = await http.get(
        uri,
        headers: {
          'x-Api-key': Api_key,
        },
      );
      var data = jsonDecode(response.body) as Map;
      List tempNewsData = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var news in data['articles']) {
        //Append this news item into the empty list and pass it into the fromJson method
        tempNewsData.add(news);
      
      }
      return NewsModel.newsFromSnapShot(tempNewsData);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<NewsModel>> getTopHeadlines() async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=ebfc27a6a5004d538280b8c37ffdc360');
    try {
      var uri = Uri.https(
        BASE_URL,
        'v2/top-headlines',
        {'country': 'us'},
      );
      var response = await http.get(
        uri,
        headers: {
          'x-Api-key': Api_key,
        },
      );
      var data = jsonDecode(response.body) as Map;
      List tempNewsData = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var news in data['articles']) {
        //Append this news item into the empty list and pass it into the fromJson method
        tempNewsData.add(news);
        // log(news.toString());
        // print(data['articles'].length);
      }
      return NewsModel.newsFromSnapShot(tempNewsData);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<NewsModel>> searchNews(
      { required String query}) async {
    // var url = Uri.parse(
    //     'https://newsapi.org/v2/everything?q=bitcoin&pageSize=5&apiKey=ebfc27a6a5004d538280b8c37ffdc360');
    try {
      var uri = Uri.https(
        BASE_URL,
        'v2/everything',
        {
          'q': query.toString(),
          'pageSize': '10',
          'domain': 'bbc.co.uk, techcrunch.com, engadget.com',
        },
      );
      var response = await http.get(
        uri,
        headers: {
          'x-Api-key': Api_key,
        },
      );
      var data = jsonDecode(response.body) as Map;
      List tempNewsData = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var news in data['articles']) {
        //Append this news item into the empty list and pass it into the fromJson method
        tempNewsData.add(news);
        // log(news.toString());
        // print(data['articles'].length);
      }
      return NewsModel.newsFromSnapShot(tempNewsData);
    } catch (e) {
      throw e.toString();
    }
  }

}
