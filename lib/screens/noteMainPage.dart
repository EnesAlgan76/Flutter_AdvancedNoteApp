import 'dart:ui';
import 'package:e_note_app/screens/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_state.dart';
import '../NoteDatabaseHelper.dart';
import '../SharedPreferencesOperations.dart';
import '../StaticValues.dart';
import '../widgets/floatingActionButton.dart';
import '../widgets/navigationDrawer.dart';
import '../widgets/searchBarWidget.dart';
import 'noteViewPage.dart';



GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
List<int> selectedItems = [];
bool multiSelectionMode = false;
double fontSize=16;



class NoteMainPage extends StatefulWidget {
  @override
  _NoteMainPageState createState() => _NoteMainPageState();
}


class _NoteMainPageState extends State<NoteMainPage> {
  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  bool isPasswordCorrect =false;



  @override
  Widget build(BuildContext context) {
    noteDatabaseHelper.getFontsize();
    final noteBloc= BlocProvider.of<NoteBloc>(context);
    noteBloc.add(StaticValues.currentEvent);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavigationDrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  BlocBuilder<NoteBloc, NoteState>(
                  builder: (context, state) {
                    if(state is NoteListState){
                      if(state.noteList.isNotEmpty){
                        return GridTile(
                          child: MasonryGridView.builder(
                            padding: EdgeInsets.only(top: 80),
                            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemCount: state.noteList.length,
                            itemBuilder: (context, index) {
                              var content = state.noteList[index].noteContent!.length>150 ? state.noteList[index].noteContent!.substring(0,150): state.noteList[index].noteContent ;

                              return GestureDetector(
                                onTap: () async {
                                  fontSize = await noteDatabaseHelper.getFontsize();
                                if(multiSelectionMode ==true){
                                  var noteId=state.noteList[index].noteId!;
                                  StaticValues.selectedItemList.add(noteId);
                                  doMultiSelection(noteId);
                                  setState(() {
                                    if(selectedItems.length ==0){multiSelectionMode = false;}
                                  });
                                }else{
                                  getxController.getxGetRemainders(state.noteList[index].noteId!);
                                  if(state.noteList[index].isLocked ==1){
                                    screenLock(
                                        title: Text("get_enterpasscode".tr),
                                        context: context,
                                        correctString: await getPassword(),
                                        didUnlocked: (){
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NoteViewPage(state.noteList[index],index)));
                                          selectedCategoryId = state.noteList[index].noteCategoryId;
                                        }
                                    );

                                  }else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteViewPage(state.noteList[index],index)));
                                    selectedCategoryId = state.noteList[index].noteCategoryId;
                                  }
                                }
                                },

                                onLongPress: (){
                                  var noteId=state.noteList[index].noteId!;
                                  doMultiSelection(noteId);

                                  multiSelectionMode =true;
                                  setState(() {});
                                },

                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 75,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: selectedItems.contains(state.noteList[index].noteId) ? Border.all(color: Colors.blueAccent,width: 2):null,
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(int.parse(state.noteList[index].noteColor ??"0xffd1c4e9")),),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${state.noteList[index].noteTitle}",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Quicksand',),),

                                          state.noteList[index].isLocked ==1?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.all(30),
                                                child: Icon(Icons.lock, color: Color(0x4a000000),size: 40,),
                                              ),
                                            ],
                                          ):
                                          Text("${content}",style: TextStyle(fontSize: 15, color: Colors.black54, fontFamily: 'Quicksand',), ),

                                          if(state.noteList[index].isFavorite==1)
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
                        return Padding(
                          padding: const EdgeInsets.only(top:80),
                          child: Container(
                            child:Image.asset("assets/images/leaff.png",color: Colors.white.withOpacity(0.1),colorBlendMode: BlendMode.modulate) ,
                            margin: EdgeInsets.all(80),
                          ),
                        );
                      }

                    }else{
                      return Text("");
                    }
                    },
                  ),
                  SearchBarWidget(),

                ],
              ),
            ),
          ],
        ),
      ),




      floatingActionButton: FloatingMenu()
    );
  }




  void doMultiSelection(int noteId){
    if (selectedItems.contains(noteId)){
      selectedItems.remove(noteId);

    }else{
      selectedItems.add(noteId);
    }
  }
}













