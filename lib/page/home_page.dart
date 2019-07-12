import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infids/model/post.dart';
import 'package:infids/web_scraper.dart';

class HomePage extends StatefulWidget {
  WebScraper _webScraper = WebScraper();

  HomePage();

  HomePage.forTest(Client client) {
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
      appBar:  AppBar(
        bottomOpacity: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('INFO DTETI'),
            Text(subTitle),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            key: Key('button-filter'),
            icon: Icon(Icons.filter_list),
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
              setState(() {
                popupMenuValue = value;
                subTitle = subTitles[value];
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
                child: isPostLoaded ? ListView.builder(
                  key: Key('post-list'),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      key: Key(posts[index].id.toString()),
                      child: Column(
                        children: <Widget>[
                          Text(posts[index].title),
                          Text(posts[index].content),
                          Row(
                            children: _getBottomRowCard(posts[index]),
                          )
                        ],
                      ),
                    );
                  },
                ) : Center(
                  child: CircularProgressIndicator(
                    key: Key('refresh-indicator'),
                  ),
                ),
                onRefresh: _onRefresh),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    List<Post> postFromWebsite =
        await this.widget._webScraper.getPostsFromWebsite();
    if (postFromWebsite.length > 0 && this.mounted) {
      setState(() {
        posts = postFromWebsite;
        isPostLoaded = true;
      });
    }
  }

  List<Widget> _getBottomRowCard(Post post) {
    List<Widget> widgets = [];
    widgets.add(Text(
        post.category == PostCategory.AKADEMIK ? 'Akademik' : 'Perkuliahan'));
    if (post.link != null) {
      widgets.add(IconButton(
        icon: Icon(Icons.file_download),
        onPressed: () {},
      ));
    }
    widgets.add(IconButton(
      icon: Icon(Icons.open_in_browser),
      onPressed: () {},
    ));
    widgets.add(IconButton(
      icon: Icon(Icons.share),
      onPressed: () {},
    ));
    return widgets;
  }
}
