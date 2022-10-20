import 'dart:convert';
import 'dart:io';

import 'package:e_note_app/DatabaseHelper.dart';
import 'package:e_note_app/test2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(const MaterialApp(home: Test(),));
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}




class _TestState extends State<Test> {

  Future<XFile?>? imageFile;
  Image? imageFromPreferences;

  Future pickImageFromGallery(ImageSource source) async{

    setState(() {
      imageFile = ImagePicker().pickImage(source: source) ;
    });

  }

  loadImageFromReferences(){
    Utilty.getImageToPreferences().then((img) {
      if(img ==null){
        return;
      }
      setState(() {
        imageFromPreferences = Utilty.imageFromBase64String(img);
      });
    });
  }

  Widget imageFromGallery(){
    return FutureBuilder(
      future: imageFile,
      builder: (context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          if(snapshot.data == null){
            return const Text("Error",textAlign:  TextAlign.center);
          }else{

            File? file = File(snapshot.data.path); // XFileyi File formatına dönüştürdüm.
            print(Image.memory(base64Decode((base64Encode(file.readAsBytesSync())))));

            //File? file2 = File(snapshot.data.path);
            Utilty.saveImageToPreferences(Utilty.base64String(file.readAsBytesSync())); // bu ikisi shared preferences ile ilgili


            return Image.file(file);


          }

        }


        if(snapshot.error != null){
          return const Text("Error Picking İmage", textAlign:  TextAlign.center,);
        }

        return const Text("No İmage Selected", textAlign:  TextAlign.center);
      }


    );
  }


  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            pickImageFromGallery(ImageSource.gallery);
            setState(() {
              imageFromPreferences =null;
            });
          },
              icon:Icon(Icons.add)),

          IconButton(onPressed: (){
            loadImageFromReferences();
          },
              icon:Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  imageFromGallery(),

                  imageFromPreferences ==null ? Container(): imageFromPreferences!,
                ],
              ),
            )

            ],
        ),
      ),
    );
  }
}
