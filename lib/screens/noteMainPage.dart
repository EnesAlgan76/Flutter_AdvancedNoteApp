import 'package:e_note_app/screens/settingPage.dart';
import 'package:e_note_app/widgets/searchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../Blocs/Todo/note_bloc.dart';
import '../Blocs/Todo/note_state.dart';
import '../NoteDatabaseHelper.dart';
import '../SharedPreferencesOperations.dart';
import '../StaticValues.dart';
import '../models/Note.dart';
import '../widgets/floatingActionButton.dart';
import '../widgets/navigationDrawer.dart';
import 'noteViewPage.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
List<int> selectedItems = [];
bool multiSelectionMode = false;
double fontSize = 16;

class NoteMainPage extends StatefulWidget {
  @override
  _NoteMainPageState createState() => _NoteMainPageState();
}

class _NoteMainPageState extends State<NoteMainPage> {
  bool isPasswordCorrect = false;
  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();

  @override
  void initState() {
    loadFontSize();
    super.initState();
  }
  Future<void> loadFontSize() async {
    double dbFontSize = await noteDatabaseHelper.getFontsize();
    setState(() {
      fontSize = dbFontSize; // Update the font size with the database value
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    noteBloc.add(StaticValues.currentEvent);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavigationDrawerWidget(),
      body: SafeArea(
        child: buildNoteList(),
      ),
      floatingActionButton: FloatingMenu(),
    );
  }

  Widget buildNoteList() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              BlocBuilder<NoteBloc, NoteState>(
                builder: (context, state) {
                  if (state is NoteListState) {
                    if (state.noteList.isNotEmpty) {
                      return buildNoteGridView(state.noteList);
                    } else {
                      return buildEmptyNotePlaceholder();
                    }
                  } else {
                    return Container(); // Placeholder for non-NoteListState
                  }
                },
              ),

              SearchBarWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNoteGridView(List<Note> noteList) {
    return GridTile(
      child: MasonryGridView.builder(
        padding: EdgeInsets.only(top: 80),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          var note = noteList[index];
          var content = note.noteContent!.length > 150
              ? note.noteContent!.substring(0, 150)
              : note.noteContent;

          return buildNoteTile(context, note, content!, index);
        },
      ),
    );
  }

  Widget buildNoteTile(BuildContext context, Note note, String content, int index) {
    return GestureDetector(
      onTap: () => onTapNoteTile(note, index),
      onLongPress: () => onLongPressNoteTile(note),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 75),
          child: Container(
            decoration: BoxDecoration(
              border: selectedItems.contains(note.noteId)
                  ? Border.all(color: Colors.blueAccent, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(20),
              color: Color(int.parse(note.noteColor ?? "0xffd1c4e9")),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${note.noteTitle}", style: noteTitleTextStyle),
                buildNoteContentWidget(note.isLocked, content),
                if (note.isFavorite == 1)
                  buildFavoriteIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapNoteTile(Note note, int index) async {
    var fontSize = await noteDatabaseHelper.getFontsize();
    if (multiSelectionMode == true) {
      doMultiSelection(note.noteId!);
      setState(() {
        if (selectedItems.isEmpty) {
          multiSelectionMode = false;
        }
      });
    } else {
      getxController.getxGetRemainders(note.noteId!);
      if (note.isLocked == 1) {
        await unlockNoteAndNavigate(note,index );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteViewPage(note, index),
          ),
        );
        selectedCategoryId = note.noteCategoryId;
      }
    }
  }

  void onLongPressNoteTile(Note note) {
    doMultiSelection(note.noteId!);
    multiSelectionMode = true;
    setState(() {});
  }

  Future<void> unlockNoteAndNavigate(Note note, int index) async {
    await screenLock(
      title: Text("get_enterpasscode".tr),
      context: context,
      correctString: await getPassword(),
      didUnlocked: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoteViewPage(note, index),
          ),
        );
        selectedCategoryId = note.noteCategoryId;
      },
    );
  }


  Widget buildNoteContentWidget(int? isLocked, String content) {
    if (isLocked == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.lock, color: Color(0x4a000000), size: 40),
          ),
        ],
      );
    } else {
      return Text(
        "$content",
        style: noteContentTextStyle,
      );
    }
  }

  Widget buildFavoriteIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.star, color: Color(0xffffe500)),
      ],
    );
  }

  void doMultiSelection(int noteId) {
    if (selectedItems.contains(noteId)) {
      selectedItems.remove(noteId);
    } else {
      selectedItems.add(noteId);
    }
  }

  Widget buildEmptyNotePlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Container(
        margin: EdgeInsets.all(80),
        child: Image.asset(
          "assets/images/leaff.png",
          color: Colors.white.withOpacity(0.1),
          colorBlendMode: BlendMode.modulate,
        ),
      ),
    );
  }

}

// Define your text styles here
final TextStyle noteTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: 'Quicksand',
);

final TextStyle noteContentTextStyle = TextStyle(
  fontSize: fontSize,
  color: Colors.black54,
  fontFamily: 'Quicksand',
);
