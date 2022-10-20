import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../GetxControllerClass.dart';
import '../NoteDatabaseHelper.dart';
import '../SharedPreferencesOperations.dart';

final GetxControllerClass getxController = Get.put(GetxControllerClass());

class SettingsPage extends StatelessWidget {

  NoteDatabaseHelper noteDatabaseHelper = NoteDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final passwordEditTextController = TextEditingController();
    final passwordEditTextControllerAdd = TextEditingController();
    return Scaffold(
      body: SafeArea(
          child: Obx(()=>ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: (){
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      SizedBox(width: 20,),
                      Text("get_settings".tr, style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold ),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text("get_password".tr, style: TextStyle(color: Color(0xff006c8d), fontSize: 16),),
                ),

                if(getxController.hasPassword ==false)
                ListTile(
                  onTap: () async {
                    var sharedPreferences = await SharedPreferences.getInstance();
                    Alert(
                        context: context,
                        desc: "get_useonly".tr,
                        //title: "LOGIN",
                        content: Column(
                          children: <Widget>[
                            TextField(
                              controller: passwordEditTextControllerAdd,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: 'get_password'.tr,
                              ),
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: ()async {
                              if(passwordEditTextControllerAdd.text.length == 4){
                                await sharedPreferences.setString("password", passwordEditTextControllerAdd.text);
                                Get.snackbar("get_passwordadded".tr, "",backgroundColor: Color(0x74006c8d), colorText: Colors.white,);
                                Navigator.pop(context);
                                getxController.hasPassword.value =true;
                              }
                            },
                            child: Text(
                              "get_add".tr,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Color(0xff006c8d),
                          )
                        ]).show();

                  },
                  title: Text("get_addpassword".tr, style: TextStyle(fontSize: 18,)),
                  subtitle: Text('get_passworddesc'.tr),
                ),

                if(getxController.hasPassword ==true)

                Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        screenLock(
                          title: Text("get_enterpasscode".tr),
                            context: context,
                            correctString: await getPassword(),
                            didUnlocked: ()async{
                              var settings = await SharedPreferences.getInstance();
                              Get.off(()=>SettingsPage());
                              String currentPassword = await getPassword();
                              Alert(
                                  context: context,
                                  desc: "get_passwordalertdesc".tr,
                                  //title: "LOGIN",
                                  content: Column(
                                    children: <Widget>[
                                      TextField(
                                        controller: passwordEditTextController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.lock),
                                          hintText: '${currentPassword}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(

                                      onPressed: () {
                                        settings.setString("password", passwordEditTextController.text);
                                        Navigator.pop(context);
                                      },
                                      color: Color(0xff006c8d),
                                      child:Text(
                                        "get_change".tr,
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                          }
                        );
                        },
                      title: Text("get_changepassword".tr, style: TextStyle(fontSize: 18,)),
                    ),

                    ListTile(
                      onTap: () async {
                        var settings = await SharedPreferences.getInstance();
                        screenLock(
                            title: Text("get_enterpasscode".tr),
                            context: context,
                            correctString: await getPassword(),
                            didUnlocked: ()async{
                              await settings.setString("password", "");
                              await noteDatabaseHelper.removeLockfromAllNotes();
                              Get.off(()=>SettingsPage());
                              Get.snackbar("get_passwordremoved".tr, "",
                                backgroundColor: Color(0x74006c8d), colorText: Colors.white,
                              );
                              getxController.hasPassword.value =false;
                            }
                        );

                      },
                      title: Text("get_removepassword".tr, style: TextStyle(fontSize: 18,)),
                      subtitle: Text("get_removepassworddesc".tr),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 30),
                  child: Text("get_costumization".tr, style: TextStyle(color: Color(0xff006c8d), fontSize: 16),),
                ),


                ListTile(
                  onTap: ()async{
                    var settings = await SharedPreferences.getInstance();
                    if(Get.isDarkMode){
                      Get.changeTheme(ThemeData.light());
                      settings.setString("theme", "light");
                    }else{
                      Get.changeTheme(ThemeData.dark());
                      settings.setString("theme", "dark");
                    }
                  },
                  title: Text("get_changetheme".tr, style: TextStyle(fontSize: 18,)),
                  subtitle: Text('get_changethemedesc'.tr),
                ),


                ListTile(
                  onTap: () async {
                    var settings = await SharedPreferences.getInstance();
                    Alert(
                        context: context,
                        content: Column(
                          children: <Widget>[
                            Obx(()=>Slider(
                              value: getxController.fontSizeSlider.value,
                              max: 24,
                              min: 12,
                              divisions: 6,
                              label: getxController.fontSizeSlider.value.round().toString(),
                              onChanged: (double value) {
                                getxController.fontSizeSlider.value =value;
                              },
                            ),
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: ()async {
                              noteDatabaseHelper.setFontsize(fontSize: getxController.fontSizeSlider.value);
                              Get.back();
                            },
                            child: Text(
                              "get_change".tr,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Color(0xff006c8d),
                          )
                        ]).show();
                  },
                  title: Text("get_fontsize".tr, style: TextStyle(fontSize: 18,)),
                  subtitle: Text('${getxController.fontSizeSlider.value.round()}'),
                ),


              ],
            ),
          )
      ),
    );
  }
}


