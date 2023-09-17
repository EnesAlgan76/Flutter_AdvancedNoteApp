import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'Blocs/Todo/note_bloc.dart';
import 'Blocs/Todo/task_bloc.dart';
import 'DatabaseHelper.dart';
import 'StaticValues.dart';
import 'models/task.dart';
import 'models/task2.dart';
import 'models/todo.dart';
import '../Blocs/Todo/note_event.dart';
import '../Blocs/Todo/note_state.dart';



DatabaseHelper dbHelper = DatabaseHelper();

class TaskCardWidget extends StatefulWidget {
  late final Task2 task2;

  TaskCardWidget({required this.task2});



  @override
  _TaskCardWidgetState createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  bool isEditing = false;
  bool isExpanded =false;
  bool isRounded=true;
  final titleEditTextController = TextEditingController();
  final decEditTextController = TextEditingController();

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  @override
  void initState() {
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double scw = MediaQuery. of(context). size. width;
    List todoList = widget.task2.todoList ??[];
    String lightColor = "${widget.task2.color!.substring(0, 2)}4C${widget.task2.color!.substring(4)}";
    final taskBloc= BlocProvider.of<TaskBloc>(context);

    titleEditTextController.text=widget.task2.title ??"";
    decEditTextController.text = widget.task2.description ??"";

    int colorCode =0xffa6ffff;
    if(widget.task2.color !=null){
      colorCode =int.parse(widget.task2.color!);
    }


    return Column(
      children: [
        GestureDetector(
          onTap: (){
            setState(() {

            });

          },
          child: Container(
            width: scw*0.9,
            padding: EdgeInsets.only(left: 15, right: 15,top: 15),
            margin:  EdgeInsets.only(top:15),
            decoration: BoxDecoration(
                borderRadius:isRounded ? BorderRadius.circular(20): BorderRadius.vertical(top: Radius.circular(20)),
                color: Color(colorCode)
            ),
            child:
              Column(
                children: [
                  if(isEditing==false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width:scw*0.6,
                              child: Text(
                                widget.task2.title?? "get_unnamedtask".tr,
                                style: const TextStyle(
                                    color: Color(0xFF005368),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quicksand"
                                ),
                              ),
                            ),  // TİTLE
                            Container(
                              width: scw*0.6,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.task2.description ??"get_nodescription".tr,
                                  style: const TextStyle(
                                    color: Color(0xff8e8e8e),
                                    fontSize: 15,
                                  ),),
                              ),
                            ), // DESCRİTPİON
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8,bottom: 10),
                                  child: Icon(Icons.edit,size: 20,color: Color(0xFF005368),),
                                ),
                              onTap: (){
                                print(widget.task2.id);
                                isEditing = true;
                                setState(() {

                                });
                              },
                            ),

                            Visibility(
                              visible: widget.task2.id!= null,
                              child: GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8,top: 10),
                                  child: Icon(Icons.delete,size: 20,color: Color(0xFF005368),),
                                ),
                                onTap: ()async{
                                  if (widget.task2.id !=-1){
                                    await dbHelper.deleteTask(widget.task2.id!);
                                    taskBloc.add(TumTasklarEvent());
                                  }
                                },
                              ),
                            ),// DELETE İCON
                          ],
                        ),
                      ],
                    ),//İCONS

                  if(isEditing==true)

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:   [
                            Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height:30,
                                  width: scw*0.55,
                                  child: TextField(
                                    focusNode: _titleFocus,
                                    decoration:  InputDecoration(contentPadding: const EdgeInsets.only(right: 10,left: 10),
                                        focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20)) ,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                        hintText: "get_title".tr,
                                        hintStyle: TextStyle(fontSize: 15, color: Color(0xff828282))
                                    ),
                                    controller: titleEditTextController,
                                    onSubmitted: (value) async{
                                      if(value !=""){
                                        if(widget.task2.id ==null){
                                          int lastTaskId2= StaticValues.lastTaskId;
                                          Task taskModel = Task(id : null, title: value, color: StaticValues.colorList[lastTaskId2%6]);

                                          await dbHelper.insertTask(taskModel);

                                        }else{
                                          await dbHelper.updateTaskTitle(widget.task2.id!, value);
                                        }
                                      }
                                      _descriptionFocus.requestFocus();
                                    },

                                  )
                              ),
                            ),//TASK TEXTFİELD
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height:30,
                                  width: scw*0.55,
                                  child:  TextField(
                                    onSubmitted: (value) async{
                                      await dbHelper.updateTaskDescription(widget.task2.id!, value);
                                    },
                                    controller: decEditTextController,
                                    focusNode: _descriptionFocus,
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
                        IconButton(
                          onPressed: () async{
                            String titleEditTextValue = titleEditTextController.text;
                            String descEditTextValue = decEditTextController.text;

                            if(titleEditTextValue !=""){
                              if(widget.task2.id ==null){
                                int lastTaskId2= StaticValues.lastTaskId;
                                Task taskModel = Task(id : null, title: titleEditTextValue, color: StaticValues.colorList[lastTaskId2%6]);

                                await dbHelper.insertTask(taskModel);
                                taskBloc.add(TumTasklarEvent());
                                isEditing=false;

                              }else{
                                await dbHelper.updateTaskTitle(widget.task2.id!, titleEditTextValue);
                                await dbHelper.updateTaskDescription(widget.task2.id!, descEditTextValue);
                                taskBloc.add(TumTasklarEvent());
                                isEditing=false;

                              }

                            }else{
                              isEditing=false;
                            }
                            taskBloc.add(TumTasklarEvent());
                          },
                          icon: Icon(Icons.done_outline_rounded),
                        ),// EDİT İCON
                      ],
                    ),

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isExpanded =!isExpanded;
                        isRounded = !isRounded;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(15)), color:Color(
                          0xF000000) ),
                      width: scw*0.5,
                      height: 20,
                      child: isExpanded ? Icon(Icons.keyboard_arrow_up_rounded):Icon(Icons.keyboard_arrow_down_rounded) ,
                        
                      ),
                  ),
                ],
              )





          ),//Kartlar
        ),


        BlocBuilder(
            bloc: taskBloc ,
            builder: (context, state) {
              if(state is TaskListState2 ){
                return Visibility(
                    visible: isExpanded ,
                    child: AnimatedContainer(
                        color: Color(int.parse(lightColor)),
                        duration:Duration(seconds: 1) ,
                        width: double.infinity,
                        height: (todoList.length).toDouble()*50+50>275 ? 275: (todoList.length).toDouble()*50+50,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                              child: SizedBox(
                                height: 25,
                                child: TextField(
                                  controller: TextEditingController(text: ""),
                                  focusNode: _todoFocus,
                                  onSubmitted: (value){
                                    _todoFocus.requestFocus();
                                    dbHelper.insertTodo(Todo(taskId: widget.task2.id, title: value,isDone: 0 ));
                                    taskBloc.add(TumTasklarEvent());
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(20)) ,
                                    contentPadding: const EdgeInsets.only(right: 10,left: 10),
                                    hintText: "get_entertodoıtem".tr,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),//TextField Widget

                            Flexible(
                              child: ListView.builder(
                                  itemCount: todoList.length,
                                  itemBuilder: (context, i) {
                                    return Row(children: [
                                      Expanded(
                                        child: TodoWidget(todo: todoList[i]),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          dbHelper.deleteTodo(todoList[i].id);
                                          taskBloc.add(TumTasklarEvent());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Icon(Icons.close, size: 20,color: Colors.black54),
                                        ),
                                      ),
                                      //sil button

                                    ],);
                                  }),
                            ),
                          ],
                        )
                    )
                );
              }else{
                return Container();
              }
            })

      ],
    );
  }
}







class TodoWidget extends StatelessWidget {
  final Todo todo;
  TodoWidget({required this.todo});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    final taskBloc= BlocProvider.of<TaskBloc>(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1.5),
        child: Row(
          children: [
            BlocBuilder(
              bloc:taskBloc ,
              builder: (context, NoteState state){
                if(state is TaskListState2){
                  return Checkbox(
                      activeColor: Color(0xff006c8d), //0xffd1c4e9  0xff00626f
                      value: todo.isDone ==1 ? true: false,
                      shape: CircleBorder(),
                      onChanged: (bool? value) async {
                        await _dbHelper.updateTodoisDone(todo.id!, value == false ? 0:1);
                        taskBloc.add(TumTasklarEvent());
                      }
                  );
                }else{
                  return Container();
                }
              },

            ),

            Expanded(
              child: Text(todo.title ?? "get_unnamedtodo".tr,
                style: TextStyle(
                  color: todo.isDone ==1 ?Get.isDarkMode?Colors.white:Colors.black87 :Get.isDarkMode?Colors.white60:Colors.black45,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "QuickSand"
                ),),
            ),





          ],
        )
    );
  }
}






