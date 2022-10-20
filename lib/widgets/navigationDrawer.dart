
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_event.dart';
import '../Blocs/Todo/note_state.dart';
import '../NoteDatabaseHelper.dart';
import '../StaticValues.dart';
import '../screens/deltedNotesPage.dart';
import '../screens/noteMainPage.dart';
import '../screens/noteViewPage.dart';
import '../screens/settingPage.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  final addCategoryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final noteBloc= BlocProvider.of<NoteBloc>(context);

    return Drawer(
      child: Material(
        child: BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state is NoteListState) {
                return Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        stops: [0.1,0.7],
                        colors: [
                          Color(0xff00708b),
                          Color(0xffffffff),
                        ],
                      )
                  ),
                  child: ListView(
                    children: [
                      SizedBox(height: 30,),
                      SizedBox(
                          height: 150,
                          child: Image.asset("assets/images/appLogo2.png")),

                      ListTile(
                        leading: Icon(Icons.notes_rounded,color: Colors.white,),
                        title: Text("get_allnotes".tr,style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',)),
                        onTap: (){
                          StaticValues.currentCategoryId = -1;
                          StaticValues.currentCategoryName = "get_allnotes".tr;
                          noteBloc.add(TumNotlarEvent(categoryId: StaticValues.currentCategoryId));
                          StaticValues.currentEvent =TumNotlarEvent(categoryId: StaticValues.currentCategoryId);
                          scaffoldKey.currentState!.closeDrawer();
                        },
                      ),

                      ListTile(
                        onTap: (){
                          StaticValues.currentCategoryName = "get_favorites".tr;
                          StaticValues.currentEvent =FavoritedNotesEvent();
                          noteBloc.add(FavoritedNotesEvent());
                          scaffoldKey.currentState!.closeDrawer();
                        },
                          leading: Icon(Icons.star_border_rounded,color: Color(0xff494949),),
                          title: Text("get_favorites".tr, style: TextStyle(color: Color(
                              0xff535353), fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Quicksand',))),

                      ListTile(
                        onTap: (){
                          StaticValues.currentCategoryName = "get_lockednotes".tr;
                          StaticValues.currentEvent =LockedNotesEvent();
                          noteBloc.add(LockedNotesEvent());
                          scaffoldKey.currentState!.closeDrawer();
                        },
                          leading: Icon(Icons.lock_outline_rounded,color: Color(0xff494949),),
                          title: Text("get_lockednotes".tr, style: TextStyle(color: Color(0xff494949), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',))),

                      ListTile(
                          onTap: () {
                            noteBloc.add(DeletedNotesEvent());
                            Navigator.push(context, MaterialPageRoute(builder: (conext) =>DeletedNotesPage()));
                            scaffoldKey.currentState!.closeDrawer();
                          },
                          leading: Icon(Icons.delete_outline_rounded,color: Color(0xff494949),),
                          title: Text("get_trash".tr, style: TextStyle(color: Color(0xff494949), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Quicksand',))),


                      Container(height: 1, color: Color(0x59000000),),
                       Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("get_categories".tr,style: TextStyle(color: Color(0x94000000), fontSize: 13)),
                            Obx(()=>IconButton(
                                  onPressed: (){
                                    getxController.isCategoryEditing.value = !getxController.isCategoryEditing.value;
                                  },
                                  icon: getxController.isCategoryEditing.value==false? Icon(Icons.edit,size: 18,):Icon(Icons.close_rounded,size: 18,)
                              ),
                            )
                          ],
                        ),
                      ),

                      Obx((){
                        if(getxController.isCategoryEditing==true) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20,bottom: 5),
                            child: SizedBox(
                              height:40 ,
                              child: Text("get_deleteselected".tr, style: TextStyle(color: Color(
                                  0xff760000), fontSize: 16, fontFamily: 'Quicksand',),),),
                          );
                        }else{
                          return Container();

                        }
                      }),


                      for(var category in state.categories)
                        GestureDetector(
                            onTap: (){
                              StaticValues.currentCategoryId = category.categoryId;
                              StaticValues.currentCategoryName = getCategoryName(category.categoryId);
                              noteBloc.add(TumNotlarEvent(categoryId: StaticValues.currentCategoryId));
                              StaticValues.currentEvent =TumNotlarEvent(categoryId: StaticValues.currentCategoryId);
                              scaffoldKey.currentState!.closeDrawer();
                            },
                            child: Obx((){
                              if(getxController.isCategoryEditing.value ==true){
                                return Dismissible(
                                    confirmDismiss: (DismissDirection direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  Text("get_delconfirmation".tr),
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                            content: Text("get_deletecategory?".tr),
                                            actions: <Widget>[
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: DialogButton(
                                                        onPressed: ()async {
                                                          Navigator.of(context).pop(true);
                                                          StaticValues.currentCategoryId = -1;
                                                          await noteDatabaseHelper.deleteCategory(categoryId: category.categoryId);
                                                          StaticValues.currentCategoryName= "get_allnotes".tr;
                                                          getxController.isCategoryEditing.value =false;
                                                          StaticValues.currentEvent= TumNotlarEvent(categoryId: -1);
                                                          noteBloc.add(TumNotlarEvent(categoryId: -1));
                                                          selectedCategoryId=-1;
                                                        },
                                                        child:  Text("get_delete".tr, style: TextStyle(fontSize: 20, color: Colors.white),),
                                                        color: Color(0xff8d0000),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: DialogButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child:  Text("get_cancel".tr,style: TextStyle(fontSize: 20, color: Colors.white)),
                                                      color: Color(0xff006c8d),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                            ],
                                          );
                                        },
                                      );
                                    },

                                  key: Key(""),
                                  child: ListTile(
                                    leading : SizedBox(height: 20, child: Image.asset("assets/images/arrow.png")),
                                    title: Text(category.categoryName!, style:  TextStyle(color: Color(0xff006687), fontWeight: FontWeight.bold, fontSize: 15,fontFamily: 'Quicksand',),),

                                  ),
                                );
                              }else{
                                return ListTile(
                                  leading : SizedBox(height: 20, child: Image.asset("assets/images/arrow.png")),
                                  title: Text(category.categoryName!, style:  TextStyle(color: Color(0xff006687), fontWeight: FontWeight.bold, fontSize: 15),),

                                );
                              }
                            }

                            ),
                        ),

                      ListTile(
                        onTap: (){
                          Alert(
                              context: context,
                              desc: "get_entercategoryname".tr,
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: addCategoryTextController,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.add),
                                      hintText: "get_categoryname".tr,
                                    ),
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    if(addCategoryTextController.text !=""){
                                      noteDatabaseHelper.insertCategory(addCategoryTextController.text);
                                      addCategoryTextController.text ="";
                                      noteBloc.add(TumNotlarEvent(categoryId: -1));
                                      Get.back();
                                    }
                                  },
                                  child: Text(
                                    "get_add".tr,
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  color: Color(0xff006c8d),
                                )
                              ]).show();
                        },
                        leading : Icon(Icons.add,color:Color(0xff006687)),
                        title: Text("get_addcategory".tr, style:  TextStyle(fontFamily: 'Quicksand',color: Color(0xff006687), fontWeight: FontWeight.bold, fontSize: 15),),
                      ),


                      Container(height: 1, color: Color(0x59000000),),
                      ListTile(
                          onTap: () {
                            Get.to(()=>SettingsPage());
                            //Navigator.push(context, MaterialPageRoute(builder: (conext) =>SettingsPage()));
                            scaffoldKey.currentState!.closeDrawer();
                          },
                          leading: Icon(Icons.settings,color: Color(0xff494949),),
                          title: Text("get_settings".tr,style: TextStyle(color: Color(0xff494949), fontSize: 18, fontWeight: FontWeight.bold))),

                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
        ),
      ),
    );
  }


  Widget buildMenuItem({required String text}) {
    return Obx(()=>
        ListTile(
          leading : SizedBox(height: 20, child: Image.asset("assets/images/arrow.png")),
          title: Text(text, style:  TextStyle(color: Color(0xff006687), fontWeight: FontWeight.bold, fontSize: 15),),
          trailing:getxController.isCategoryEditing ==true ?Checkbox(
            value: getxController.checkboxState.value,
            onChanged:(value){
              getxController.checkboxState.value =value!;
            }
            ):
            null

        ),
    );
  }


}