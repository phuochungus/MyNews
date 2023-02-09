import 'package:flutter/material.dart';
import 'package:news_app/repositories/news_repository.dart';
import "package:flutter/services.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/data/models/news.dart';
import 'package:news_app/presentation/widgets/news_list_view.dart';

class HomeScreen extends StatefulWidget {
  List<News> newsGroup = List.empty();
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<News> newsGroup = List.empty();

  final ScrollController _controller = ScrollController();
  void _scrollUp() {
    _controller.animateTo(_controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  HomeScreenState() {
    NewsRepository().getAll().then((value) {
      setState(() {
        newsGroup = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.leanBack,
      overlays: [SystemUiOverlay.bottom],
    );
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scrollUp(),
        backgroundColor: const Color(0xb21D1A61),
        child: Image.asset('assets/images/double_arrow_up.png'),
      ),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: NewsListView(_controller, newsGroup),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Drawer();
  }
}
