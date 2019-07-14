import 'package:infids/dao/post_dao.dart';
import 'package:infids/model/post.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';

void main() {

  final testDbPath = 'infids_test.db';
  var postDao;

  group('Akses Tabel Post', () {
    setUp(() async {
      final path = (await getDatabasesPath()) + '/' + testDbPath;
      postDao = PostDao.forTest(path);
      await postDao.open();
    });

    tearDownAll(() async {
      final path = await getDatabasesPath();
      await deleteDatabase(path + '/' + testDbPath);
    });
    
    test('Menambahkan dan Mengambil Post dari Database', () async {
      var posts = await postDao.getAllPost();
      expect(posts.length, 0);

      var post = Post(1, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      await postDao.insert(post);

      posts = await postDao.getAllPost();
      expect(posts.length, 1);
      expect(posts[0] == post, true);
      await postDao.close();
    });

    test('Menambahkan dan Mengambil Banyak Post dari Database', () async {
      var posts = await postDao.getAllPost();
      expect(posts.length, 1);

      var post1 = Post(
          2, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      var post2 = Post(
          3, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      var post3 = Post(
          4, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      var post4 = Post(
          5, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      var post5 = Post(
          6, '20 Juni 2019', PostCategory.PERKULIAHAN, 'Judul', 'Konten');
      var postsInsert = [post1, post2, post3, post4, post5];
      await postDao.insertAll(postsInsert);

      posts = await postDao.getAllPost();
      expect(posts.length, 6);
      expect(posts[1] == post1, true);
      expect(posts[2] == post2, true);
      expect(posts[3] == post3, true);
      expect(posts[4] == post4, true);
      expect(posts[5] == post5, true);
      await postDao.close();
    });
  });
}