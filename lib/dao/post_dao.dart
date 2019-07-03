import 'package:infids/model/post.dart';
import 'package:sqflite/sqflite.dart';

class PostDao {
  static const DATABASE_NAME = 'infids.db';
  static const TABLE_NAME = 'posts';
  static const COLUMN_ID = 'id';
  static const COLUMN_DATE = 'date';
  static const COLUMN_CATEGORY = 'category';
  static const COLUMN_TITLE = 'title';
  static const COLUMN_CONTENT = 'content';
  static const COLUMN_LINK = 'link';

  Database _database;
  String _path;

  PostDao.forTest(String path) : this._path = path;

  Future setup() async {
    _database = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      db.execute("CREATE TABLE IF NOT EXISTS ${TABLE_NAME} "
          "(${COLUMN_ID} INTEGER PRIMARY KEY, "
          "${COLUMN_DATE} TEXT, "
          "${COLUMN_CATEGORY} INTEGER, "
          "${COLUMN_TITLE} TEXT, "
          "${COLUMN_CONTENT} TEXT, "
          "${COLUMN_LINK} TEXT );");
    });
  }

  Future<List<Post>> getAllPost() async {
    List<Map> maps = await _database.query(TABLE_NAME);
    List<Post> posts = [];
    if (maps.length > 0) {
      for (Map map in maps) {
        Post post = Post.fromMap(map,
            columnId: COLUMN_ID,
            columnDate: COLUMN_DATE,
            columnCategory: COLUMN_CATEGORY,
            columnTitle: COLUMN_TITLE,
            columnContent: COLUMN_CONTENT,
            columnLink: COLUMN_LINK);
        posts.add(post);
      }
    }
    return posts;
  }

  Future<Post> insert(Post post) async {
    await _database.insert(TABLE_NAME, post.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return post;
  }

  Future close() async {
    _database.close();
  }
}
