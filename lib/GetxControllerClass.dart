
import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:get/get.dart';

import 'NoteDatabaseHelper.dart';
import 'SharedPreferencesOperations.dart';

class GetxControllerClass extends GetxController{

  var hasPassword = true.obs;
  var fontSizeSlider =(16.0).obs;
  var isCategoryEditing = false.obs;
  var checkboxState = false.obs;
  var addingTask=false.obs;
  var todoMap = {}.obs;
  var hasDatePast = false.obs;
  var remainders= [].obs;
  var newNoteRemainders= [].obs;
  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();

  @override
  void onInit() async{
    String password =await getPassword();
    hasPassword.value = password ==""?false:true;
    fontSizeSlider.value = await noteDatabaseHelper.getFontsize();
    super.onInit();
  }

  Future<void> getxGetRemainders(int noteId) async{
    remainders.value =await noteDatabaseHelper.getRemainders(noteId);
  }


}