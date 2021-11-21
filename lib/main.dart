import 'package:agricola/pages/pageChar.dart';
import 'package:agricola/pages/pageCharRT.dart';
import 'package:agricola/pages/pageBase.dart';
import 'package:agricola/pages/pageProfile.dart';
import 'package:agricola/pages/pageUpload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  // Workmanager().registerOneOffTask("1", "simpleTask");
  // Workmanager().registerPeriodicTask(
  //   "2",
  //   "simplePeriodicTask",
  //   // When no frequency is provided the default 15 minutes is set.
  //   // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
  //   frequency: Duration(minutes: 15),
  // );
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
          // Workmanager().initialize(
          //     callbackDispatcher, // The top level function, aka callbackDispatcher
          //     isInDebugMode:
          //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
          //     );
          // Workmanager().registerOneOffTask("1", "simpleTask");
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

void addData() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
  Map<String, dynamic> tempData = {"date": formattedDate, "data": 3};
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("data");
  collectionReference.add(tempData);
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    switch (task) {
      case "simpleTask":
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
        Map<String, dynamic> tempData = {"date": formattedDate, "data": 4};
        CollectionReference collectionReference =
            FirebaseFirestore.instance.collection("data");
        collectionReference.add(tempData);
        break;
    }
    // print(
    //     "Native called background task: $addData"); //simpleTask will be emitted here. //simpleTask will be emitted here.
    return Future.value(true);
  });
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
        // body: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Text("Ckeck out or example"),
        //       SizedBox(
        //         height: 6,
        //         width: MediaQuery.of(context).size.width,
        //       ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => ReadExamples(),
              //       ),
              //     );
              //   },
              //   child: Text(_page.toString()),
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => WriteExamples(),
              //         ),
              //       );
              //     },
              //     child: Text(
              //       "write examples",
              //     ))
//             ],
//           ),
//         ));
//   }
// }
