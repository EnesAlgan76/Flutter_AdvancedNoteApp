

class Note{
  int? noteId;
  String? noteTitle;
  String? noteContent;
  int? noteCategoryId;
  String? noteColor;
  int? isLocked;
  int? isFavorite;
  int? isDeleted;
  Map<int,String>? imageList;
  Map<String,int>? todoList;

  Note({
    this.noteId,
    this.noteTitle,
    this.noteContent,
    this.noteCategoryId,
    this.noteColor,
    this.isLocked=0,
    this.isFavorite=0,
    this.isDeleted=0,
    this.imageList,
    this.todoList,
  });

  Map<String, dynamic> toMap() {
    return {
      'noteId': this.noteId,
      'noteTitle': this.noteTitle,
      'noteContent': this.noteContent,
      'noteCategoryId': this.noteCategoryId,
      'noteColor': this.noteColor,
      'isLocked': this.isLocked,
      'isFavorite': this.isFavorite,
      'isDeleted': this.isDeleted,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map, Map<int,String> imageMap, Map<String,int> todoList) {
    return Note(
      noteId: map['noteId'],
      noteTitle: map['noteTitle'],
      noteContent: map['noteContent'],
      noteCategoryId: map['noteCategoryId'] ,
      noteColor: map['noteColor'] ,
      isLocked: map['isLocked'] ,
      isFavorite: map['isFavorite'] ,
      isDeleted: map['isDeleted'] ,
      imageList: imageMap,
      todoList: todoList,
    );
  }
}