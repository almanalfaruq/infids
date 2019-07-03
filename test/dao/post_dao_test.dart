import 'package:infids/model/post.dart';
import 'package:infids/dao/post_dao.dart';
import 'package:test/test.dart';
import 'package:sqflite/sqflite.dart';

@Skip('Tidak bisa dijalankan apabila aplikasi tidak berjalan pada perangkat')
void main() {

  final testDbPath = 'infids_test.db';
  var postDao;

  group('Akses Tabel Post', () {
    setUp(() async {
      final path = (await getDatabasesPath()) + '/' + testDbPath;
      postDao = PostDao.forTest(path);
      await postDao.setup();
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
  });
}