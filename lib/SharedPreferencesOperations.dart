import 'package:shared_preferences/shared_preferences.dart';



Future<String> getPassword() async{
  var settings = await SharedPreferences.getInstance();
  String value =await settings.getString("password")??"";
  return value;
}



