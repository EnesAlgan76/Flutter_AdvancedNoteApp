import 'package:flutter_bloc/flutter_bloc.dart';
import '../../DatabaseHelper.dart';
import '../../NoteDatabaseHelper.dart';
import '../../models/Note.dart';
import '../../models/task2.dart';
import 'note_event.dart';
import 'note_state.dart';

class TaskBloc extends Bloc<NoteEvent, NoteState> {
  DatabaseHelper dbHelper= DatabaseHelper();
  NoteDatabaseHelper noteDbHelper = NoteDatabaseHelper();

  TaskBloc() : super(TaskInitial()) {

    on<TumTasklarEvent>((event, emit) async {
      print("bloc state is task");
      final List<Task2> tasks = await dbHelper.getTasks2();
      final List<Task2> reversedList = tasks.reversed.toList();
      emit(TaskListState2(reversedList));
    });


  }
}