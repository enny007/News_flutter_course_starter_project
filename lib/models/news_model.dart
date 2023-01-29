import 'package:flutter/cupertino.dart';
import 'package:news_app_flutter_course/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

class NewsModel with ChangeNotifier{
  String newsId,
      sourceName,
      authorName,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      dateToShow,
      content,
      readingTimeText;

  NewsModel({
    required this.newsId,
    required this.title,
    required this.authorName,
    required this.sourceName,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.dateToShow,
    required this.content,
    required this.readingTimeText,
  });

  factory NewsModel.fromJson(dynamic json) {
    String title = json['title'] ?? '';
    String content = json['content'] ?? '';
    String description = json['description'] ?? '';
    String dateShow = '';
    if (json['publishedAt'] != null) {
      dateShow = GlobalMethods.formattedDateText(json['publishedAt']);
    }
    return NewsModel(
      newsId: json['source']['id'] ?? '',
      title: title,
      authorName: json['author'] ?? '',
      sourceName: json['source']['name'] ?? '',
      description: description,
      url: json['url'] ?? '',
      urlToImage: json['urlToImge'] ??
          "https://techcrunch.com/wp-content/uploads/2022/01/locket-app.jpg?w=1390&crop=1",
      publishedAt: json['publishedAt'] ?? '',
      content: content,
      dateToShow: dateShow,
      readingTimeText: readingTime(title + description + content).msg,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['NewsId'] = newsId;
    data['sourceName'] = sourceName;
    data['authorName'] = authorName;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['dateToShow'] = dateToShow;
    data['content'] = content;
    data['readingTimeText'] = readingTimeText;
    return data;
  }

  static List<NewsModel> newsFromSnapShot(List newsnapShot) {
    return newsnapShot.map((e) {
      return NewsModel.fromJson(e);
    }).toList();
  }

  // @override
  // String toString() {
  //   return 'news {newid: $newsId}';
  // }
}
