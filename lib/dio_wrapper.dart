// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DioWrapper {
  Future<Response<dynamic>> get(String url) {
    try {
      return Dio().get(url);
    } catch (e) {
      rethrow;
    }
  }
}
