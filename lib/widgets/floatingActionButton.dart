import 'package:flutter/material.dart';
import '../Blocs/Todo/note_event.dart';
import '../StaticValues.dart';
import '../models/Note.dart';
import '../screens/tosodPage.dart';
import '../screens/noteMainPage.dart';
import '../screens/noteViewPage.dart';

class FloatingMenu extends StatelessWidget {
  const FloatingMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            width: 160,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), color: Color(
                0xff006c8d),),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Image.asset("assets/images/category.png"),
                  ),
                  onTap: (){
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>Homepage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 11,top: 8,bottom: 8),
                    child: Image.asset("assets/images/todologo.png"),
                  ),
                ),

              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteViewPage(Note(imageList: {}),null)));
              StaticValues.currentEvent= TumNotlarEvent(categoryId: -1);
              //globalCategoryId =25;
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(
                  0xffe4f0f6),),

              child: Icon(Icons.add, color: Color(0xff006c8d),size: 35,),
            ),
          ),

        ],
      ),
    );
  }
}
