# E Notes 

I developed E Notes based on some complexities in other notes app. E Notes is need-oriented and provides easy note taking without unnecessary features. You can add notes, add pictures from gallery or camera, create reminders, create to-do lists and make changes in one page.

<img src="https://github.com/EnesAlgan76/e_note_app/blob/master/homePage.png" height="600">

## Project Structure
```bash
lib
    └─── Blocs
    |       |─── note_bloc.dart
    |       |─── note_state.dart
    |       |─── task_bloc.dart
    |       └─── note_event.dart
    |
    |─── models 
    |	    |─── Category.dart
    |	    |─── Note.dart
    |	    |─── Remainder.dart
    |	    |─── task.dart
    |	    |─── task2.dart
    |       └─── todo.dart
    |
    |─── screens 
    |	    |─── deletedNotesViewPage.dart
    |	    |─── deletedNotesPage.dart
    |	    |─── tosodPage.dart
    |	    |─── imageViewPage.dart
    |	    |─── noteViewPage.dart
    |	    |─── noteMainPage.dart
    |       └─── settingPage.dart
    |─── widgets 
    |	    |─── categoriesPopUpMenu.dart
    |	    |─── favoriteStar.dart
    |	    |─── floatingActionButton.dart
    |	    |─── imageGridView.dart
    |	    |─── navigationDrawer.dart
    |	    |─── noteTodoWidget.dart
    |	    |─── popUpMenu.dart
    |	    |─── remaindersWidget.dart
    |       └─── searchBarWidget.dart
    |
    |
    |─── DatabaseHelper.dart 
    |─── GetxControllerClass.dart 
    |─── GetxWords.dart 
    |─── localNotificationService.dart 
    |─── main.dart 
    |─── NoteDatabaseHelper.dart 
    |─── SharedPreferencesOperations.dart  
    |─── StaticValues.dart 
    └─── widgets.dart 
```

## Dependencies

```bash
  sqflite:
  path:
  get: ^4.6.5
  flutter_bloc: ^8.0.1
  image_picker: ^0.8.5+3
  flutter_staggered_grid_view: ^0.6.2
  circular_menu: ^2.0.1
  path_provider: ^2.0.0
  rflutter_alert: ^2.0.4
  flutter_screen_lock: ^7.0.4
  shared_preferences: ^2.0.15
  flutter_local_notifications: ^12.0.2
  date_time_picker: ^2.1.0
  cupertino_icons: ^1.0.2
```




## Main Page

- Added flutter_staggered_grid_view dependencies to get cards of different lengths. Container heights are sized based on the widget size.
- Used get library to enable theme switching and saved theme state using shared preferences.

## Note View Page

<p float="left">
  <img src="https://github.com/EnesAlgan76/e_note_app/blob/master/noteViewPage.png" height="400">
  <img src="https://github.com/EnesAlgan76/e_note_app/blob/master/noteView2.PNG" height="400"> 
</p>

- The note viewing and adding page are the same class. The content is organized according to the sent data.
- Added circular_menu dependency to show nice animated floating menu at bottom left. With that menu you can add remainder, todo, photo from gallery or camera
- Added reminder feature with the help of FlutterLocalNotificationsPlugin class.
- Snackbars displayed with the help of get library in different parts of the project
- Changes in your notes will be saved even if you press the back button.
- Used flutter_screen_lock dependency to show beautiful lock screen UI and make some controls.<br/><br/><br/><br/>


- You can also view, delete and zoom pictures.
<img src="https://github.com/EnesAlgan76/e_note_app/blob/master/imageView.png" height="400">


<p float="left">
  <img src="https://github.com/EnesAlgan76/e_note_app/blob/master/others.png" height="400">
  <img src="https://github.com/EnesAlgan76/e_note_app/blob/master/todoPage.png" height="400">
</p>

- With drawer which has a nice and orgaized design you can switch between categories. 
- Click the pencil button in the upper right corner of the category menu, and then drag the category sideways to delete it. When the category is deleted, the notes in that category are not deleted, they are updated to "All Categories".
- Crated one page for only todos. You can do all the operations like add task, add todo, delete, update... on one page.



