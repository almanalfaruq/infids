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

  String subTitle;

  @override
  void initState() {
    super.initState();
    subTitle = subTitles[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('INFO DTETI'),
                  Text(subTitle),
                ],
              ),
              PopupMenuButton<int>(
                key: Key('button-filter'),
                icon: Icon(Icons.filter_list),
                initialValue: 0,
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
                    subTitle = subTitles[value];
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
                future: this.widget._webScraper.getPostsFromWebsite(),
                builder: (context, AsyncSnapshot<List<Post>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      key: Key('post-list'),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: Key(snapshot.data[index].id.toString()),
                          child: Column(
                            children: <Widget>[
                              Text(snapshot.data[index].title),
                              Text(snapshot.data[index].content),
                              Row(
                                children:
                                    _getBottomRowCard(snapshot.data[index]),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),
        ],
      ),
    );
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
