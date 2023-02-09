import 'package:dio/dio.dart';
import '../data/apis/news_api.dart';
import '../data/models/news.dart';

abstract class NewsRepositoryImp {
  Future<List<News>?> getAll();
}

class NewsRepository {
  final String baseImageUrl =
      'https://img1.hscicdn.com/image/upload/f_auto,t_ds_wide_w_640,q_50/lsci';

  @override
  Future<List<News>> getAll() async {
    try {
      List response = await NewsAPI().getAllNews();
      List<News> newsGroup = response.map((e) => News.fromJson(e)).toList();
      for (var element in newsGroup) {
        element.image = baseImageUrl + element.image.toString();
      }
      return newsGroup;
    } on DioError catch (e) {
      rethrow;
    }
  }
}
