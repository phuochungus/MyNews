import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/business_login/blocs/home_screen_bloc.dart';
import 'package:news_app/data/models/news.dart';
import 'package:news_app/data/repositories/news_repository.dart';
import 'package:news_app/presentation/widgets/news_list_view.dart';
import '../../business_login/blocs/home_screen_event.dart';
import '../../business_login/blocs/home_screen_state.dart';

class HomeScreen extends StatelessWidget {
  List<News> newsGroup = List.empty();

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.leanBack,
      overlays: [SystemUiOverlay.bottom],
    );
    return RepositoryProvider(
      create: (context) => NewsRepository(),
      child: BlocProvider(
        create: (context) =>
            HomeScreenBloc(RepositoryProvider.of<NewsRepository>(context))
              ..add(FetchNews()),
        child: Scaffold(
          drawer: NavigationDrawer(),
          appBar: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xff1D1A61), Color(0xff18DAB8)]),
              ),
            ),
            toolbarHeight: 90,
            title: const Text(
              'My News',
              style: TextStyle(fontSize: 23),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: CustomFAB(_scrollController),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Text(
                  'News',
                  style: GoogleFonts.openSans(
                      color: const Color(0xff1D1A61),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case NewsStatus.initial:
                        return const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      case NewsStatus.success:
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: NewsListView(_scrollController,
                              state.newsGroup, state.hasReachMax),
                        );
                      case NewsStatus.failure:
                        return const Align(
                          alignment: Alignment.center,
                          child: Text('The is an error occurred!'),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFAB extends StatelessWidget {
  final ScrollController _scrollController;
  const CustomFAB(this._scrollController);

  void _scrollUp() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          child: FloatingActionButton(
            onPressed: () {
              _scrollUp();
            },
            backgroundColor: const Color(0xb21D1A61),
            child: Image.asset('assets/images/double_arrow_up.png'),
          ),
        ),
      ],
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Drawer();
  }
}
