import 'package:flutter_bloc/flutter_bloc.dart';
import '../../NoteDatabaseHelper.dart';
import '../../models/Category.dart';
import '../../models/Note.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {

  NoteDatabaseHelper noteDbHelper = NoteDatabaseHelper();

  NoteBloc() : super(NoteInitial()) {

    on<TumNotlarEvent>((event, emit) async {
      final List<Note> notes = await noteDbHelper.getNotes(categoryId: event.categoryId, searchWord: event.searchWord);
      final List<Note> reversedList = notes.reversed.toList();
      final List<Category> categories = await noteDbHelper.getCategories();
      emit(NoteListState(reversedList,categories));
    });


    on<FavoritedNotesEvent>((event, emit) async {
      final List<Note> notes = await noteDbHelper.getFavoriteNotes();
      final List<Category> categories = await noteDbHelper.getCategories();
      emit(NoteListState(notes,categories));
    });

    on<LockedNotesEvent>((event, emit) async {
      final List<Note> notes = await noteDbHelper.getLockedNotes();
      final List<Category> categories = await noteDbHelper.getCategories();
      emit(NoteListState(notes,categories));
    });

    on<DeletedNotesEvent>((event, emit) async {
      final List<Note> notes = await noteDbHelper.getDeletedNotes();
      final List<Category> categories = await noteDbHelper.getCategories();
      emit(NoteListState(notes,categories));
    });

  }
}