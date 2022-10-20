import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'StaticValues.dart';
import 'models/task.dart';
import 'models/task2.dart';
import 'models/todo.dart';


class DatabaseHelper{

  // Future<Database> database() async{
  //   return openDatabase(
  //     join(await getDatabasesPath(), "todo.db"),
  //
  //     onCreate: (db, version) async {
  //       await db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, color TEXT)',);
  //       await db.execute('CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)',);
  //       },
  //
  //     version: 1,
  //   );
  // }



  static final String veritabaniAdi="task.sqlite";

  Future<Database> todoDatabese() async{
    String veritabaniYolu = join(await getDatabasesPath(),veritabaniAdi);

    if(await databaseExists(veritabaniYolu)){
      print("zaten var kopyalamaya geek yok");
    }else{
      ByteData data =await rootBundle.load("databases/$veritabaniAdi");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes,flush: true);
      print("veritabani kopyalandı");
    }

    return openDatabase(veritabaniYolu);
  }





  Future<int> insertTask(Task taskModel) async{
    int task_id = 0;
    Database _db = await todoDatabese();
    await _db.insert("tasks", taskModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace ).then((value){
      task_id = value;
    });

    return task_id;
  }

  Future<int> insertTodo(Todo todoModel) async{
    int todo_id = 0;
    Database _db = await todoDatabese();
    await _db.insert("todo", todoModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace ).then((value){
      todo_id =value;
    });
    return todo_id;
  }

  Future<void> updateTaskTitle(int id, String title) async{
    Database _db = await todoDatabese();
    await _db.rawQuery("UPDATE tasks SET title = '$title' WHERE id ='$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async{
    Database _db = await todoDatabese();
    await _db.rawQuery("UPDATE tasks SET description = '$description' WHERE id ='$id'");
  }

  Future<void> updateTodoisDone(int id, int isDone) async{
    Database _db = await todoDatabese();
    await _db.rawQuery("UPDATE todo SET isDone = '$isDone' WHERE id ='$id'");
  }

  Future<void> deleteTask(int id) async{
    Database _db = await todoDatabese();
    await _db.rawQuery("DELETE FROM tasks WHERE id ='$id'");
    await _db.rawQuery("DELETE FROM todo WHERE taskId ='$id'");
  }

  Future<void> deleteTodo(int? id) async{
    Database _db = await todoDatabese();
    await _db.rawQuery("DELETE FROM todo WHERE id ='$id'");
  }



  Future<List<Task2>> getTasks2() async{
    Database _db = await todoDatabese();
    List<Map<String,dynamic>> taskMap= await _db.query("tasks");
    List<Task2> task2List =[];

    for (var task in taskMap){
      List<Todo> todoList =[];
      List<Map<String,dynamic>> todoMap= await _db.rawQuery("SELECT * FROM todo WHERE taskId = ${task["id"]}");
        for (var todo in todoMap){
          Todo todoObj = Todo(id: todo["id"],taskId: todo["id"], title: todo["title"], isDone: todo["isDone"] );
          todoList.add(todoObj);
        }
      Task2 task2 = Task2(id: task["id"],title: task["title"],description: task["description"],color: task["color"],todoList: todoList );
      task2List.add(task2);
    }
    int lastTaskId = taskMap.length==0 ? 0: taskMap.last["id"];

    StaticValues.lastTaskId = lastTaskId;

    return task2List;
  }





}