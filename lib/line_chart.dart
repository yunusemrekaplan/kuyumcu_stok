// ignore_for_file: must_be_immutable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/app_colors.dart';

class LineChartSample2 extends StatefulWidget {
  LineChartSample2({
    super.key,
    required this.spotList,
    required this.days,
    required this.values,
    required this.chartName,
  });

  late String chartName;
  late List<FlSpot> spotList;
  late List<String> days;
  late List<String> values;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  late List<FlSpot> avgSpotList;
  late double avg;

  List<Color> gradientColors = [
    Colors.yellow,
    Colors.green,
  ];

  bool showAvg = false;

  @override
  void initState() {
    avgSpotList = [];

    if (widget.spotList.isNotEmpty) {
      double temp = 0;
      for (var element in widget.spotList) {
        temp += element.y;
      }

      avg = temp / widget.spotList.length;
      List.generate(widget.spotList.length, (i) {
        avgSpotList.add(FlSpot(i.toDouble(), avg));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  showAvg = false;
                });
              },
              child: Text(
                widget.chartName,
                style: TextStyle(
                  fontSize: 28,
                  color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                ),
              ),
            ),
            const Text(
              '-',
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showAvg = true;
                });
              },
              child: Text(
                'Ort',
                style: TextStyle(
                  fontSize: 28,
                  color: showAvg ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white38,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white38,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white38),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: widget.spotList,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white38,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white38,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white38),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: avgSpotList,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(widget.days[0], style: style);
        break;
      case 1:
        text = Text(widget.days[1], style: style);
        break;
      case 2:
        text = Text(widget.days[2], style: style);
        break;
      case 3:
        text = Text(widget.days[3], style: style);
        break;
      case 4:
        text = Text(widget.days[4], style: style);
        break;
      case 5:
        text = Text(widget.days[5], style: style);
        break;
      case 6:
        text = Text(widget.days[6], style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white,
    );
    String text = '';
    switch (value.toInt()) {
      case 0:
        text = widget.values[0];
        break;
      case 2:
        if(widget.spotList.isEmpty) {
          break;
        }
        for (int i=1; i<widget.spotList.length; i++) {
          if (widget.spotList[i].y <= value && widget.spotList[i].y >= value - 1) {
            text = widget.values[i];
            print('spot: ${widget.spotList[i].y}');
            break;
            //print('value: ${value} spot: ${widget.spotList[i].y} i: ${i}');
          }
        }
        break;
      case 4:
        if(widget.spotList.isEmpty) {
          break;
        }
        for (int i=4; i<widget.spotList.length; i++) {
          if (widget.spotList[i-1].y >= value) {
            text = widget.values[i];
            // print('value: ${value} spot: ${widget.spotList[i].y} i: ${i}');
            //break;
          }
        }
        break;
      case 6:
        text = widget.values[6];
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
