import 'package:dio/dio.dart';

class NewsAPI {
  final String _endpoint = 'http://18.218.244.144/intern/apis/news?page=1';
  Future<List> getAllNews() async {
    try {
      late final List rawJson;
      await Dio().get(_endpoint).then((value) => rawJson = value.data as List);
      return rawJson;
    } catch (e) {
      rethrow;
    }
  }
}
