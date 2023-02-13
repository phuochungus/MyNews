import 'package:dio/dio.dart';
import '../models/news.dart';
import '../apis/news_api.dart';

abstract class NewsRepositoryImp {
  Future<List<News>> getAll();
}

class NewsRepository {
  Future<List<News>> getNewsOnPage(int page) async {
    const String baseImageUrl =
        'https://img1.hscicdn.com/image/upload/f_auto,t_ds_wide_w_640,q_50/lsci';
    try {
      List response = await NewsAPI().getNewsOnPage(page);
      List<News> newsGroup = response.map((e) => News.fromAPIMap(e)).toList();
      for (var element in newsGroup) {
        element.imageUrl = baseImageUrl + element.imageUrl.toString();
      }
      return newsGroup;
    } on DioError catch (e) {
      throw Exception('call API failed');
    }
  }
}
