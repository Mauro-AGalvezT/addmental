import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultTestView extends StatefulWidget {
  static String id = "resultest_view";
  const ResultTestView({super.key});

  @override
  State<ResultTestView> createState() => _ResultTestViewState();
}

class _ResultTestViewState extends State<ResultTestView> {
  List<FlSpot> anxietyData = [];
  List<FlSpot> depressionData = [];
  @override
  void initState() {
    super.initState();
    _getDataFromFirestore();
  }

  Future<void> _getDataFromFirestore() async {
    List<Map<String, dynamic>> depressionResult = await getResultDepression();
    List<Map<String, dynamic>> anxietyResult = await getResultAnxiety();

    setState(() {
      if (depressionResult.isNotEmpty) {
        for (var test in depressionResult) {
          var date = DateTime.parse(test['date']);
          var yTimestamp = date.millisecondsSinceEpoch.toDouble();
          depressionData.add(FlSpot(yTimestamp, test['score'].toDouble()));
        }
        depressionData.sort((a, b) => a.x.compareTo(b.x));
      } else {
        if (kDebugMode) {
          print('No existen datos.');
        }
      }
      if (anxietyResult.isNotEmpty) {
        for (var test in anxietyResult) {
          var date = DateTime.parse(test['date']);
          var yTimestamp = date.millisecondsSinceEpoch.toDouble();
          anxietyData.add(FlSpot(yTimestamp, test['score'].toDouble()));
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
          const Text('Cuestionario sobre la salud del paciente-9'),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // ignore: unnecessary_null_comparison
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
                              maxY: 30,
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
          const Text('Escala de Trastorno de Ansiedad Generalizada - 7'),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // ignore: unnecessary_null_comparison
            child: anxietyData == null
                ? const CircularProgressIndicator()
                : anxietyData.isEmpty
                    ? Container(
                        margin: const EdgeInsets.all(3),
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
                              maxY: 22,
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
    for (var response in querySnapshot.docs) {
      Map<String, dynamic> data = response.data() as Map<String, dynamic>;
      history.add({
        'score': data['score'],
        'date': data['date'],
      });
    }
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
