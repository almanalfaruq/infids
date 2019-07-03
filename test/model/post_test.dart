import 'package:infids/model/post.dart';
import 'package:test/test.dart';

void main() {
  group('Membuat Object Post', () {
    test('Membuat Post dengan kategori', () {
      final postAkademik =
          Post(1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');
      final postPerkuliahan =
          Post(2, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');

      expect(postAkademik.category, PostCategory.AKADEMIK);
      expect(postPerkuliahan.category, PostCategory.PERKULIAHAN);
    });

    test('Membuat Post dengan link download', () {
      final postAkademik = Post(
          1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten',
          link: 'link-download');

      expect(postAkademik.link, 'link-download');
    });

    test('Membuat Equality Checker pada Post', () {
      final postAkademik =
        Post(1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');

      final post2 =
        Post(1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');

      final post3 =
        Post(1, '22 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');

      expect(postAkademik == post2, true);
      expect(postAkademik == post3, false);
    });

    test('Membuat Post dari Map', () {
      Map<String, dynamic> map = {
        'id': 1,
        'date': '20 Juni 2019',
        'category': PostCategory.AKADEMIK.index,
        'title': 'Judul',
        'content': 'Konten',
        'link': null,
      };
      final postFromMap = Post.fromMap(map);
      final postAkademik =
        Post(1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');

      expect(postFromMap == postAkademik, true);
    });

    test('Membuat Post dalam Bentuk Map', () {
      final postAkademik =
        Post(1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');
      Map<String, dynamic> map = {
        'id': 1,
        'date': '20 Juni 2019',
        'category': PostCategory.AKADEMIK.index,
        'title': 'Judul',
        'content': 'Konten',
        'link': null,
      };
      final postToMap = postAkademik.toMap();

      expect(map['id'], postToMap['id']);
      expect(map['date'], postToMap['date']);
      expect(map['category'], postToMap['category']);
      expect(map['title'], postToMap['title']);
      expect(map['content'], postToMap['content']);
      expect(map['link'], postToMap['link']);
    });

    test('Object Post toString()', () {
      final postAkademik =
          Post(1, '20 Juni 2019', PostCategory.AKADEMIK, 'Judul', 'Konten');
      final postPerkuliahan =
          Post(2, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      final postAkademikToString =
          "id: 1\ndate: 20 Juni 2019\ncategory: Akademik\ntitle: Judul\ncontent: Konten\nlink: null";
      final postPerkuliahanToString =
          "id: 2\ndate: 20 Juni 2019\ncategory: Perkuliahan\ntitle: Judul\ncontent: Konten\nlink: null";

      expect(postAkademik.toString(), postAkademikToString);
      expect(postPerkuliahan.toString(), postPerkuliahanToString);
    });
  });
}
