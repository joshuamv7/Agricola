import 'dart:io';
import 'package:agricola/api/Firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:flutter/src/rendering/box.dart';

class pageUpload extends StatefulWidget {
  @override
  _pageUploadState createState() => _pageUploadState();
}

class _pageUploadState extends State<pageUpload> {
  final database = FirebaseDatabase.instance.reference();

  String plantName = "";
  String email = "";
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    final namePlant = database.child('/plantName');
    final userEmail = database.child('/email');
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          "CONFIGURATIONS",
          style: TextStyle(fontSize: 40),
        ),
        alignment: Alignment.topLeft,
      ),
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "SELECT IMAGE FOR PLANT: ",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.topLeft,
          ),
          ElevatedButton(
            onPressed: selectFile,
            child: Text("SELECT IMAGE"),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "UPLOAD SELECTED IMAGE: ",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.topLeft,
          ),
          ElevatedButton(
            onPressed: uploadFile,
            child: Text("UPLOAD IMAGE"),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "PLANT NAME: ",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.topLeft,
          ),
        ],
      ),
      TextField(
        decoration: InputDecoration(hintText: "PLANT NAME"),
        onChanged: (String str) {
          setState(() {
            plantName = str;
          });
        },
      ),
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "UPLOAD PLANT NAME: ",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.topLeft,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await namePlant.set({"name": plantName});
              } catch (e) {
                print('You got an error!  $e');
              }
            },
            child: Text("UPLOAD PLANT NAME"),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "USER EMAIL: ",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.topLeft,
          ),
        ],
      ),
      TextField(
        decoration: InputDecoration(hintText: "USER EMAIL"),
        onChanged: (String str) {
          setState(() {
            email = str;
          });
        },
      ),
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "UPLOAD USER EMAIL: ",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.topLeft,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await userEmail.set({"email": email});
              } catch (e) {
                print('You got an error!  $e');
              }
            },
            child: Text("UPLOAD PLANT NAME"),
          ),
        ],
      ),
    ]);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
    print(file);
  }

  Future uploadFile() async {
    final URLimage = database.child('/image');
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await URLimage.set({"url": urlDownload});
  }
}
