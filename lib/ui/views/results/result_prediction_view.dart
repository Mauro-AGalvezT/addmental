import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class ResultPredictionView extends StatefulWidget {
  static String id = "resultprediction_view";
  const ResultPredictionView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResultPredictionViewState createState() => _ResultPredictionViewState();
}

class _ResultPredictionViewState extends State<ResultPredictionView> {
  List<FlSpot> depressionData = [];
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
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
              child: Container(
                height: 300,
                width: 350,
                child: BarChart(
                  BarChartData(
                    maxY: 3,
                    titlesData: FlTitlesData(
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('Lun');
                                case 1:
                                  return const Text('Mar');
                                case 2:
                                  return const Text('Mie');
                                case 3:
                                  return const Text('Jue');
                                case 4:
                                  return const Text('Vie');
                                case 5:
                                  return const Text('Sab');
                                case 6:
                                  return const Text('Dom');
                                default:
                                  return const Text('');
                              }
                            }),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            color: Colors.blue,
                            toY: 1,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            color: Colors.blue,
                            toY: 2,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            color: Colors.red,
                            toY: 3,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            color: Colors.blue,
                            toY: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 10),
          const Text('Topicos de ansiedad'),
          const SizedBox(height: 10),
          Container(
            width: 350,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.4,
            child: BarChart(
              BarChartData(
                maxY: 3,
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Lun');
                            case 1:
                              return const Text('Mar');
                            case 2:
                              return const Text('Mie');
                            case 3:
                              return const Text('Jue');
                            case 4:
                              return const Text('Vie');
                            case 5:
                              return const Text('Sab');
                            case 6:
                              return const Text('Dom');
                            default:
                              return const Text('');
                          }
                        }),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        color: Colors.blueAccent,
                        toY: 0,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        color: Colors.blueAccent,
                        toY: 2,
                      )
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        color: Colors.red,
                        toY: 3,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        color: Colors.blueAccent,
                        toY: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
