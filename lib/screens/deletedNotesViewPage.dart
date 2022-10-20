
import 'package:flutter/material.dart';
import '../SharedPreferencesOperations.dart';
import '../StaticValues.dart';
import '../models/Note.dart';
import '../widgets/imageGridView.dart';
import 'noteViewPage.dart';


class DeletedNotesViewPage extends StatefulWidget {
  Note note;
  int? indexOfNote;
  DeletedNotesViewPage(this.note, this.indexOfNote);

  @override
  _DeletedNotesViewPageState createState() => _DeletedNotesViewPageState();
}


class _DeletedNotesViewPageState extends State<DeletedNotesViewPage> {
  @override
  void initState() {
    getPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(height: 60, color: const Color(0xfcdcdcd),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed:() async {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xff006c8d),)
                      ),
                      SizedBox(width: 5,),
                      Text("${getCategoryName(widget.note.noteCategoryId??-1)}",overflow: TextOverflow.fade,softWrap: false, maxLines: 1,style: TextStyle(fontSize: 18),),
                      Spacer(),



                    ],
                  ),
                ), //Back Icon

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(
                        0xfff3f3f3)),
                    margin: EdgeInsets.only(left: 10,right: 10),
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children:  [
                        Text(
                          "${widget.note.noteTitle}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20,),

                        if(widget.indexOfNote != null)
                          ImageGridWidget(indexOfNote: widget.indexOfNote!),
                        if(widget.indexOfNote == null)//
                          ImageGridWidget(),//

                        SizedBox(height: 20,),

                        Text(
                          "${widget.note.noteContent}",
                          style: const TextStyle(fontSize: 16,),
                        ),// IMAGES

                        SizedBox(height: 200,)
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),

      ),
    );
  }
}





