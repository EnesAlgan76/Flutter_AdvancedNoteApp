import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../Blocs/Todo/note_event.dart';
import '../Blocs/Todo/note_state.dart';
import '../Blocs/Todo/task_bloc.dart';
import '../DatabaseHelper.dart';
import '../StaticValues.dart';
import '../models/task.dart';
import '../models/task2.dart';
import '../models/todo.dart';
import '../widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  final titleEditTextController = TextEditingController();
  final decEditTextController = TextEditingController();
  bool isExpanded =false;
  bool addingNewTask =false;
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;

  @override
  void initState()  {

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final taskBloc= BlocProvider.of<TaskBloc>(context);
    double scw = MediaQuery. of(context). size. width;

    titleEditTextController.text ="";
    decEditTextController.text ="";

    taskBloc.add(TumTasklarEvent());

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          //color: Color(0xfff6f6f6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_rounded, size: 35,color: Color(0xff006c8d),)
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              "get_todoTitle".tr,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color:Get.isDarkMode? Colors.white:Colors.black, fontSize: 22, fontFamily: 'Quicksand',)),
                        ),
                      ),

                      //Spacer(),

                      ElevatedButton(
                        onPressed: () {
                          addingNewTask = true;
                          setState(() {

                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.add, size: 30, color: Colors.white,),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Color(0xff006c8d),
                      ),
                      ),
                    ],
                  ),

                  Visibility(
                    visible: addingNewTask,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all() ,borderRadius: BorderRadius.all(Radius.circular(24) ),),
                      padding: EdgeInsets.all(15),
                      margin:  EdgeInsets.only(top:15),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:   [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height:25,
                                    width: scw*0.55,
                                    child: TextField(
                                      onSubmitted: (value)async{
                                        _descriptionFocus.requestFocus();

                                      },
                                      focusNode: _titleFocus,
                                      decoration: InputDecoration(
                                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20)) ,
                                          contentPadding: const EdgeInsets.only(right: 10,left: 10),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                          hintText: "get_title".tr,
                                          hintStyle: TextStyle(fontSize: 15, color: Color(0xff828282))
                                      ),
                                      controller: titleEditTextController,

                                    )
                                ),
                              ),//TASK TEXTFİELD
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height:25,
                                    width: scw*0.55,
                                    child:  TextField(
                                      focusNode: _descriptionFocus,
                                      onSubmitted: (value)async{
                                        int lastTaskId2= StaticValues.lastTaskId;

                                        Task taskModel = Task(id : null, title: titleEditTextController.text ,description: value, color: StaticValues.colorList[lastTaskId2%6]);
                                        await dbHelper.insertTask(taskModel);

                                      },
                                      controller: decEditTextController,
                                      decoration: InputDecoration(
                                          focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20)) ,
                                          contentPadding: const EdgeInsets.only(right: 10,left: 10),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                          hintText: "get_description".tr,
                                          hintStyle: TextStyle(fontSize: 15, color: Color(0xff828282))
                                      ),
                                    )
                                ),
                              ), ////DESCRPTİON TEXTFİELD

                            ],
                          ),
                          SizedBox(width: scw*0.05,),
                          IconButton(
                            onPressed: () async{
                              addingNewTask = false;
                              String titleEditTextValue = titleEditTextController.text;
                              String descEditTextValue = decEditTextController.text;
                              print(titleEditTextValue);

                              if(titleEditTextValue !=""){
                                int lastTaskId2= StaticValues.lastTaskId;
                                Task taskModel = Task(id : null, title: titleEditTextValue,description: descEditTextValue, color: StaticValues.colorList[lastTaskId2%6]);

                                await dbHelper.insertTask(taskModel);
                                taskBloc.add(TumTasklarEvent());
                              }

                              setState(() {

                              });

                            },
                            icon: Icon(Icons.done_outline_rounded),
                          ),// EDİT İCON
                        ],
                      ),
                    ),
                  ),

                  BlocBuilder(
                    bloc: taskBloc ,
                    builder: (context, NoteState state)  {
                      if(state is TaskListState2){
                        if(state.taskList2.isNotEmpty){
                          return Expanded(
                              child: ListView.builder(
                                  itemCount: state.taskList2.length,
                                  itemBuilder: (context, i) {
                                    return TaskCardWidget(task2: state.taskList2[i]);
                                  })
                          );
                        }else{
                          return Expanded(
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:80),
                                  child: Container(
                                    child:Image.asset("assets/images/leaff.png",color: Colors.white.withOpacity(0.1),colorBlendMode: BlendMode.modulate) ,
                                    margin: EdgeInsets.all(80),
                                  ),
                                ),
                              ]
                            ),
                          );
                        }
                      }else{
                        return Container();
                      }
                    },
                  )
                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
}
