import 'dart:io';
import 'dart:typed_data';
import 'package:e_note_app/GetxControllerClass.dart';
import 'package:e_note_app/models/Remainder.dart';
import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'StaticValues.dart';
import 'models/Category.dart';
import 'models/Note.dart';

class NoteDatabaseHelper {


  Future<Database> noteDatabase() async {
    print("not veritabanı kopyalandı");
    String databasePath = join(await getDatabasesPath(), "note2.sqlite");
    if (await databaseExists(databasePath)) {} else {
      ByteData data = await rootBundle.load("databases/note2.sqlite");
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(databasePath);
  }


  Future<List<Note>> getNotes(
      {required int categoryId, String? searchWord}) async {
    Database database = await noteDatabase();

    List<Map<String, dynamic>> noteMapList = [];

    if (categoryId == -1) {
      noteMapList = (searchWord == null) ?
      await database.query("notes")
          :
      await database.rawQuery(
          "SELECT*FROM notes WHERE noteContent like'%$searchWord%' OR noteTitle like'%$searchWord%'");
    } else {
      if (searchWord == null) {
        noteMapList = await database.rawQuery(
            "SELECT * FROM notes WHERE noteCategoryId = ${categoryId}");
      } else {
        noteMapList = await database.rawQuery(
            "SELECT*FROM notes WHERE noteCategoryId = ${categoryId} AND (noteContent like'%$searchWord%' OR noteTitle like'%$searchWord%')");
      }
    }
    List<Note> noteList = [];
    for (var notMap in noteMapList) {
      List<Map<String, dynamic>> imageMapList = await database.rawQuery("SELECT * FROM images WHERE noteId = ${notMap["noteId"]}");
      List<Map<String, dynamic>> todoMapList = await database.rawQuery("SELECT * FROM noteTodo WHERE noteId = ${notMap["noteId"]}");

      Map<int, String> imageMap = {};
      for (var imgMap in imageMapList) {
        imageMap[imgMap["imageId"]] = imgMap["path"];
      }
      Map<String, int> todoMap = {};
      for (var tdMap in todoMapList) {
        todoMap[tdMap["title"]] = tdMap["isDone"];
      }
      noteList.add(Note.fromMap(notMap, imageMap,todoMap));
    }

    int lastNotId = noteMapList.length == 0 ? 0 : noteMapList.last["noteId"];

    StaticValues.lastNoteId = lastNotId;
    noteList = noteList.where((element) => element.isDeleted!=1).toList();
    return noteList;
  }



  Future<double> getFontsize() async {
    Database _db = await noteDatabase();
    var x=await _db.rawQuery("SELECT * FROM settings WHERE whichSetting ='fontSize'");
    int value = x[0]["setting"] as int;
    print("font sizeeee::  ${value}");
    return value.toDouble();
  }


  Future<List<Note>> getFavoriteNotes() async {
    List<Note> noteList = await getNotes(categoryId: -1);
    noteList = noteList.where((element) => element.isFavorite==1).toList();
    return noteList;
  }

  Future<List<Note>> getDeletedNotes() async {
    Database database = await noteDatabase();
    List<Map<String, dynamic>> noteMapList = [];
    noteMapList =
    await database.rawQuery("SELECT * FROM notes WHERE isDeleted ='${1}' ");
    List<Note> noteList = [];
    for (var notMap in noteMapList) {
      List<Map<String, dynamic>> imageMapList = await database.rawQuery("SELECT * FROM images WHERE noteId = ${notMap["noteId"]}");
      List<Map<String, dynamic>> todoMapList = await database.rawQuery("SELECT * FROM noteTodo WHERE noteId = ${notMap["noteId"]}");
      Map<int, String> imageMap = {};
      for (var imgMap in imageMapList) {
        imageMap[imgMap["imageId"]] = imgMap["path"];
      }
      Map<String, int> todoMap = {};
      for (var tdMap in todoMapList) {
        todoMap[tdMap["title"]] = tdMap["isDone"];
      }
      noteList.add(Note.fromMap(notMap, imageMap,todoMap));
    }
    return noteList;
  }

  Future<List<Note>> getLockedNotes() async {
    Database database = await noteDatabase();
    List<Map<String, dynamic>> noteMapList = [];
    noteMapList =
    await database.rawQuery("SELECT * FROM notes WHERE isLocked ='${1}' ");
    List<Note> noteList = [];
    for (var notMap in noteMapList) {
      List<Map<String, dynamic>> imageMapList = await database.rawQuery("SELECT * FROM images WHERE noteId = ${notMap["noteId"]}");
      List<Map<String, dynamic>> todoMapList = await database.rawQuery("SELECT * FROM noteTodo WHERE noteId = ${notMap["noteId"]}");
      Map<int, String> imageMap = {};
      for (var imgMap in imageMapList) {
        imageMap[imgMap["imageId"]] = imgMap["path"];
      }
      Map<String, int> todoMap = {};
      for (var tdMap in todoMapList) {
        todoMap[tdMap["title"]] = tdMap["isDone"];
      }
      noteList.add(Note.fromMap(notMap, imageMap,todoMap));
    }
    return noteList;
  }


  Future<List<Category>> getCategories() async {
    Database database = await noteDatabase();
    List<Map<String, dynamic>> categoryMapList = await database.query("categories");

    List<Category> categoryList = [];
    for (var categoryMap in categoryMapList) {
      categoryList.add(Category(categoryId: categoryMap["categoryId"],
          categoryName: categoryMap["categoryName"]));
      StaticValues.categoryMap[categoryMap["categoryId"]] =
      categoryMap["categoryName"];
    }

    return categoryList;
  }


  Future<void> updateNoteTitle(int id, String title) async {
    print("updateNoteTitle");
    Database database = await noteDatabase();
    await database.rawQuery(
        "UPDATE notes SET noteTitle = '$title' WHERE noteId ='$id'");
  }

  Future<void> updateNoteContent(int id, String content) async {
    printWarning("update Note Content");
    Database database = await noteDatabase();
    await database.update("notes", {'noteContent': content},where: 'noteId = ?',
      whereArgs: [id], );
  }

  Future<void> updateNoteCategory(int id, int categoryId) async {
    print("updateNoteCategory");
    Database database = await noteDatabase();
    await database.rawQuery("UPDATE notes SET noteCategoryId = '$categoryId' WHERE noteId ='$id'");
  }

  Future<void> updateIsFavorite(int id, int value) async {
    Database database = await noteDatabase();
    await database.rawQuery(
        "UPDATE notes SET isFavorite = '$value' WHERE noteId ='$id'");
  }

  Future<void> updateIsLocked(int id, int locked) async {
    Database database = await noteDatabase();
    locked == 1 ?
    await database.rawQuery(
        "UPDATE notes SET isLocked = '1' WHERE noteId ='$id'")
        :
    await database.rawQuery(
        "UPDATE notes SET isLocked = '0' WHERE noteId ='$id'");
  }


  Future<void> insertCategory(String categoryName) async {
    Database _db = await noteDatabase();
    await _db.insert(
        "categories", {"categoryId": null, "categoryName": categoryName},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertRemainder(Remainder remainder) async {
    Database _db = await noteDatabase();
    int id=0;
    await _db.insert("remainders", remainder.toMap(),conflictAlgorithm: ConflictAlgorithm.replace).then((value)=>id=value);
    print("New remainder Id : ${id}");
    return id;
  }

  Future<List<Remainder>> getRemainders(int noteId) async {
    Database database = await noteDatabase();
    List<Map<String, dynamic>> remainderMapList = await database.rawQuery("SELECT * FROM remainders WHERE noteId = '$noteId'");

    List<Remainder> remainderList = [];
    for (var remainderyMap in remainderMapList) {
      remainderList.add(Remainder.fromMap(remainderyMap));
    }
    return remainderList;
  }

  Future<void> deleteRemainder(int id) async {
    Database _db = await noteDatabase();
    await _db.rawQuery("DELETE FROM remainders WHERE id ='$id'");
  }


  Future<int> insertNote(Note note) async {
    Database _db = await noteDatabase();
    int noteId = -1;
    await _db.insert(
        "notes", note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      noteId = value;
    });
    return noteId;
  }



  Future<void> insertImage(int noteId, List<String> pathList) async {
    Database _db = await noteDatabase();
    for (var path in pathList) {
      print(path);
      await _db.insert(
          "images", {"imageId": null, "noteId": noteId, "path": path},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertTodo(int noteId, Map<dynamic, dynamic> todoMap) async {
    Database _db = await noteDatabase();
    todoMap.forEach((key, value)async {
      await _db.insert("noteTodo", {"noteId": noteId, "title": key, "isDone": value},conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
  Future<void> deleteTodo({required String todoTitle, required noteId}) async {
    Database _db = await noteDatabase();
    await _db.rawQuery("DELETE FROM noteTodo WHERE title ='$todoTitle' AND noteId ='$noteId'");
  }
  Future<void> updateTodo({required int state, required noteId, required String todoTitle }) async{
    Database _db = await noteDatabase();
    await _db.rawQuery("UPDATE noteTodo SET isDone = '$state' WHERE title ='$todoTitle' AND noteId ='$noteId'");
  }


  Future<void> setFontsize({required double fontSize}) async {
    Database _db = await noteDatabase();
    await _db.rawQuery("UPDATE settings SET setting = '${fontSize.toInt()}' WHERE whichSetting = 'fontSize'");
  }


  Future<void> deleteImages({required int imageId}) async {
    Database _db = await noteDatabase();
    await _db.rawQuery("DELETE FROM images WHERE imageId ='$imageId'");
  }

  Future<void> deleteCategory({required int categoryId}) async {
    Database _db = await noteDatabase();
    await _db.rawQuery("DELETE FROM categories WHERE categoryId ='$categoryId'");
    await _db.rawQuery("UPDATE notes SET noteCategoryId = ${1} WHERE noteCategoryId = '$categoryId'");
  }


  Future<void> deleteNotes(List<int> idList) async {
    Database _db = await noteDatabase();
    for (var id in idList) {
      await _db.rawQuery("DELETE FROM notes WHERE noteId ='$id'");
    }
  }

  Future<void> moveNotesToTrash(List<int> idList) async {
    Database _db = await noteDatabase();
    for (var id in idList) {
      await _db.rawQuery(
          "UPDATE notes SET isDeleted ='${1}' WHERE noteId ='$id'");
    }
  }

  Future<void> recoverNotefromTrash(int noteId) async {
    Database _db = await noteDatabase();
    await _db.rawQuery("UPDATE notes SET isDeleted ='${0}' WHERE noteId ='$noteId'");
  }



  Future<void> removeLockfromAllNotes() async {
    Database database = await noteDatabase();
    await database.rawQuery(
        "UPDATE notes SET isLocked = '0' WHERE isLocked = '1'");
  }




}
