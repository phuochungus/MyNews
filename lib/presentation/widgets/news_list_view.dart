import 'package:flutter/material.dart';
import '../../data/models/news.dart';
import '../../presentation/widgets/news_list_view_item.dart';

class NewsListView extends StatelessWidget {
  late final ScrollController _controller;
  late final List<News> newsGroup;

  NewsListView(this._controller, this.newsGroup);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      itemCount: newsGroup.length,
      itemBuilder: (context, index) => NewsItem(newsGroup[index]),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
