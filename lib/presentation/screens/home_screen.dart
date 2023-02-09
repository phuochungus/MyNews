import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/business_login/blocs/home_screen_bloc.dart';
import 'package:news_app/data/models/news.dart';
import 'package:news_app/data/repositories/news_repository.dart';
import 'package:news_app/presentation/widgets/news_list_view.dart';

class HomeScreen extends StatelessWidget {
  List<News> newsGroup = List.empty();
  final ScrollController _controller = ScrollController();

  SnackBar snackBar = const SnackBar(content: Text('data not load'));
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
              ..add(LoadNews()),
        child: Scaffold(
          drawer: NavigationDrawer(),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xff1D1A61), Color(0xff18DAB8)]),
              ),
            ),
            toolbarHeight: 90,
            title: const Align(
              alignment: Alignment.center,
              child: Text(
                'My News',
                style: TextStyle(fontSize: 23),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: CustomFAB(_controller),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Text(
                  'News',
                  style: GoogleFonts.openSans(
                    color: const Color(0xff1D1A61),
                    fontSize: 20,
                  ),
                ),
              ),
              BlocBuilder<HomeScreenBloc, HomeScreenState>(
                builder: (context, state) {
                  if (state is LoadingNewsState) {
                    return const Align(
                      child: Text('Loading'),
                      alignment: Alignment.center,
                    );
                  }

                  if (state is LoadedNewsState) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: NewsListView(_controller, state.payload),
                      ),
                    );
                  }
                  print(state);
                  return Text('No State');
                },
              )
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
          margin: EdgeInsets.all(5),
          child: FloatingActionButton(
              onPressed: () {
                print('pressed');
                BlocProvider.of<HomeScreenBloc>(context).add(LoadNews());
              },
              backgroundColor: const Color(0xb21D1A61),
              child: Icon(Icons.replay)),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: FloatingActionButton(
            onPressed: () {
              print('pressed');
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
