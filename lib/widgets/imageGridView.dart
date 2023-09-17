import 'dart:io';

import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_state.dart';
import '../StaticValues.dart';
import '../screens/imageViewPage.dart';

class ImageGridWidget extends StatelessWidget {
  int? indexOfNote;


  ImageGridWidget({this.indexOfNote});

  @override
  Widget build(BuildContext context) {
    List imageList = StaticValues.imageStringList;

    if(indexOfNote==null){
      return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: imageList.length>0 ?(imageList.length<=4? 100:200):0,
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: imageList.length>4 ?2:1,),
            itemCount: imageList.length,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.all(8),
                child: Image.file(File(StaticValues.imageStringList[index]),fit: BoxFit.fill,),
              );
            }
        ),
      );
    }else{
      return BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if(state is NoteListState){
            List allImageList= state.noteList[indexOfNote!].imageList!.values.toList();
            if(state.noteList[indexOfNote!].imageList!.length>0 ){
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: allImageList.length>0 ?(allImageList.length<=4? 100:200):0,
                child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: allImageList.length>4 ?2:1,
                    ),
                    itemCount: allImageList.length,
                    itemBuilder: (context, index){
                      int imageId = state.noteList[indexOfNote!].imageList!.keys.toList()[index];
                      return GestureDetector(
                        onTap: (){
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewPage(path: allImageList[index],imageId:imageId ,)));
                            },
                            child: Container(
                              child: Image.file(File(allImageList[index]),fit: BoxFit.fill,),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            }else{
              return Container();
            }

          }else{
            return Container();
          }
        },
      );
    }



  }
}