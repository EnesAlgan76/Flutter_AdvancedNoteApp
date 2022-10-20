class Task{
  final int? id;
  final String? title;
  final String? description;
  final String? color;

  Task({this.id, this.title, this.description, this.color});


  Map<String, dynamic> toMap(){
    return
      {"id":id, "title":title, "description": description , "color": color};
  }



}