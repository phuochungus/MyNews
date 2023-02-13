import 'package:sqflite/sqflite.dart';
import '../models/news.dart';

class NewsProviderSqflite {
  late Database _db;

  Future open(String path) async {
    _db = await openDatabase(path, version: 1, onCreate: createDB);
  }

  createDB(Database db, int version) async {
    db.execute('''create table $tableNews (
      $columnStoryId interger primary key,
      $columnSummary text not null,
      $columnTitle text not null,
      $columnImageUrl text not null,
      $columnModifiedAt text not null
    )''');
  }

  Future<News?> getNews(int storyId) async {
    try {
      List<Map<String, Object?>> newsGroup = await _db
          .query(tableNews, where: '$storyId = ?', whereArgs: [storyId]);
      if (newsGroup.length > 0) {
        return News.fromJson(newsGroup.first);
      }
    } catch (e) {
      return null;
    }
  }

  Future<int> insert(News news) async {
    try {
      _db.insert(tableNews, news.toMap());
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> delete(News news) async {
    try {
      await _db.delete(tableNews,
          where: '$columnStoryId = ?', whereArgs: [news.storyId]);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> update(News news) async {
    try {
      _db.update(tableNews, news.toMap(),
          where: '$columnStoryId = ?', whereArgs: [news.storyId]);
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
