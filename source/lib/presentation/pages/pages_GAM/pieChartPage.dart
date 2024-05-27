import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  final String regionName;

  const PieChartPage({required this.regionName, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartPage> {
  int touchedIndex = -1;
  Map<String, int> categoryData = {};

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Denuncia')
          .where('RegioneDenunciante', isEqualTo: widget.regionName)
          .get();

      Map<String, int> categoryCount = {};
      for (var doc in querySnapshot.docs) {
        String category = doc['CategoriaDenuncia'];
        if (categoryCount.containsKey(category)) {
          categoryCount[category] = categoryCount[category]! + 1;
        } else {
          categoryCount[category] = 1;
        }
      }
      setState(() {
        categoryData = categoryCount;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AspectRatio(
        aspectRatio: 0.9,
        child: Container(
          color: Colors.white60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text('Categorie Denunce in ${widget.regionName}',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Expanded(
                child: Row(
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: _buildPieChartSections(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categoryData.keys.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Indicator(
                          color: _getColorForCategory(category),
                          text: category,
                          isSquare: true,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    List<PieChartSectionData> sections = [];
    categoryData.forEach((category, count) {
      final isTouched = sections.length == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      sections.add(
        PieChartSectionData(
          color: _getColorForCategory(category),
          value: count.toDouble(),
          title: '$count',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        ),
      );
    });
    return sections;
  }

  Color _getColorForCategory(String category) {
    final colors = [
      AppColors.contentColorBlue,
      AppColors.contentColorYellow,
      AppColors.contentColorPurple,
      AppColors.contentColorGreen,
      Color(0xffFF5733),
      Color(0xffA569BD),
      Color(0xffFFC300),
      Color(0xffDAF7A6),
      Color(0xffC70039),
      Color(0xff900C3F),
      Color(0xff2980B9),
      Color(0xff6C3483),
    ];
    return colors[categoryData.keys.toList().indexOf(category) % colors.length];
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class AppColors {
  static const Color contentColorBlue = Color(0xff0293ee);
  static const Color contentColorYellow = Color(0xfff8b250);
  static const Color contentColorPurple = Color(0xff845bef);
  static const Color contentColorGreen = Color(0xff13d38e);
  static const Color mainTextColor1 = Color(0xff000000);
}
