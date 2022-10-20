import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utilty{
  static String IMG_KEY ="IMAGE_KEY";


  static Future<bool> saveImageToPreferences(String value) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(IMG_KEY, value);
  }


  static Future<String?> getImageToPreferences() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(IMG_KEY);
  }

  static String base64String(Uint8List data){
    return base64Encode(data);
  }

  static Image imageFromBase64String( String base64String){
    return Image.memory(base64Decode(base64String), fit:  BoxFit.fill,);
  }

}