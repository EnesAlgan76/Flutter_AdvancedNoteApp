class Remainder{
  int? id;
  int noteId;
  String date;

  Remainder({this.id, required this.noteId, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id' : this.id,
      'noteId': this.noteId,
      'date': this.date,
    };
  }

  factory Remainder.fromMap(Map<String, dynamic> map) {
    return Remainder(
      id: map['id'],
      noteId: map['noteId'],
      date: map['date'],
    );
  }
}


