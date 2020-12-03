import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class Entity {
  String createTable();
  String getTableName();
  Map<String, dynamic> toMap();
}

const CONFIGINSERT ="INSERT INTO config (property,value) VALUES (?,?) ON CONFLICT(property) DO UPDATE SET value=?";

typedef MapFunction<T> = T Function(Map<String,dynamic> record);

class DatabaseService {
  final Database _database;
  DatabaseService(this._database);

  static DatabaseService databaseService;

  static Future<DatabaseService> getInstance() async {
    if(databaseService == null) {
      final path = join(await getDatabasesPath(), 'stc_database.db');
      log("db file path is $path");
      final db = await openDatabase(
// 设置数据库的路径。注意：使用 `path` 包中的 `join` 方法是
// 确保在多平台上路径都正确的最佳实践。
       path,
// 当数据库第一次被创建的时候，创建一个数据表，用以存储狗狗们的数据。
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE IF NOT EXISTS config(property VARCHAR(32) PRIMARY KEY, value VARCHAR(1024))",
          );
          db.execute(
            "CREATE TABLE IF NOT EXISTS seeds(seed VARCHAR(128) PRIMARY KEY, address_count INT,is_default BOOLEAN)",
          );
          return db.execute(
            "CREATE TABLE IF NOT EXISTS network_urls(network VARCHAR(32) PRIMARY KEY, url VARCHAR(1024))",
          );
        },
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
// 设置版本。它将执行 onCreate 方法，同时提供数据库升级和降级的路径。
        version: 1,
      );
      databaseService= DatabaseService(db);
    }

    return databaseService;
  }

  Future<void> insert(Entity entity) async {
    await _database.insert(
      entity.getTableName(),
      entity.toMap(),
    );
  }

  Future<void> insertRaw(String sql, [List<dynamic> arguments]) async {
    await _database.rawInsert(
      sql,
      arguments,
    );
  }

  Future<List<Map<String,dynamic>>> queryRaw(String sql, [List<dynamic> arguments]) async {
    return await _database.rawQuery(
      sql,
      arguments,
    );
  }

  Future<List<T>> queryAll<T extends Entity>(String tableName,MapFunction<T> mapFunc) async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName);
    return List.generate(maps.length, (i) {
      return mapFunc(maps[i]);
    });
  }

  Future<void> delete(String tableName,String where,List<dynamic> args) async {
    await _database.delete(tableName,where:where,whereArgs: args);
  }
}