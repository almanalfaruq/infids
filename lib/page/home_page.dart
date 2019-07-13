import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infids/fonts/infids_icons.dart';
import 'package:infids/model/post.dart';
import 'package:infids/provider/web_scraper.dart';

class HomePage extends StatefulWidget {
  final WebScraper _webScraper = WebScraper();

  HomePage();

  HomePage.forTest({Client client}) {
    _webScraper.client = client;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> subTitles = [
    'Menampilkan Semua Kategori',
    'Menampilkan Kategori Akademik',
    'Menampilkan Kategori Perkuliahan',
  ];

  List<Post> posts = [];
  List<Post> categorizedPost = [];

  bool isPostLoaded = false;

  String subTitle;
  int popupMenuValue = 0;

  @override
  void initState() {
    super.initState();
    subTitle = subTitles[0];
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Color.fromRGBO(1, 23, 46, 1),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 20, top: 20),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'INFO DTETI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(230, 200, 0, 1),
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 15, top: 18),
                      child: PopupMenuButton<int>(
                        key: Key('button-filter'),
                        icon: Icon(
                          InfidsIcon.filter,
                          color: Color.fromRGBO(230, 200, 0, 1),
                        ),
                        tooltip: 'Filter Kategori',
                        initialValue: popupMenuValue,
                        itemBuilder: (builder) {
                          return [
                            PopupMenuItem<int>(
                              key: Key('all-category'),
                              child: Text('Semua Kategori'),
                              value: 0,
                            ),
                            PopupMenuItem<int>(
                              key: Key('academic-category'),
                              child: Text('Kategori Akademik'),
                              value: 1,
                            ),
                            PopupMenuItem<int>(
                              key: Key('lecture-category'),
                              child: Text('Kategori Perkuliahan'),
                              value: 2,
                            ),
                          ];
                        },
                        onSelected: (value) {
                          List<Post> tempPostCategorized = posts;
                          if (value != 0) {
                            tempPostCategorized = posts
                                .where((post) =>
                            post.category ==
                                PostCategory.values[value - 1])
                                .toList();
                          }
                          setState(() {
                            popupMenuValue = value;
                            subTitle = subTitles[value];
                            categorizedPost = tempPostCategorized;
                          });
                        },
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    child: Container(),
                    preferredSize: Size.fromHeight(20),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
                child: isPostLoaded
                    ? ListView.builder(
                  key: Key('post-list'),
                  itemCount: categorizedPost.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      key: Key(categorizedPost[index].id.toString()),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 18),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                categorizedPost[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13),
                              child: Text(categorizedPost[index].content),
                            ),
                            Row(
                              children: _getBottomRowCard(
                                  categorizedPost[index]),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: CircularProgressIndicator(
                    key: Key('refresh-indicator'),
                  ),
                ),
                onRefresh: _onRefresh),
          )),
    );
  }

  Future<void> _onRefresh() async {
    posts = await this.widget._webScraper.getPostsFromWebsite();
    if (posts.length > 0 && this.mounted) {
      setState(() {
        categorizedPost = posts;
        isPostLoaded = true;
      });
    }
  }

  List<Widget> _getBottomRowCard(Post post) {
    List<Widget> widgets = [];
    widgets.add(Expanded(
      child: Row(
        children: <Widget>[
          Text(
            post.category == PostCategory.AKADEMIK ? 'Akademik' : 'Perkuliahan',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: post.category == PostCategory.AKADEMIK
                    ? Color.fromRGBO(0, 187, 232, 1)
                    : Color.fromRGBO(230, 200, 0, 1)),
          ),
          Text(
            ' - ${post.date}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(128, 128, 128, 1)),
          ),
        ],
      ),
    ));
    if (post.link != null) {
      widgets.add(IconButton(
        icon: Icon(InfidsIcon.download),
        iconSize: 17,
        tooltip: 'Download File',
        onPressed: () {},
      ));
    }
    widgets.add(IconButton(
      icon: Icon(InfidsIcon.publish),
      iconSize: 17,
      tooltip: 'Buka Dalam Browser',
      onPressed: () {},
    ));
    widgets.add(IconButton(
      icon: Icon(Icons.share),
      iconSize: 17,
      tooltip: 'Share Informasi',
      onPressed: () {},
    ));
    return widgets;
  }
}
