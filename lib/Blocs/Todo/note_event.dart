
abstract class NoteEvent {}


class TumTasklarEvent extends NoteEvent{
}

class TumNotlarEvent extends NoteEvent{
  int categoryId;
  String? searchWord;

  TumNotlarEvent({required this.categoryId, this.searchWord});
}

class FavoritedNotesEvent extends NoteEvent{
}

class DeletedNotesEvent extends NoteEvent{
}

class LockedNotesEvent extends NoteEvent{
}



