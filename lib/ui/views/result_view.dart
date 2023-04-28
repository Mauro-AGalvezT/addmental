import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class ResultView extends StatefulWidget {
  static String id = "result_view";
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  List<FlSpot> anxietyData = [];
  List<FlSpot> depressionData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromFirestore();
  }

  Future<void> _getDataFromFirestore() async {
    List<Map<String, dynamic>> depressionResult = await getResultDepression();
    List<Map<String, dynamic>> anxietyResult = await getResultAnxiety();

    setState(() {
      if (depressionResult.isNotEmpty) {
        for (var test in depressionResult) {
          var yFormatted = test['date'].replaceAll('/', '-');
          var date = DateTime.parse(yFormatted);
          var yTimestamp = date.millisecondsSinceEpoch.toDouble();
          depressionData.add(FlSpot(test['score'].toDouble(), yTimestamp));
          //print('Score: ${test['score']}, Fecha: ${test['date']}');
        }
      } else {
        print('No existen datos.');
      }
      if (anxietyResult.isNotEmpty) {
        for (var test in anxietyResult) {
          var yFormatted = test['date'].replaceAll('/', '-');
          var date = DateTime.parse(yFormatted);
          var yTimestamp = date.millisecondsSinceEpoch.toDouble();
          anxietyData.add(FlSpot(test['score'].toDouble(), yTimestamp));
          //print('Score: ${test['score']}, Fecha: ${test['date']}');
        }
      } else {
        print('No existen datos.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 10,
          ),
          const Text('Inventario de Depresión de Beck-II'),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: depressionData == null
                ? const CircularProgressIndicator()
                : depressionData.isEmpty
                    ? Container(
                        //color: const Color.fromARGB(255, 230, 230, 230),
                        margin: const EdgeInsets.all(3),
                        width: 300,
                        padding: const EdgeInsets.all(16),
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: const Image(
                          image: AssetImage('assets/images/empty_data.jpg'),
                        ))
                    : Container(
                        margin: const EdgeInsets.all(3),
                        width: 450,
                        padding: const EdgeInsets.all(16),
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: SizedBox(
                          width: 400,
                          height: 250,
                          child: LineChart(
                            LineChartData(
                              clipData: FlClipData.all(),
                              maxX: depressionData
                                  .reduce((value, element) =>
                                      value.y > element.y ? value : element)
                                  .y,
                              maxY: 12,
                              minX: 0,
                              minY: 0,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: depressionData,
                                  isCurved: true,
                                  barWidth: 5,
                                  belowBarData: BarAreaData(
                                    show: true,
                                  ),
                                )
                              ],
                              titlesData: FlTitlesData(
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    reservedSize: 18,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      print('??${value}');
                                      return Text(DateFormat.MMMd()
                                          .format(DateTime.now()));
                                    },
                                  ))),
                            ),
                          ),
                        ),
                      ),
          ),
          const SizedBox(height: 10),
          Text('Escala de Trastorno de Ansiedad Generalizada - 7'),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: anxietyData == null
                ? const CircularProgressIndicator()
                : anxietyData.isEmpty
                    ? Container(
                        //color: const Color.fromARGB(255, 230, 230, 230),
                        margin: const EdgeInsets.all(3),
                        width: 300,
                        padding: const EdgeInsets.all(16),
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: const Image(
                          image: AssetImage('assets/images/empty_data.jpg'),
                        ))
                    : Container(
                        margin: const EdgeInsets.all(3),
                        width: 450,
                        padding: const EdgeInsets.all(16),
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: SizedBox(
                          width: 400,
                          height: 250,
                          child: LineChart(
                            LineChartData(
                              clipData: FlClipData.all(),
                              maxX: anxietyData
                                  .reduce((value, element) =>
                                      value.y > element.y ? value : element)
                                  .y,
                              maxY: 12,
                              minX: 0,
                              minY: 0,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: anxietyData,
                                  isCurved: true,
                                  barWidth: 5,
                                  belowBarData: BarAreaData(
                                    show: true,
                                  ),
                                )
                              ],
                              titlesData: FlTitlesData(
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    reservedSize: 18,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      print('??${value}');
                                      return Text(DateFormat.MMMd()
                                          .format(DateTime.now()));
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

  Future<List<Map<String, dynamic>>> getResultDepression() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference anxxietyRef = FirebaseFirestore.instance
        .collection('depressiontest')
        .doc(userId)
        .collection('history');
    QuerySnapshot querySnapshot = await anxxietyRef.get();
    List<Map<String, dynamic>> history = [];
    querySnapshot.docs.forEach((response) {
      Map<String, dynamic> data = response.data() as Map<String, dynamic>;
      history.add({
        'score': data['score'],
        'date': data['date'],
      });
    });
    return history;
  }

  Future<List<Map<String, dynamic>>> getResultAnxiety() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference anxxietyRef = FirebaseFirestore.instance
        .collection('anxietytest')
        .doc(userId)
        .collection('history');
    QuerySnapshot querySnapshot = await anxxietyRef.get();
    List<Map<String, dynamic>> history = [];
    for (var response in querySnapshot.docs) {
      Map<String, dynamic> data = response.data() as Map<String, dynamic>;
      history.add({
        'score': data['score'],
        'date': data['date'],
      });
    }
    return history;
  }
}
