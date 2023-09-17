import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_event.dart';
import '../Blocs/Todo/note_state.dart';
import '../NoteDatabaseHelper.dart';
import '../StaticValues.dart';
import '../screens/noteMainPage.dart';
import '../screens/noteViewPage.dart';

class SearchBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _SearchBarWidgetState();
}
class  _SearchBarWidgetState extends State<SearchBarWidget> {

  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  bool isSearching = false;
  final searchTextController = TextEditingController();
  late FocusNode searchFocus;

  @override
  void dispose() {
    searchTextController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchFocus =FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final categoryName = ref.watch(categoryStateProvider);
    final noteBloc= BlocProvider.of<NoteBloc>(context);
    double scw = MediaQuery. of(context). size. width;

    return multiSelectionMode == true ?
    Container(
      height: 75,
      width: scw,
      decoration: Get.isDarkMode? BoxDecoration(color:  Color(0xff383838)):BoxDecoration(color:Color(0xffe7f0f8),),
      child: Row(
        children: [
          IconButton(
              onPressed:(){
                noteBloc.add(TumNotlarEvent(categoryId:StaticValues.currentCategoryId));
                setState(() {
                  selectedItems.clear();
                  multiSelectionMode =false;
                });
              },
              icon: Icon(Icons.clear)
          ),
          Text("${selectedItems.length} Selected"),
          Spacer(),
          IconButton(
              onPressed:() async{
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      title:  Text("get_delconfirmation".tr),
                      content: Text("get_deletenotes?".tr),
                      actions: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: DialogButton(
                                onPressed: ()async {
                                  await noteDatabaseHelper.moveNotesToTrash(selectedItems);
                                  setState(() {
                                    selectedItems.clear();
                                    multiSelectionMode =false;
                                  });
                                  noteBloc.add(StaticValues.currentEvent);
                                  Navigator.pop(context);
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
              icon: Icon(Icons.delete_outline)
          )

        ],
      ),
    )

        :

    GestureDetector(
      onTap: (){
        setState(() {
          isSearching=true;
          searchFocus.requestFocus();
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            height: 45,
            width:  scw*0.8 ,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
              color:  Get.isDarkMode? Color(0xff383838):Color(0xffe7f0f8),
              border:isSearching? Border.all(color: Color(0xff006c8d),width: 2):null,
            ),
            child: Row(
              children: [

                Visibility(
                  visible: isSearching,
                  child: Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        focusNode: searchFocus,
                        controller: searchTextController,
                        onChanged: (value){
                          noteBloc.add(TumNotlarEvent(categoryId:StaticValues.currentCategoryId ,searchWord: value));
                        },
                        decoration: InputDecoration(border: InputBorder.none, hintText: "get_search".tr, contentPadding: const EdgeInsets.all(13),),
                      ),
                    ),
                  ),
                ),

                Visibility(
                    visible: !isSearching,
                    child: Expanded(
                      child: BlocBuilder<NoteBloc, NoteState>(
                        builder: (context, state) {
                          if(state is NoteListState){
                            return Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(StaticValues.currentCategoryName,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Get.isDarkMode? Color(
                                    0xffcecece):Color(0xff131313),
                                  fontFamily: 'Quicksand',),),
                            );
                          }else{
                            return Container();
                          }
                        },
                      ),
                    )
                ),


                GestureDetector(
                  onTap: (){
                    setState(() {
                      isSearching = !isSearching;
                      searchFocus.requestFocus();
                      noteBloc.add(StaticValues.currentEvent);
                    });
                  },
                  child: SizedBox(
                    width: 50,
                    child: Container(
                      height: 23,
                      child: isSearching? Icon(Icons.clear, color: Colors.black,):Image.asset("assets/images/search.png"),
                    ),
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}