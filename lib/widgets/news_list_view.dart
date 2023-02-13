import 'package:flutter/material.dart';
import 'package:news_app/data/models/news.dart';
import 'package:news_app/presentation/widgets/news_list_view_item.dart';

class NewsListView extends StatelessWidget {
  final ScrollController _controller;
  final List<News> newsGroup;

  const NewsListView(this._controller, this.newsGroup);
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
