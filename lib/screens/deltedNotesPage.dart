import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Blocs/Todo/note_bloc.dart';
import '../NoteDatabaseHelper.dart';
import '../SharedPreferencesOperations.dart';
import '../StaticValues.dart';
import '../models/Note.dart';
import 'deletedNotesViewPage.dart';
import 'noteViewPage.dart';

class DeletedNotesPage extends StatefulWidget {
  @override
  _DeletedNotesPageState createState() => _DeletedNotesPageState();
}

class _DeletedNotesPageState extends State<DeletedNotesPage> {
  List<int> selectedItems = [];
  bool multiSelectionMode = false;
  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  bool isPasswordCorrect = false;
  List<int> idList = [];

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(noteBloc),
            Expanded(
              child: _buildDeletedNotesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Function to fetch deleted notes
  Future<List<Note>> getDeletedNotes() async {
    final list = await noteDatabaseHelper.getDeletedNotes();
    for (final note in list) {
      idList.add(note.noteId!);
    }
    return list;
  }

  // Widget for the header section
  Widget _buildHeader(NoteBloc noteBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              noteBloc.add(StaticValues.currentEvent);
            },
            icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xff006c8d)),
          ),
        ),
        _buildEmptyTrashButton(),
      ],
    );
  }

  // Widget for the "Empty Trash" button
  Widget _buildEmptyTrashButton() {
    return GestureDetector(
      onTap: () async {
        await _showDeleteConfirmationDialog();
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Get.isDarkMode?Color(
              0xffffe300):Color(0xff720000)),
        ),
        child: Row(
          children: [
            Text("get_emptytrash".tr, style: TextStyle(color: Get.isDarkMode?Color(
                0xffffe300):Color(0xff720000))),
          ],
        ),
      ),
    );
  }

  // Function to display the delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text("get_delpermanently".tr),
          content: Text("get_delpermanently?".tr),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: DialogButton(
                    onPressed: () async {
                      await noteDatabaseHelper.deleteNotes(idList);
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    color: Color(0xff8d0000),
                    child: Text("get_delete".tr, style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: DialogButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Color(0xff006c8d),
                    child: Text("get_cancel".tr, style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget for the deleted notes grid
  Widget _buildDeletedNotesGrid() {
    return FutureBuilder(
      future: getDeletedNotes(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GridTile(
            child: MasonryGridView.builder(
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              mainAxisSpacing: 4,
              itemCount: snapshot.data.length,
              crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return _buildNoteCard(snapshot.data[index], index);
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Widget for individual note card
  Widget _buildNoteCard(Note note, int index) {
    final content = note.noteContent!.length > 150 ? note.noteContent!.substring(0, 150) : note.noteContent;

    return GestureDetector(
      onTap: () async {
        _showRecoverDeleteDialog(note);
      },
      child: Card(
        elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${note.noteTitle}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (note.isLocked == 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Icon(
                        Icons.lock,
                        color: Color(0x4a000000),
                        size: 40,
                      ),
                    ),
                  ],
                )
              else
                Text("${content}", style: TextStyle(fontSize: 17)),
              note.isFavorite == 1 ?
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.star,
                  color: Color(0xffffe500),
                ),
              ):SizedBox()
            ],
          ),
        ),
      ),
    );
  }


  void _showRecoverDeleteDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('get_recoverordelete'.tr),
          content: Text('get_chooseaction'.tr),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
               await noteDatabaseHelper.recoverNotefromTrash(note.noteId!);
               setState(() {
                 Navigator.of(context).pop();
               });
                 // Close the dialog
              },
              child: Text('get_recover'.tr),
            ),
            TextButton(
              onPressed: ()async {
                await noteDatabaseHelper.deleteNotes([note.noteId!]);
               setState(() {
                 Navigator.of(context).pop();
               });
                 // Close the dialog
              },
              child: Text('get_deletepermanantly'.tr),
            ),
          ],
        );
      },
    );
  }



  Widget _buildRecoverDeleteOptions(Note note) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Recover the note
           // _recoverNote(note);
          },
          style: ElevatedButton.styleFrom(primary: Colors.green),
          child: Text("Recover"),
        ),
        ElevatedButton(
          onPressed: () {
            // Permanently delete the note
           // _deleteNotePermanently(note);
          },
          style: ElevatedButton.styleFrom(primary: Colors.red),
          child: Text("Delete Permanently"),
        ),
      ],
    );
  }

  // Function to display the unlock screen dialog
  Future<void> _showUnlockScreenDialog(Note note, int index) async {
    final correctString = await getPassword();

    screenLock(
      title: Text("get_enterpasscode".tr),
      context: context,
      correctString: correctString,
      didUnlocked: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeletedNotesViewPage(note, index)));
        selectedCategoryId = note.noteCategoryId;
      },
    );
  }
}
