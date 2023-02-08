import 'package:flutter/material.dart';

import 'models/news.dart';

class NewsItem extends StatelessWidget {
  late final News news;
  String t;
  NewsItem(this.t);
  @override
  Widget build(BuildContext context) {
    return Text(t);
  }
}
