import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tracker_app/app/home/models/item_model.dart';
import 'package:tracker_app/app/home/resources/repository.dart';

class NewsDbProvider implements Source, Cache {
  NewsDbProvider() {
    init();
  }

  Database db;

  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) async {
      await newDb.execute('''
            CREATE TABLE Items (
            id INTEGER PRIMARY KEY,
            deleted INTEGER,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            dead INTEGER,
            parent INTEGER,
            kids BLOB,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
            )
        ''');
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    return db.insert(
      "Items",
      item.toMapForDb(),
    );
  }
}

final newsDbProvider = NewsDbProvider();
