import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartSample extends StatefulWidget {
  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<FlSpot> _chartData = [];

  @override
  void initState() {
    super.initState();
    _getDataFromFirestore();
  }

  void _getDataFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('my_collection')
        .get();

    setState(() {
      _chartData = snapshot.docs.map((doc) {
        final data = doc.data();
        return FlSpot(data['x'], data['y']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: _chartData,
          ),
        ],
      ),
    );
  }
}