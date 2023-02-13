import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/news.dart';

class NewsProviderSqflite {
  Database? _database;

  NewsProviderSqflite._();

  static final NewsProviderSqflite instance = NewsProviderSqflite._();

  Future<Database> get getDB async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'app.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  _createDB(Database db, int version) async {
    db.execute('''create table $tableNews (
      $columnStoryId interger primary key,
      $columnSummary text not null,
      $columnTitle text not null,
      $columnImageUrl text not null,
      $columnModifiedAt text not null
    )''');
  }

  Future<void> clearAll() async {
    var db = await getDB;
    await db.delete(tableNews);
  }

  Future<News?> getNews(int storyId) async {
    try {
      var db = await getDB;
      List<Map<String, Object?>> newsGroup = await db
          .query(tableNews, where: '$storyId = ?', whereArgs: [storyId]);
      if (newsGroup.isNotEmpty) {
        return News.fromAPIMap(newsGroup.first);
      } else {
        return null;
      }
    } catch (e) {
      return null;
      rethrow;
    }
  }

  Future<List<News>> getAllNews() async {
    try {
      var db = await getDB;
      List<Map<String, dynamic>> results = await db.query(tableNews);
      List<News> newsGroup =
          results.map((e) => News.fromInternalDbMap(e)).toList();
      return newsGroup;
    } catch (e) {
      return List.empty();
    }
  }

  Future<int> insert(News news) async {
    try {
      var db = await getDB;
      await db.insert(tableNews, news.toMap());
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> insertAll(List<News> newsGroup) async {
    for (var news in newsGroup) {
      insert(news);
    }
    try {
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> delete(News news) async {
    try {
      var db = await getDB;

      await db.delete(tableNews,
          where: '$columnStoryId = ?', whereArgs: [news.storyId]);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> update(News news) async {
    try {
      var db = await getDB;

      db.update(tableNews, news.toMap(),
          where: '$columnStoryId = ?', whereArgs: [news.storyId]);
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
