import 'package:get/get.dart';
import 'package:knovator_task/models/postModel.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class DBHelper {
  static Database? _db;
  static final int _versoin = 1;
  static final String _table = "postTable";

  Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "${_table}.db";
      _db = await openDatabase(
        _path,
        version: _versoin,
        onCreate: (db, version) {
          // print("Create a new one");
          db
              .execute(
            "CREATE TABLE $_table("
            "id INTEGER PRIMARY KEY, "
            "userId STRING,title STRING,body STRING,isRead INTEGER,seconds INTEGER)",
          )
              .then((value) {
            print("DB Created");
          }).catchError((error) {
            print("Error: $error");
          });
        },
      );

      // print(_dbAttendance);
    } catch (e) {
      // print(e);
    }
  }

  Future<int> insert(PostModel? task) async {
    return await _db?.insert(_table, task!.toJson()).then((value) {
          print("Inserted");
          return value;
        }).catchError((error) {
          print("Error: $error");
        }) ??
        1;
  }

  Future<List<PostModel>?> getPostData() async {
    List<PostModel>? list;
    await _db?.query(_table).then((value) {
      if (value.isNotEmpty) {
        list = value.map((e) {
          return PostModel.fromJson(e);
        }).toList();
      }
    }).catchError((error) {
      print("Error: $error");
    });
    return list;
  }

  updateRead({required int id, required RxInt status}) async {
    return await _db!.rawUpdate('''
        UPDATE $_table
        SET isRead = ?
        WHERE id =?
      ''', [status.value, id]).then((value) {
      // print(value);
    });
  }

  updateSeconds({required int id, required RxInt seconds}) async {
    return await _db!.rawUpdate('''
        UPDATE $_table
        SET seconds = ?
        WHERE id =?
      ''', [seconds.value, id]).then((value) {
      // print(value);
    });
  }
}
