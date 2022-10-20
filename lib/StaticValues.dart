import 'dart:ui';

import 'package:get/get.dart';

import 'Blocs/Todo/note_event.dart';

class StaticValues{



  static var lastTaskId=-1;
  static var lastNoteId=-1;
  static var lastRemainderId =-1;
  static List<String> colorList= ["0xff80deea","0xffffe082","0xffa5d6a7","0xffb0bec5","0xffd1c4e9","0xffffab91"];

  static List<int> selectedItemList =[];
  static Map<int,dynamic> categoryMap = {};
  static int currentCategoryId=-1;
  static String currentCategoryName= "get_allnotes".tr;
  static List<String> imageStringList=[];
  static int lockstate=0;
  static NoteEvent currentEvent= TumNotlarEvent(categoryId: StaticValues.currentCategoryId);


  // 0xff006c8d
//Get.snackbar("get_remaindercreated".tr,"", backgroundColor: Color(0x88006c8d),colorText: Colors.white, duration: Duration(milliseconds: 1500));


  // await showDialog(
  // context: context,
  // builder: (BuildContext context) {
  // return AlertDialog(
  // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
  // title: Text("get_delconfirmation".tr),
  // content: Text("get_deletenotes?".tr),
  // actions: <Widget>[
  // Row(
  // children: [
  // Expanded(
  // child: DialogButton(
  // onPressed: () async {
  // await notedbHelper.moveNotesToTrash([widget.noteId!]);
  // noteBloc.add(StaticValues.currentEvent);
  // Get.back();
  // Get.back();
  // },
  // child: Text("get_delete".tr, style: TextStyle(
  // fontSize: 20, color: Colors.white),),
  // color: Color(0xff8d0000),
  // ),
  // ),
  // Expanded(
  // child: DialogButton(
  // onPressed: () => Navigator.of(context).pop(false),
  // child: Text("get_cancel".tr, style: TextStyle(
  // fontSize: 20, color: Colors.white)),
  // color: Color(0xff006c8d),
  // ),
  // ),
  //
  // ],
  // ),
  //
  // ],
  // );
  // },
  // );
}

