
import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Blocs/Todo/note_bloc.dart';
import '../NoteDatabaseHelper.dart';
import '../SharedPreferencesOperations.dart';
import '../StaticValues.dart';
import '../screens/settingPage.dart';

class EnesPopUpMenu extends StatefulWidget {
  int? lockState;
  int? noteId;

  EnesPopUpMenu({this.lockState,this.noteId});

  @override
  _EnesPopUpMenuState createState() => _EnesPopUpMenuState();
}

class _EnesPopUpMenuState extends State<EnesPopUpMenu> {
  NoteDatabaseHelper notedbHelper = NoteDatabaseHelper();
  final passwordEditTextControllerAdd = TextEditingController();

  @override
  void initState() {
     StaticValues.lockstate= widget.lockState??0;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final noteBloc= BlocProvider.of<NoteBloc>(context);
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Get.isDarkMode?Colors.white:Colors.black),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child:
          StaticValues.lockstate!=1?
          Row(
            children:  [
              Icon( Icons.lock_outline_rounded, color: Color(0xff3e0000)),
              SizedBox(
                width: 10,
              ),
              Text("get_locknote".tr,style: TextStyle(color: Colors.black),)
            ],
          )
              :
          Row(
            children:  [
              Icon( Icons.lock_open_rounded, color: Color(
                  0xff036300)),
              SizedBox(
                width: 10,
              ),
              Text("get_removelock".tr,style: TextStyle(color: Colors.black))
            ],
          ),



        ),
        PopupMenuItem(
          value: 2,
          // row with two children
          child: Row(
            children:  [
              const Icon(Icons.delete_outline_rounded, color: Color(
                  0xff930000)),
              SizedBox(
                width: 10,
              ),
              Text("get_delete".tr,style: TextStyle(color: Colors.black))
            ],
          ),
        ),
      ],
      offset: Offset(0, 50),
      color: Colors.white,
      elevation: 2,
      onSelected: (value) async {
        if(await getPassword() != ""){
          setState(() {
            StaticValues.lockstate= StaticValues.lockstate==1?0:1;
          });
        }
        if(value==1){
          if(await getPassword() ==""){
            Alert(
                context: context,
                desc: "Use only numeric character",
                //title: "LOGIN",
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: passwordEditTextControllerAdd,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'password',
                      ),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: ()async {
                      var sharedPreferences = await SharedPreferences.getInstance();
                      if(passwordEditTextControllerAdd.text.length == 4){
                        await sharedPreferences.setString("password", passwordEditTextControllerAdd.text);
                        Get.snackbar("Password added succesfully", "",backgroundColor: Color(0x74006c8d), colorText: Colors.white,);
                        Navigator.pop(context);
                        getxController.hasPassword.value =true;
                        setState(() {
                          StaticValues.lockstate= StaticValues.lockstate==1?0:1;
                        });
                      }
                    },
                    child: Text(
                      "ADD",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Color(0xff006c8d),
                  )
                ]).show();
          }
        }
        if(value==2){
          if(widget.noteId != null) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("get_delconfirmation".tr),
                  content: Text("get_deletenotes?".tr),
                  actions: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: DialogButton(
                            onPressed: () async {
                              await notedbHelper.moveNotesToTrash([widget.noteId!]);
                              noteBloc.add(StaticValues.currentEvent);
                              Get.back();
                              Get.back();
                            },
                            child: Text("get_delete".tr, style: TextStyle(
                                fontSize: 20, color: Colors.white),),
                            color: Color(0xff8d0000),
                          ),
                        ),
                        Expanded(
                          child: DialogButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("get_cancel".tr, style: TextStyle(
                                fontSize: 20, color: Colors.white)),
                            color: Color(0xff006c8d),
                          ),
                        ),

                      ],
                    ),

                  ],
                );
              },
            );
          }else{
            Get.snackbar("get_nonotetodelete".tr, "",
                backgroundColor: Color(0x8a8d0000),
                colorText: Colors.white,
                duration: Duration(milliseconds: 1500));
          }
        }
      },
    );
  }


}
