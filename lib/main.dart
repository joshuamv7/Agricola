import 'package:agricola/pages/pageChar.dart';
import 'package:agricola/pages/pageCharRT.dart';
import 'package:agricola/pages/pageBase.dart';
import 'package:agricola/pages/pageProfile.dart';
import 'package:agricola/pages/pageUpload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Yoy have an error! ${snapshot.error.toString()}');
            return Text('Something wentt wrong');
          } else if (snapshot.hasData) {
            return MyHomePage(title: 'Monitoreo Agricola');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  final pageChar _pageChar = new pageChar();
  final pageCharRT _pageCharRT = new pageCharRT();
  final pageBase _pageBase = new pageBase();
  final pageProfile _pageProfile = new pageProfile();
  final pageUpload _pageUpload = new pageUpload();

  Widget _showPage = new pageBase();

  Widget _viewChooser(int page) {
    switch (page) {
      case 0:
        return _pageBase;
      case 1:
        return _pageCharRT;
      case 2:
        return _pageChar;
      case 3:
        return _pageUpload;
      default:
        return new Container(
          child: new Center(
            child: new Text(
              'No page found by page chosser',
              style: new TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.teal.shade400,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          // initialIndex: pageIndex,
          backgroundColor: Colors.teal.shade50,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.auto_awesome_mosaic_sharp, size: 30),
            Icon(Icons.show_chart_rounded, size: 30),
            Icon(Icons.calendar_today_outlined, size: 30),
            Icon(Icons.perm_identity, size: 30)
          ],
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _viewChooser(tappedIndex);
            });
          },
        ),
        body: Container(
          color: Colors.teal.shade50,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}
