
import '../../models/Category.dart';
import '../../models/Note.dart';
import '../../models/task2.dart';


abstract class NoteState {

}

class TaskInitial extends NoteState {}

class TaskListState2 extends NoteState{
  final List<Task2> taskList2;

  TaskListState2(this.taskList2);
}

class NoteInitial extends NoteState {}

class NoteListState extends NoteState{
  final List<Note> noteList;
  List<Category> categories;

  NoteListState(this.noteList, this.categories);
}

