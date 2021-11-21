import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart';

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

  Future<void> send() async {
    String username = 'agricolaproyecto1@gmail.com';
    String password = 'Proyecto123!';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add('destination@example.com')
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

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
        ElevatedButton(onPressed: send, child: Text("go")),
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
