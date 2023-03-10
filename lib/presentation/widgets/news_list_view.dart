import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/business_login/blocs/home_screen_bloc.dart';
import 'package:news_app/business_login/blocs/home_screen_event.dart';
import '../../data/models/news.dart';
import '../../presentation/widgets/news_list_view_item.dart';

class NewsListView extends StatefulWidget {
  final List<News> newsGroup;
  final bool hasReachMax;
  final ScrollController _scrollController;
  final bool isError;

  const NewsListView(
      this._scrollController, this.newsGroup, this.hasReachMax, this.isError,
      {super.key});

  @override
  State<StatefulWidget> createState() => NewsListViewState();
}

class NewsListViewState extends State<NewsListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = widget._scrollController;
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0) {
        context.read<HomeScreenBloc>().add(FetchNewsFromAPI());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeScreenBloc>().add(FetchNewsFromAPI());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.999);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.newsGroup.length + (widget.hasReachMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (widget.hasReachMax == false && index == widget.newsGroup.length) {
          if (widget.isError) {
            return const Text('error');
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 2),
            child: const Align(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return NewsItem(widget.newsGroup[index]);
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
