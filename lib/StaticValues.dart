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

}

