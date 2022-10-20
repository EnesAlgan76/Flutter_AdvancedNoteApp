import 'package:e_note_app/localNotificationService.dart';
import 'package:e_note_app/screens/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../NoteDatabaseHelper.dart';

class remaindersWidget extends StatelessWidget {
  int? noteId;
  remaindersWidget({this.noteId});

  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  LocalNotificationService service = LocalNotificationService();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if(noteId !=null){
        if(getxController.remainders.isNotEmpty){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("get_remainders".tr),
                Container(
                  height: 60,
                  child:ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for(var remainder in getxController.remainders)
                        Container(margin: EdgeInsets.all(8),padding:EdgeInsets.only(left: 10,right: 5) ,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                            color: DateTime.parse(remainder.date.toString()).isBefore(DateTime.now())?Color(
                                0x4affaa00):Color(0xffffaa00),
                          ),
                          child: Row(
                            children: [
                              DateTime.parse(remainder.date.toString()).isBefore(DateTime.now())?Icon(Icons.alarm_off_rounded):Icon(Icons.alarm_rounded),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${remainder.date.toString().substring(0,11).replaceAll("-", "/")}",style: TextStyle(fontSize: 12),),
                                  Text("${remainder.date.toString().substring(11,16)}"),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        noteDatabaseHelper.deleteRemainder(remainder.id);
                                        getxController.getxGetRemainders(noteId!);
                                        service.localNotificationService.cancel(remainder.id);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Icon(Icons.close_rounded,size: 15,color: Color(
                                            0xffff5100),),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }else{
          return Container();
        }
      }else{
        if(getxController.newNoteRemainders.isNotEmpty){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("get_remainders".tr),
                Container(
                  height: 60,
                  child:ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for(var date in getxController.newNoteRemainders)
                        Container(margin: EdgeInsets.all(8),padding:EdgeInsets.only(left: 10,right: 5) ,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                            color: DateTime.parse(date).isBefore(DateTime.now())?Color(
                                0x4affaa00):Color(0xffffaa00),
                          ),
                          child: Row(
                            children: [
                              DateTime.parse(date).isBefore(DateTime.now())?Icon(Icons.alarm_off_rounded):Icon(Icons.alarm_rounded),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${date.substring(0,11).replaceAll("-", "/")}",style: TextStyle(fontSize: 12),),
                                  Text("${date.substring(11,16)}"),
                                ],
                              ),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        getxController.newNoteRemainders.remove(date);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Icon(Icons.close_rounded,size: 15,color: Color(
                                            0xffff5100),),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }else{
          return Container();
        }
      }

    }

    );
  }
}


