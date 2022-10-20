import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_event.dart';
import '../Blocs/Todo/note_state.dart';
import '../NoteDatabaseHelper.dart';

class FavoriteStar extends StatefulWidget {
  int index;

  FavoriteStar(this.index);

  @override
  _FavoriteStarState createState() => _FavoriteStarState();
}

class _FavoriteStarState extends State<FavoriteStar> {
  NoteDatabaseHelper notedbHelper = NoteDatabaseHelper();
  bool isFilled =false;
  @override
  Widget build(BuildContext context) {
    final noteBloc= BlocProvider.of<NoteBloc>(context);
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if(state is NoteListState){

          if(widget.index ==-1){
            return IconButton(
                onPressed:(){
                  setState(() {
                    isFilled =!isFilled;
                  });
                },
                icon: isFilled ? Icon( Icons.star,color: Colors.yellow,size: 27,) : Icon( Icons.star_border_rounded,color: Colors.blueGrey,size: 27,)
            );
          }
          return IconButton(
              onPressed:()async{
                await notedbHelper.updateIsFavorite(state.noteList[widget.index].noteId!, state.noteList[widget.index].isFavorite==0?1:0);
                noteBloc.add(TumNotlarEvent(categoryId: -1));
              },
              icon: state.noteList[widget.index].isFavorite==1 ? Icon( Icons.star,color: Colors.yellow,size: 27,) : Icon( Icons.star_border_rounded,color: Colors.blueGrey,size: 27,)
          );
        }else{
          return Container();
        }
      },
    );
  }
}