import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WriteExamples extends StatefulWidget {
  @override
  _WriteExamplesState createState() => _WriteExamplesState();
}

class _WriteExamplesState extends State<WriteExamples> {
  final database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    final dailySpecialRef = database.child('/dailySpecial');

    return Scaffold(
      appBar: AppBar(
        title: Text("Write examples"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await dailySpecialRef
                          .set({"descripcion": 'vainilla latte', 'price': 110});
                      print("Spoecial has been written");
                    } catch (e) {
                      print('You got an error!  $e');
                    }
                  },
                  child: Text('Simple set')),
            ],
          ),
        ),
      ),
    );
  }
}
