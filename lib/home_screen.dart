import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'models/news.dart';
import "package:flutter/services.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const baseImgUrl =
    'https://img1.hscicdn.com/image/upload/f_auto,t_ds_wide_w_640,q_50/lsci';

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

  Future<List<News>> apiRequest() async {
    try {
      var response =
          await Dio().get('http://18.218.244.144/intern/apis/news?page=1');
      var newsJson = response.data as List;
      List<News> newsGroup =
          newsJson.map((newsJson) => News.fromJson(newsJson)).toList();
      newsGroup.forEach((element) {
        element.image = baseImgUrl + element.image.toString();
      });
      return newsGroup;
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  HomeScreenState() {
    apiRequest().then((value) => {
          setState(() {
            newsGroup = value;
          })
        });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,
        overlays: [SystemUiOverlay.bottom]);
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
          child: Text(
            'My News',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Image.asset('assets/images/double_arrow_up.png'),
        onPressed: () => _scrollUp(),
        backgroundColor: const Color(0xb21D1A61),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text(
              'News',
              style: GoogleFonts.openSans(
                color: Color(0xff1D1A61),
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: ListView.separated(
                controller: _controller,
                itemCount: newsGroup.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 180,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    newsGroup[index].image.toString(),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 15,
                              bottom: 5,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {},
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                      'assets/images/save.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newsGroup[index].title.toString(),
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: Color(0xff1D1A61),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                maxLines: 3,
                              ),
                              Text(
                                newsGroup[index].summary.toString(),
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: const Color(0xff1D1A61),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(newsGroup[index].modifiedAt!),
                                  style: GoogleFonts.openSans(
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xff1D1A61),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
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
