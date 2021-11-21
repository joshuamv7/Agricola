import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class pageCharRT extends StatefulWidget {
  @override
  _pageCharRTState createState() => _pageCharRTState();
}

class _pageCharRTState extends State<pageCharRT> {
  final _database = FirebaseDatabase.instance.reference();
  double _temp = 0;
  late StreamSubscription _tempSubscription;
  late List<LiveDataTemp> chartDataTemp;
  late ChartSeriesController _chartSeriesControllerTemp;

  int _humd = 0;
  late StreamSubscription _humdSubscription;
  late List<LiveDataHumd> chartDataHumd;
  late ChartSeriesController _chartSeriesControllerHumd;

  int _light = 0;
  late StreamSubscription _lightSubscription;
  late List<LiveDataLight> chartDataLight;
  late ChartSeriesController _chartSeriesControllerLight;

  int _soil = 0;
  late StreamSubscription _soilSubscription;
  late List<LiveDataSoil> chartDataSoil;
  late ChartSeriesController _chartSeriesControllerSoil;

  @override
  void initState() {
    chartDataTemp = getChartDataTemp();
    chartDataHumd = getChartDataHumd();
    chartDataLight = getChartDataLight();
    chartDataSoil = getChartDataSoil();

    Timer.periodic(const Duration(seconds: 10), updateDataSourceTemp);
    Timer.periodic(const Duration(seconds: 10), updateDataSourceHumd);
    Timer.periodic(const Duration(seconds: 10), updateDataSourceLight);
    Timer.periodic(const Duration(seconds: 10), updateDataSourceSoil);

    _activateListeners();
    super.initState();
  }

  void _activateListeners() {
    _tempSubscription = _database
        .child('Sensores/j5MN61Q9htfJFkPuZYjJakBpiOm1/temperature')
        .onValue
        .listen((event) {
      final double descripcion = event.snapshot.value;
      setState(() {
        _temp = descripcion;
      });
    });
    _humdSubscription = _database
        .child('Sensores/j5MN61Q9htfJFkPuZYjJakBpiOm1/Humidity')
        .onValue
        .listen((event) {
      final int descripcion = event.snapshot.value;
      setState(() {
        _humd = descripcion;
      });
    });
    _lightSubscription = _database
        .child('Sensores/j5MN61Q9htfJFkPuZYjJakBpiOm1/light')
        .onValue
        .listen((event) {
      final int descripcion = event.snapshot.value;
      setState(() {
        _light = descripcion;
      });
    });
    _soilSubscription = _database
        .child('Sensores/j5MN61Q9htfJFkPuZYjJakBpiOm1/soil')
        .onValue
        .listen((event) {
      final int descripcion = event.snapshot.value;
      setState(() {
        _soil = descripcion;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          "REAL-TIME CHARTS",
          style: TextStyle(fontSize: 40),
        ),
        alignment: Alignment.topLeft,
      ),
      Container(
        margin: EdgeInsets.only(top: 30),
      ),
      Container(
          //humidity
          child: SfCartesianChart(
              series: <LineSeries<LiveDataHumd, String>>[
            LineSeries<LiveDataHumd, String>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesControllerHumd = controller;
              },
              dataSource: chartDataHumd,
              color: Colors.blue.shade600,
              xValueMapper: (LiveDataHumd sales, _) => sales.time,
              yValueMapper: (LiveDataHumd sales, _) => sales.speed,
            )
          ],
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 3,
                  title: AxisTitle(text: 'Time')),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  title: AxisTitle(text: 'Humidity')))),
      Container(
          //Light
          child: SfCartesianChart(
              series: <LineSeries<LiveDataLight, String>>[
            LineSeries<LiveDataLight, String>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesControllerLight = controller;
              },
              dataSource: chartDataLight,
              color: Colors.yellow.shade600,
              xValueMapper: (LiveDataLight sales, _) => sales.time,
              yValueMapper: (LiveDataLight sales, _) => sales.speed,
            )
          ],
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 3,
                  title: AxisTitle(text: 'Time')),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  title: AxisTitle(text: 'Light level')))),
      Container(
          //Temp
          child: SfCartesianChart(
              series: <LineSeries<LiveDataTemp, String>>[
            LineSeries<LiveDataTemp, String>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesControllerTemp = controller;
              },
              dataSource: chartDataTemp,
              color: const Color.fromRGBO(192, 108, 132, 1),
              xValueMapper: (LiveDataTemp sales, _) => sales.time,
              yValueMapper: (LiveDataTemp sales, _) => sales.speed,
            )
          ],
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 3,
                  title: AxisTitle(text: 'Time')),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  title: AxisTitle(text: 'Temperature')))),
      Container(
          //Soil
          child: SfCartesianChart(
              series: <LineSeries<LiveDataSoil, String>>[
            LineSeries<LiveDataSoil, String>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesControllerSoil = controller;
              },
              dataSource: chartDataSoil,
              color: Colors.green.shade600,
              xValueMapper: (LiveDataSoil sales, _) => sales.time,
              yValueMapper: (LiveDataSoil sales, _) => sales.speed,
            )
          ],
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 3,
                  title: AxisTitle(text: 'Time')),
              primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  title: AxisTitle(text: 'Soil moistures')))),
    ]));
  }

  void updateDataSourceTemp(Timer timer) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    chartDataTemp.add(LiveDataTemp(formattedDate, _temp));
    chartDataTemp.removeAt(0);
    _chartSeriesControllerTemp.updateDataSource(
        addedDataIndex: chartDataTemp.length - 1, removedDataIndex: 0);
  }

  void updateDataSourceHumd(Timer timer) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    chartDataHumd.add(LiveDataHumd(formattedDate, _humd));
    chartDataHumd.removeAt(0);
    _chartSeriesControllerHumd.updateDataSource(
        addedDataIndex: chartDataHumd.length - 1, removedDataIndex: 0);
  }

  void updateDataSourceLight(Timer timer) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    chartDataLight.add(LiveDataLight(formattedDate, _light));
    chartDataLight.removeAt(0);
    _chartSeriesControllerLight.updateDataSource(
        addedDataIndex: chartDataLight.length - 1, removedDataIndex: 0);
  }

  void updateDataSourceSoil(Timer timer) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    chartDataSoil.add(LiveDataSoil(formattedDate, _soil));
    chartDataSoil.removeAt(0);
    _chartSeriesControllerSoil.updateDataSource(
        addedDataIndex: chartDataSoil.length - 1, removedDataIndex: 0);
  }

  List<LiveDataTemp> getChartDataTemp() {
    return <LiveDataTemp>[
      LiveDataTemp("0", 0),
      LiveDataTemp("1", 0),
      LiveDataTemp("2", 0),
      LiveDataTemp("3", 0),
      LiveDataTemp("4", 0),
      LiveDataTemp("5", 0),
      LiveDataTemp("6", 0)
    ];
  }

  List<LiveDataHumd> getChartDataHumd() {
    return <LiveDataHumd>[
      LiveDataHumd("0", 0),
      LiveDataHumd("1", 0),
      LiveDataHumd("2", 0),
      LiveDataHumd("3", 0),
      LiveDataHumd("4", 0),
      LiveDataHumd("5", 0),
      LiveDataHumd("6", 0)
    ];
  }

  List<LiveDataLight> getChartDataLight() {
    return <LiveDataLight>[
      LiveDataLight("0", 0),
      LiveDataLight("1", 0),
      LiveDataLight("2", 0),
      LiveDataLight("3", 0),
      LiveDataLight("4", 0),
      LiveDataLight("5", 0),
      LiveDataLight("6", 0)
    ];
  }

  List<LiveDataSoil> getChartDataSoil() {
    return <LiveDataSoil>[
      LiveDataSoil("0", 0),
      LiveDataSoil("1", 0),
      LiveDataSoil("2", 0),
      LiveDataSoil("3", 0),
      LiveDataSoil("4", 0),
      LiveDataSoil("5", 0),
      LiveDataSoil("6", 0)
    ];
  }

  @override
  void deactivate() {
    _tempSubscription.cancel();
    _humdSubscription.cancel();
    _lightSubscription.cancel();
    _soilSubscription.cancel();
    super.deactivate();
  }
}

class LiveDataTemp {
  LiveDataTemp(this.time, this.speed);
  final String time;
  final num speed;
}

class LiveDataHumd {
  LiveDataHumd(this.time, this.speed);
  final String time;
  final int speed;
}

class LiveDataLight {
  LiveDataLight(this.time, this.speed);
  final String time;
  final int speed;
}

class LiveDataSoil {
  LiveDataSoil(this.time, this.speed);
  final String time;
  final int speed;
}
