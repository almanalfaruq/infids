import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infids/dao/post_dao.dart';
import 'package:infids/fonts/infids_icons.dart';
import 'package:infids/model/post.dart';
import 'package:infids/provider/web_scraper.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  static final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  PostDao _postDao = PostDao();
  SharedPreferences _prefs;

  List<String> subTitles = [
    'Menampilkan Semua Kategori',
    'Menampilkan Kategori Akademik',
    'Menampilkan Kategori Perkuliahan',
  ];

  List<Post> posts = [];
  List<Post> categorizedPost = [];

  String subTitle;
  int popupMenuValue = 0;

  BuildContext _context;

  final SnackBar _snackBar = SnackBar(
    content: Text('Gagal memperbarui data'),
    action: SnackBarAction(
      key: Key('button-retry'),
      label: 'Coba lagi',
      onPressed: () {
        _refreshIndicatorKey.currentState?.show();
      },
    ),
    duration: Duration(minutes: 5),
  );

  @override
  void initState() {
    super.initState();
    subTitle = subTitles[0];
    Future.delayed(Duration(milliseconds: 100), () {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          _context = context;
          return NestedScrollView(
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
                key: _refreshIndicatorKey,
                child: ListView.builder(
                  key: Key('post-list'),
                  itemCount: categorizedPost.length,
                  itemBuilder: (context, index) {
                    return _buildCard(categorizedPost[index]);
                  },
                ),
                onRefresh: _onRefresh),
          );
        },
      ),
    );
  }

  Widget _buildCard(Post post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      key: Key(post.id.toString()),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Text(post.content),
            ),
            Row(
              children: _getBottomRowCard(post),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _prefs = await SharedPreferences.getInstance();
    _setPostsFromDatabase();
    posts = await this.widget._webScraper.getPostsFromWebsite();
    if (posts.length > 0 && this.mounted) {
      await _prefs.setInt('id', posts[0].id);
      _insertPostsToDatabase();
      setState(() {
        categorizedPost = posts;
      });
    } else if (posts.length == 0) {
      Scaffold.of(_context).showSnackBar(_snackBar);
    }
  }

  void _setPostsFromDatabase() async {
    await _postDao.open();
    posts = await _postDao.getAllPost();
    if (posts.length > 0) {
      setState(() {
        categorizedPost = posts;
      });
    }
    await _postDao.close();
  }

  void _insertPostsToDatabase() async {
    await _postDao.open();
    await _postDao.insertAll(posts);
    await _postDao.close();
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
        onPressed: () async {
          if (await canLaunch('${post.link}')) {
            launch('${post.link}');
          }
        },
      ));
    }
    widgets.add(IconButton(
      icon: Icon(InfidsIcon.publish),
      iconSize: 17,
      tooltip: 'Buka Dalam Browser',
      onPressed: () async {
        if (await canLaunch('${WebScraper.ACADEMIC_URL}#${post.id}')) {
          launch('${WebScraper.ACADEMIC_URL}#${post.id}');
        }
      },
    ));
    widgets.add(IconButton(
      icon: Icon(Icons.share),
      iconSize: 17,
      tooltip: 'Share Informasi',
      onPressed: () {
        Share.share(post.postFormattedString);
      },
    ));
    return widgets;
  }
}
