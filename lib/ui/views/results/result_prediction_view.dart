import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../../../services/firebase_service.dart';

class ResultPredictionView extends StatefulWidget {
  static String id = "resultprediction_view";
  const ResultPredictionView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResultPredictionViewState createState() => _ResultPredictionViewState();
}

class _ResultPredictionViewState extends State<ResultPredictionView> {
  List<FlSpot> depressionData = [];
  List<FlSpot> anxietyData = [];
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _getDataFromFirestore();
  }

  Future<void> _getDataFromFirestore() async {
    FirebaseService firebaseService = FirebaseService();
    List<Map<String, dynamic>> depressionResultList = await firebaseService.getLastSevenDaysPrediction('predictions');
    List<Map<String, dynamic>> anxietyResultList = await firebaseService.getLastSevenDaysPrediction('anxietypredictions');

    setState(() {
      if (depressionResultList.isNotEmpty) {
        for (var depressionResult in depressionResultList) {
          var yTimestamp = depressionResult['time'] as int;
          depressionData.add(FlSpot(yTimestamp.toDouble(), depressionResult['result'].toDouble()));
        }
        depressionData.sort((a, b) => a.x.compareTo(b.x));
      } else {
        if (kDebugMode) {
          print('No existen datos.');
        }
      }
      if (anxietyResultList.isNotEmpty) {
        for (var anxietyResult in anxietyResultList) {
          var yTimestamp = anxietyResult['time'] as int;
          anxietyData.add(FlSpot(yTimestamp.toDouble(), anxietyResult['result'].toDouble()));
        }
        anxietyData.sort((a, b) => a.x.compareTo(b.x));
      } else {
        if (kDebugMode) {
          print('No existen datos.');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 10,
          ),
          const Text('Topicos de Depresión'),
          const SizedBox(height: 20),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: depressionData == null
                  ? const CircularProgressIndicator()
                  : depressionData.isEmpty
                  ? Container(
                  margin: const EdgeInsets.all(3),
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const Image(
                    image: AssetImage('assets/images/empty_data.jpg'),
                  ))
                  : Container(
                width: 350,
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.4,
                child: SizedBox(
                  child: LineChart(
                    LineChartData(
                      clipData: FlClipData.all(),
                      minY: 0,
                      maxY: 2,
                      minX: depressionData
                          .reduce((value, element) =>
                      value.x < element.x ? value : element)
                          .x,
                      maxX: depressionData
                          .reduce((value, element) =>
                      value.x > element.x ? value : element)
                          .x,
                      lineBarsData: [
                        LineChartBarData(
                            spots: depressionData,
                            isCurved: true,
                            isStepLineChart: true
                        )
                      ],
                      gridData: FlGridData(
                        show: true,
                      ),
                      titlesData: FlTitlesData(
                          rightTitles: AxisTitles(
                              sideTitles:
                              SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles:
                              SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 30,
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  DateTime baseDate = DateTime(1900, 1, 1);
                                  DateTime myDate = baseDate.add(Duration(
                                      milliseconds: value.toInt()));
                                  return Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5.0),
                                    child: Transform.rotate(
                                      angle: 35 * 3.1416 / 180,
                                      child: Text(
                                          DateFormat.Md().format(myDate)),
                                    ),
                                  );
                                },
                              ))),
                    ),
                  ),
                ),
              ),
          ),
          const SizedBox(height: 10),
          const Text('Topicos de ansiedad'),
          const SizedBox(height: 10),
          Container(
            width: 350,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.4,
            child: anxietyData == null
                ? const CircularProgressIndicator()
                : anxietyData.isEmpty
                ? Container(
                margin: const EdgeInsets.all(3),
                width: 300,
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Image(
                  image: AssetImage('assets/images/empty_data.jpg'),
                ))
                : Container(
              width: 350,
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.4,
              child: SizedBox(
                child: LineChart(
                  LineChartData(
                    clipData: FlClipData.all(),
                    minY: 0,
                    maxY: 2,
                    minX: anxietyData
                        .reduce((value, element) =>
                    value.x < element.x ? value : element)
                        .x,
                    maxX: anxietyData
                        .reduce((value, element) =>
                    value.x > element.x ? value : element)
                        .x,
                    lineBarsData: [
                      LineChartBarData(
                          spots: anxietyData,
                          isCurved: true,
                          isStepLineChart: true
                      )
                    ],
                    gridData: FlGridData(
                      show: true,
                    ),
                    titlesData: FlTitlesData(
                        rightTitles: AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles:
                            SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 20,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                DateTime baseDate = DateTime(1900, 1, 1);
                                DateTime myDate = baseDate.add(Duration(
                                    milliseconds: value.toInt()));
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(top: 5.0),
                                  child: Transform.rotate(
                                    angle: 35 * 3.1416 / 180,
                                    child: Text(
                                        DateFormat.Md().format(myDate)),
                                  ),
                                );
                              },
                            ))),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
