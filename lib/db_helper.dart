import 'dart:async';
import 'dart:io';

import 'package:flutter_crud/product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final _databaseName = 'mydb.db';
  static final _databaseVersion = 1;

  static final _tableProducts = 'prodcuts';
  static String path = '';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database _database = _database;

  Future get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    //Local storage path/databasename.db
    String path = join(documentDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  FutureOr _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableProducts (id INTEGER PRIMARY KEY autoIncrement, name TEXT, price TEXT, quantity INTEGER)');
  }

  static Future getFieldData() async {
    return getDatabasesPath().then((value) {
      return path = value;
    });
  }

  Future insertProduct(Product product) async {
    Database db = await instance.database;

    return await db.insert(_databaseName, Product.toMap(product),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Product>> getProductList() async {
    Database db = await instance.database;

    List<Map> maps = await db.query(_tableProducts);
    print(maps);
    return Product.fromMapList(maps);
  }
}
