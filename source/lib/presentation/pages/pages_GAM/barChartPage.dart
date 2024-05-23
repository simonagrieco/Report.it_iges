import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarChartPage extends StatelessWidget {
  const BarChartPage();

  @override
  Widget build(BuildContext context) {
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

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue[800],
      fontWeight: FontWeight.bold,
      fontSize: 10,
      //height: 2,
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
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0), // Aggiunge il margine sopra e sotto
      child: RotatedBox(
        quarterTurns: 3, // Ruota il testo di 90 gradi in senso antiorario
        child: Text(
            text,
            style: style,
            textAlign: TextAlign.right
        ),
      ),
    );
  }

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

  List<BarChartGroupData> get barGroups {
    List<int> yValues = [
      8, 10, 14, 15, 13, 10, 16, 12, 18, 11, 9, 14, 13, 10, 8, 15, 17, 9, 7, 20
    ];

    return List.generate(yValues.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: yValues[index].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}