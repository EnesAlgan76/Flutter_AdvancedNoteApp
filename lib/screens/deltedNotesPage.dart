import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Blocs/Todo/note_bloc.dart';
import '../NoteDatabaseHelper.dart';
import '../SharedPreferencesOperations.dart';
import '../StaticValues.dart';
import '../models/Note.dart';
import 'deletedNotesViewPage.dart';
import 'noteViewPage.dart';

class DeletedNotesPage extends StatefulWidget {

  @override
  _DeletedNotesPageState createState() => _DeletedNotesPageState();
}

class _DeletedNotesPageState extends State<DeletedNotesPage> {

  List<int> selectedItems = [];
  bool multiSelectionMode = false;

  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  bool isPasswordCorrect =false;


  Future<List<Note>> getDeletedNotes()async{
    List<Note> list =await noteDatabaseHelper.getDeletedNotes();
    for(Note i in list){
      idList.add(i.noteId!);
    }
    return list;
  }

  List<int> idList=[];

  @override
  Widget build(BuildContext context) {
    final noteBloc= BlocProvider.of<NoteBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                      onPressed:(){
                        Navigator.pop(context);
                        noteBloc.add(StaticValues.currentEvent);
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded, color: Color(
                          0xff006c8d),)),
                ),
                
                GestureDetector(
                  onTap: ()async{
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                        title: Text("get_delpermanently".tr),
                        content: Text("get_delpermanently?".tr),
                        actions: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: DialogButton(
                                  onPressed: () async {
                                    await noteDatabaseHelper.deleteNotes(idList);
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  color: const Color(0xff8d0000),
                                  child: Text("get_delete".tr, style: const TextStyle(fontSize: 20, color: Colors.white),),
                                ),
                              ),
                              Expanded(
                                child: DialogButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  color: const Color(0xff006c8d),
                                  child: Text("get_cancel".tr, style:const TextStyle(fontSize: 20, color: Colors.white)),
                                ),
                              ),

                            ],
                          ),

                        ],
                      );
                    },
                    );


                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xff720000))),
                      child: Row(
                        children: [
                          Text("get_emptytrash".tr, style: TextStyle(color:Color(0xff720000) ),),

                        ],
                      )
                  ),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: getDeletedNotes(),
                  builder: ((context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData) {
                      return GridTile(
                        child: MasonryGridView.builder(
                          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          mainAxisSpacing: 4,
                          itemCount: snapshot.data.length,
                          crossAxisSpacing: 4,
                          itemBuilder: (context, index) {
                            var content = snapshot.data[index].noteContent!.length >
                                150 ? snapshot.data[index].noteContent!.substring(
                                0, 150) : snapshot.data[index].noteContent;
                            return GestureDetector(
                              onTap: () async {
                                if (snapshot.data[index].isLocked == 1) {
                                  screenLock(
                                      title: Text("get_enterpasscode".tr),
                                      context: context,
                                      correctString: await getPassword(),
                                      didUnlocked: () {
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => DeletedNotesViewPage(snapshot.data[index], index)));
                                        selectedCategoryId =snapshot.data[index].noteCategoryId;
                                      }
                                  );
                                } else {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => DeletedNotesViewPage( snapshot.data[index], index)));
                                  selectedCategoryId =snapshot.data[index].noteCategoryId;
                                }
                              },


                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 75,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: selectedItems.contains(snapshot.data[index].noteId) ? Border.all( color: Colors.blueAccent, width: 2) : null,
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(int.parse(snapshot.data[index].noteColor ??"0xffd1c4e9")),),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${snapshot.data[index].noteTitle}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        snapshot.data[index].isLocked == 1 ?
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(30),
                                              child: Icon(
                                                Icons.lock, color: Color(0x4a000000),
                                                size: 40,),
                                            ),
                                          ],
                                        ) :
                                        Text("${content}",
                                          style: TextStyle(fontSize: 17),),

                                        if(snapshot.data[index].isFavorite == 1)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.star, color: Color(
                                                  0xffffe500),),
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      return Container();
                    }
                  })
              ),
            ),
          ],
        )
      ),
    );
  }
}
