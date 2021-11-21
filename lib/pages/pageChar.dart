import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class pageChar extends StatefulWidget {
  @override
  _pageCharState createState() => _pageCharState();
}

class _pageCharState extends State<pageChar> {
  // Map data;
  addData() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    Map<String, dynamic> tempData = {"date": formattedDate, "data": 5};
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("data");
    collectionReference.add(tempData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          onPressed: addData,
          child: Text(
            "write examples",
          )),
    );
  }
}
