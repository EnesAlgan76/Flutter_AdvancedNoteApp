import 'package:e_note_app/Blocs/Todo/note_bloc.dart';
import 'package:e_note_app/Blocs/Todo/note_state.dart';
import 'package:e_note_app/StaticValues.dart';
import 'package:e_note_app/models/todo.dart';
import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:e_note_app/screens/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../NoteDatabaseHelper.dart';
import '../widgets.dart';

class noteTodoWidget extends StatelessWidget {
  int? indexOfNote;
  noteTodoWidget({this.indexOfNote});


  NoteDatabaseHelper notedbHelper = NoteDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final noteBloc= BlocProvider.of<NoteBloc>(context);

    if(indexOfNote ==null){
      return Obx(()=>AnimatedContainer(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Get.isDarkMode? Color(0xff383838):Color(0xffe8e8e8),),
          duration:Duration(seconds: 1) ,
          width: double.infinity,
          height: (getxController.todoMap.length).toDouble()*50>270 ? 270: (getxController.todoMap.length).toDouble()*50,
          child: ListView(
            children: [
              for(var i in getxController.todoMap.entries)
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5,),
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: Color(0xff006c8d), //0xffd1c4e9  0xff00626f
                            value: i.value ==1 ? true: false,
                            shape: CircleBorder(),
                            onChanged: (bool? value) async {
                              getxController.todoMap[i.key]=(value==true)?1:0;
                            }
                        ),

                        Expanded(
                          child: Text(i.key ,
                            style: TextStyle(
                              color: i.value ==1 ?Color(0xff006c8d) :Color(0xff6c909c),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),

                        GestureDetector(
                          onTap: (){
                            getxController.todoMap.remove(i.key);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.close, size: 20,color: Colors.black54),
                          ),
                        )

                      ],
                    )
                ),
              //sil button
            ],),

        ),
      );


    }else{
      return BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if(state is NoteListState){
            Map<String, int> todoList = state.noteList[indexOfNote!].todoList??{};
            return AnimatedContainer(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Get.isDarkMode? Color(0xff383838):Color(0xffe8e8e8),),
              margin: todoList.length >0? EdgeInsets.symmetric(vertical: 5):null,
              duration:Duration(seconds: 1) ,
              width: double.infinity,
              height: (todoList.length).toDouble()*50>270 ? 270: (todoList.length).toDouble()*50,
              child: ListView(
                      children: [
                      for(var i in todoList.entries)
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8,),
                          child: Row(
                            children: [
                              Checkbox(
                                  activeColor: Color(0xff006c8d), //0xffd1c4e9  0xff00626f
                                  value: i.value ==1 ? true: false,
                                  shape: CircleBorder(),
                                  onChanged: (bool? value) async {
                                    await notedbHelper.updateTodo(state: value==true?1:0, noteId:state.noteList[indexOfNote!].noteId , todoTitle: i.key);
                                    noteBloc.add(StaticValues.currentEvent);

                                  }
                              ),

                              Expanded(
                                child: Text(i.key ,
                                  style: TextStyle(
                                    color: i.value ==1 ?Color(0xff006c8d) :Color(0xff6c909c),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),),
                              ),

                              GestureDetector(
                                  onTap: (){
                                    notedbHelper.deleteTodo(todoTitle: i.key, noteId:state.noteList[indexOfNote!].noteId );
                                    noteBloc.add(StaticValues.currentEvent);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(Icons.close, size: 20, color: Colors.black54,),
                                  ),
                              )

                            ],
                          )
                      ),
                      //sil button
                    ],),

            );
          }else{
            return Container();
          }
        },
      );
    }

  }
}
