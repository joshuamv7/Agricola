import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

class pageBase extends StatefulWidget {
  @override
  _pageBaseState createState() => _pageBaseState();
}

class _pageBaseState extends State<pageBase> {
  final _database = FirebaseDatabase.instance.reference();
  String _displayText = "Results go here";
  late StreamSubscription _urlSubscription;
  int test1 = 0;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _urlSubscription = _database.child('image/url').onValue.listen((event) {
      final String descripcion = event.snapshot.value;
      setState(() {
        _displayText = descripcion;
      });
      print("-**-*-*-**-*-**");
      print(descripcion);
    });
  }

  // Future<void> send() async {
  //   final email = 'agricolaproyecto1@gmail.com';
  //   final token = '';
  //   final smtpServer = gmailSaslXoauth2(email, token);

  //   final message = Message()
  //     ..from = Address(email, "agricola")
  //     ..recipients = ["joshua.moreira7@gmail.com"]
  //     ..subject = "hello"
  //     ..text = "holiwis";
  //   try {
  //     await (message, smtpServer);
  //   } on MailerException catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            "OVERALL STATUS",
            style: TextStyle(fontSize: 40),
          ),
          alignment: Alignment.topLeft,
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
        ),
        // ElevatedButton(onPressed: send, child: Text("go")),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(_displayText), fit: BoxFit.fill),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.all(10),
                      alignment: Alignment.topRight,

                      child: Icon(
                        Icons.warning,
                        size: 20,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                    Icon(Icons.water_damage_outlined, size: 100),
                    Text(
                      "Humidity",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                    ),
                    Icon(Icons.thermostat_sharp, size: 100),
                    Text(
                      "Temperature",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(20),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.teal.shade400,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                      ),
                      Icon(Icons.light_mode_rounded, size: 100),
                      Text(
                        "Ligth",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
              Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                    ),
                    Icon(Icons.grass_rounded, size: 100),
                    Text(
                      "soil moisture",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void deactivate() {
    _urlSubscription.cancel();
    super.deactivate();
  }
}
