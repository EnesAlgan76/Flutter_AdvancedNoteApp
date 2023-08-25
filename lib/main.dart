import 'package:e_note_app/GetxWords.dart';
import 'package:e_note_app/screens/settingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Blocs/Todo/note_bloc.dart';
import 'Blocs/Todo/task_bloc.dart';
import 'SharedPreferencesOperations.dart';
import 'screens/noteMainPage.dart';

void main()async{
  runApp(MyApp());
  var settings = await SharedPreferences.getInstance();
  if(await settings.getString("theme") =="dark"){
    Get.changeTheme(ThemeData.dark());
  }

}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context) {return TaskBloc();}),
        BlocProvider(create:(context) {return NoteBloc();})
      ],
      child:
         GetMaterialApp(
                translations: GetxWords(),
                locale: Get.deviceLocale,
                fallbackLocale: Locale('en', 'US'),
                darkTheme: ThemeData.dark(),
                themeMode: ThemeMode.system,
                debugShowCheckedModeBanner: false,
             home: NoteMainPage()
            )





    );
  }
}