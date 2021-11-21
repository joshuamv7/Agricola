import 'dart:io';
import 'package:agricola/api/Firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';

class pageUpload extends StatefulWidget {
  @override
  _pageUploadState createState() => _pageUploadState();
}

class _pageUploadState extends State<pageUpload> {
  final database = FirebaseDatabase.instance.reference();
  String URL = 'https://googleflutter.com/sample_image.jpg';
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Column(children: <Widget>[
      ElevatedButton(
        onPressed: selectFile,
        child: Text("Seleccionar"),
      ),
      ElevatedButton(
        onPressed: uploadFile,
        child: Text("Subir"),
      ),
      Image.network(URL),
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
