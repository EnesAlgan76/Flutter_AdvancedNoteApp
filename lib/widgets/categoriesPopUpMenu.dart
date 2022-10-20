import 'package:flutter/material.dart';

import '../NoteDatabaseHelper.dart';
import '../models/Category.dart';
import '../screens/noteViewPage.dart';

class CategoriesPopUpMenu extends StatefulWidget {
  @override
  _CategoriesPopUpMenuState createState() => _CategoriesPopUpMenuState();
}


class _CategoriesPopUpMenuState extends State<CategoriesPopUpMenu> {

  NoteDatabaseHelper notedbHelper = NoteDatabaseHelper();
  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 35,
      decoration: BoxDecoration(
        borderRadius: isExpanded? BorderRadius.vertical(top: Radius.circular(20.0)): BorderRadius.all(Radius.circular(20)),
        color: Color(0xffe5eff6),),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 125, 
            alignment: Alignment.center,
            child: Text("${getCategoryName(selectedCategoryId!)}",
                overflow: TextOverflow.fade,softWrap: false, maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 17)
            ),),

          FutureBuilder(
              future: notedbHelper.getCategories(),
              builder: ((context, AsyncSnapshot<List<Category>> snapshot) {
                if(snapshot.hasData){
                  return  PopupMenuButton<int>(
                    constraints:BoxConstraints(maxHeight: 323),

                    onCanceled: (){
                      setState(() {
                        isExpanded ==false;
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff006c8d),size: 30,),
                    offset: Offset(-123.5, 35),
                    color: Color(0xffe5eff6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    itemBuilder: (context) => [
                      for(int i=0; i < snapshot.data!.length; i++)
                        PopupMenuItem(
                          value: i,
                          child: Container(
                              alignment: Alignment.center,
                              width: 131,
                              child: Text("${snapshot.data![i].categoryName}", style: TextStyle(fontSize:15, fontWeight: FontWeight.w700, color: Color(0xff006c8d)),)),
                        ),
                    ],

                    onSelected: (value) {
                      for(int i=0; i < snapshot.data!.length; i++)
                        if(value==i){
                          setState(() {
                            selectedCategoryId = snapshot.data![i].categoryId;
                          });
                        }
                    },
                  );
                }else{
                  return Container();
                }
              })
          ),
        ],
      ),);



  }
}
