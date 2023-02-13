import 'package:dio/dio.dart';

class NewsMockAPI {
  final String _endpoint = 'https://63e7aa85ac3920ad5be1a529.mockapi.io/news';
  Future<List> getAllNews() async {
    try {
      var response = await Dio().get(_endpoint);
      List listOfObject = response.data as List;
      return listOfObject;
    } catch (e) {
      rethrow;
    }
  }
}
