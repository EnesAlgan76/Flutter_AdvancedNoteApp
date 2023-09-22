
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:e_note_app/AdManager.dart';
import 'package:e_note_app/GetxControllerClass.dart';
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

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
List<int> selectedItems = [];
bool multiSelectionMode = false;

class NoteMainPage extends StatefulWidget {
  @override
  _NoteMainPageState createState() => _NoteMainPageState();
}

class _NoteMainPageState extends State<NoteMainPage> {
  bool isPasswordCorrect = false;
  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();
  GetxControllerClass controller = Get.put(GetxControllerClass());


  @override
  void initState() {
    loadFontSize();
    super.initState();
  }
  Future<void> loadFontSize() async {
    double dbFontSize = await noteDatabaseHelper.getFontsize();
    setState(() {
      controller.fontSizeSlider.value = dbFontSize; // Update the font size with the database value
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
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  BlocBuilder<NoteBloc, NoteState>(
                    builder: (context, state) {
                      if (state is NoteListState) {
                        if (state.noteList.isNotEmpty) {
                          return buildNoteGridView2(state.noteList);
                        } else {
                          return buildEmptyNotePlaceholder();
                        }
                      } else {
                        return Container(); // Placeholder for non-NoteListState
                      }
                    },
                  ),

                  SearchBarWidget(),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingMenu(),
                  //AddManager.buildBannerAdContainer()
                ],
              ),
          ),
                ],
              ),
            ),
          ],
        ),
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.cent,
      //
      // floatingActionButton: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingMenu(),
      //     AddManager.buildBannerAdContainer()
      //   ],
      // ),
    );
  }


  Widget buildNoteGridView2(List<Note> noteList) {
    List<Widget> children = [];

    for (int index = 0; index < noteList.length; index++) {
      var note = noteList[index];
      var content = note.noteContent!.length > 150
          ? note.noteContent!.substring(0, 150)
          : note.noteContent;

      children.add(buildNoteTile(context, note, content!, index));

      // Insert an ad after every 4nd card
      // if ((index + 1) % 4 == 0 && index != noteList.length - 1) {
      //   children.add(
      //     buildAdContainer()
      //   );
      //   // Replace this with your actual AppLovin BANNER widget
      // }
    }

    return GridTile(
      child: MasonryGridView.builder(
        padding: EdgeInsets.only(top: 80),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
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
                if(note.isLocked!=1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: note.imageList!.values.take(2).map((imagePath) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 4 - 30, // Adjust width as needed
                        child: AspectRatio(
                          aspectRatio: 1.0, // Maintain a square aspect ratio
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover, // Ensure the image fits evenly
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                buildNoteContentWidget(note, content),
                if (note.isFavorite == 1) buildFavoriteIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }






  void onTapNoteTile(Note note, int index) async {
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
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => NoteViewPage(note, index),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = 0.7;
              const end = 1.0;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              var scaleAnimation = animation.drive(tween);

              return ScaleTransition(
                scale: scaleAnimation,
                child: child,
              );
            },
            // Set the duration for pushing (forward) animation
            transitionDuration: Duration(milliseconds: 200),
            // Set a very short duration for popping (backward) animation
            reverseTransitionDuration: Duration(milliseconds: 1),
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


  Widget buildNoteContentWidget(Note note, String content) {
    if (note.isLocked == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.lock, color: Color(0x4a000000), size: 40),
          ),
        ],
      );
    } else {
      return Obx(() =>Text(
        "$content",
        style: TextStyle(
          fontSize: controller.fontSizeSlider.value,
          color: Colors.black54,
          fontFamily: 'Quicksand',
        ),
      ));
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

  buildAdContainer() {
    return MaxAdView(
        adUnitId: "c07ce7925258be0b",
        adFormat: AdFormat.banner,
        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
          printWarning('BANNER widget ad loaded from ${ad.networkName}');
        }, onAdLoadFailedCallback: (adUnitId, error) {
          printWarning('BANNER widget ad failed to load with error code ${error.code} and message: ${error.message}');
        }, onAdClickedCallback: (ad) {
          printWarning('BANNER widget ad clicked');
        }, onAdExpandedCallback: (ad) {
          printWarning('BANNER widget ad expanded');
        }, onAdCollapsedCallback: (ad) {
          printWarning('BANNER widget ad collapsed');
        }, onAdRevenuePaidCallback: (ad) {
          printWarning('BANNER widget ad revenue paid: ${ad.revenue}');
        }));
  }

}

// Define your text styles here
final TextStyle noteTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  fontFamily: 'Quicksand',
);




class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? Colors.grey,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}