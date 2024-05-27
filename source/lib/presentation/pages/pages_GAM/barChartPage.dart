import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarChartPage extends StatelessWidget {
  const BarChartPage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
      future: _getDataFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final barGroups = snapshot.data ?? [];

        return BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: borderData,
            barGroups: barGroups,
            gridData: const FlGridData(show: false),
            alignment: BarChartAlignment.spaceAround,
            maxY: 25,
          ),
        );
      },
    );
  }

  Future<List<BarChartGroupData>> _getDataFromDatabase() async {
    final regionsData = await _fetchDataFromFirestore();
    final Map<String, int> regionsCount = {
      'Abruzzo': 0, 'Basilicata': 0, 'Calabria': 0, 'Campania': 0, 'Emilia-Romagna': 0,
      'Friuli-Venezia Giulia': 0, 'Lazio': 0, 'Liguria': 0, 'Lombardia': 0, 'Marche': 0,
      'Molise': 0, 'Piemonte': 0, 'Puglia': 0, 'Sardegna': 0, 'Sicilia': 0, 'Toscana': 0,
      'Trentino-Alto Adige': 0, 'Umbria': 0, "Valle d'Aosta": 0, 'Veneto': 0
    };

    regionsData.forEach((data) {
      final region = data['RegioneDenunciante'] as String?;
      if (region != null && regionsCount.containsKey(region)) {
        regionsCount[region] = (regionsCount[region] ?? 0) + 1;
      }
    });

    final List<BarChartGroupData> barGroups = [];
    int index = 0;
    regionsCount.forEach((region, count) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
      index++;
    });

    return barGroups;
  }

  Future<List<Map<String, dynamic>>> _fetchDataFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('Denuncia').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 150,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue[800],
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    List<String> regions = [
      'Abruzzo', 'Basilicata', 'Calabria', 'Campania', 'Emilia-Romagna',
      'Friuli-Venezia Giulia', 'Lazio', 'Liguria', 'Lombardia', 'Marche',
      'Molise', 'Piemonte', 'Puglia', 'Sardegna', 'Sicilia', 'Toscana',
      'Trentino-Alto Adige', 'Umbria', "Valle d'Aosta", 'Veneto'
    ];
    String text = '';
    if (value.toInt() >= 0 && value.toInt() < regions.length) {
      text = regions[value.toInt()];
    }
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: RotatedBox(
        quarterTurns: 3,
        child: Text(
            text,
            style: style,
            textAlign: TextAlign.right
        ),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.blue[800]!,
      Colors.cyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
