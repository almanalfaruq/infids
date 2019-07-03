import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:infids/model/post.dart';

class WebScraper {
  Client client = Client();

  Future<List<Post>> getPostsFromWebsite() async {
    final response =
        await client.get('http://sarjana.jteti.ugm.ac.id/akademik/');
    if (response.statusCode == 200) {
      List<Post> posts = [];
      Document document = parse(response.body);
      List<Element> tableRows =
          document.querySelectorAll('table.table-hover.table-pad > tbody > tr');
      for (Element tableRow in tableRows) {
        Post post = _createFormattedPost(tableRow);
        posts.add(post);
      }
      return posts;
    }
    return [];
  }

  Post _createFormattedPost(Element tableRow) {
    int id = _getId(tableRow);
    String date = _getDate(tableRow);
    PostCategory category = _getCategory(tableRow);
    String title = _getTitle(tableRow);
    Map<String, dynamic> contentAndLink = _getContentAndLink(tableRow);
    String content = contentAndLink['content'];
    String link = contentAndLink['link'];
    return Post(id, date, category, title, content, link: link);
  }

  int _getId(Element tableRow) {
    return int.parse(tableRow.id);
  }

  String _getDate(Element tableRow) {
    return tableRow.querySelector('td.table-date').text.trim();
  }

  PostCategory _getCategory(Element tableRow) {
    return tableRow.querySelector('span.label').text == 'Akademik'
        ? PostCategory.AKADEMIK
        : PostCategory.PERKULIAHAN;
  }

  String _getTitle(Element tableRow) {
    return tableRow.querySelector('b').text.trim();
  }

  Map<String, dynamic> _getContentAndLink(Element tableRow) {
    String content = '';
    String link;
    List<Element> contents = tableRow.getElementsByTagName('p');
    if (contents.length > 10) {
      content = 'Untuk melihat konten, buka melalui browser anda.';
    } else {
      for (Element p in contents) {
        if (p.querySelector('a.btn') == null) {
          if (p.text.trim().isNotEmpty) content += p.text.trim() + '\n';
        }
        else
          link = 'http://sarjana.jteti.ugm.ac.id' + p
              .querySelector('a.btn')
              .attributes['href'];
      }
    }
    return { 'content': content, 'link': link };
  }


}
