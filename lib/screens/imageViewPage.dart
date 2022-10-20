
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_event.dart';
import '../NoteDatabaseHelper.dart';

class ImageViewPage extends StatelessWidget {
  String path;
  int imageId;
  ImageViewPage({required this.path, required this.imageId});
  NoteDatabaseHelper db = NoteDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final noteBloc= BlocProvider.of<NoteBloc>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Color(0xff00c3ff),
          backgroundColor: Color(0xff00222d),
          actions: [
            IconButton(
                onPressed: ()async{
                  db.deleteImages(imageId: imageId);
                  noteBloc.add(TumNotlarEvent(categoryId: -1));
                  await File(path).delete();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete_outline_rounded)),
          ],
        ),
        backgroundColor: Color(0xff00222d),
        body: InteractiveViewer(
          child: Image.file(
            File(path),
            fit: BoxFit.contain,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),

      ),
    );
  }
}
