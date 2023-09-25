// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';

class LineChartSample2 extends StatefulWidget {
  LineChartSample2({
    super.key,
    required this.revenues,
    required this.chartName,
  });

  List<double> revenues = [];
  late String chartName;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<FlSpot> spots = [];
  List<String> days = [];
  List<String> values = [];
  List<FlSpot> avgSpotList = [];
  late double avg;

  bool control = false;

  List<Color> gradientColors = [
    Colors.yellow,
    Colors.green,
  ];

  bool showAvg = false;

  @override
  void initState() {
    switch (DateTime.now().weekday) {
      case 1:
        days = ['Salı', 'Çar', 'Per', 'Cuma', 'Cmt', 'Pzr', 'Pzt'];
        break;
      case 2:
        days = ['Çar', 'Per', 'Cuma', 'Cmt', 'Pzr', 'Pzt', 'Salı'];
        break;
      case 3:
        days = ['Per', 'Cuma', 'Cmt', 'Pzr', 'Pzt', 'Salı', 'Çar'];
        break;
      case 4:
        days = ['Cuma', 'Cmt', 'Pzr', 'Pzt', 'Salı', 'Çar', 'Per'];
        break;
      case 5:
        days = ['Cmt', 'Pzr', 'Pzt', 'Salı', 'Çar', 'Per', 'Cuma'];
        break;
      case 6:
        days = ['Pzr', 'Pzt', 'Salı', 'Çar', 'Per', 'Cuma', 'Cmt'];
        break;
      case 7:
        days = ['Pzt', 'Salı', 'Çar', 'Per', 'Cuma', 'Cmt', 'Pzr'];
        break;
    }

    for (var element in widget.revenues) {
      if (element > 0) {
        control = true;
        break;
      }
    }

    if (control) {
      double minRevenue = widget.revenues.reduce(min);
      double maxRevenue = widget.revenues.reduce(max);
      double scaleRevenue(double revenue) {
        return (revenue - minRevenue) / (maxRevenue - minRevenue) * 6;
      }

      List.generate(widget.revenues.length, (i) {
        spots.add(FlSpot(i.toDouble(), scaleRevenue(widget.revenues[i])));
      });

      double scaleRevenueInverse(double scaledRevenue) {
        return (maxRevenue - minRevenue) * scaledRevenue / 6 + minRevenue;
      }

      if (widget.chartName == "Gram Kar Grafiği") {
        List.generate(7, (i) {
          double value = scaleRevenueInverse(i.toDouble());
          //value = value > 0 ? value + 1 : value;
          values.add('${OutputFormatters.buildNumberFormat3f(value)} ');
        });
      } else {
        List.generate(7, (i) {
          double value = scaleRevenueInverse(i.toDouble()) / 1000;
          //value = value > 0 ? value + 1 : value;
          values.add('${OutputFormatters.buildNumberFormat1f(value)}K ');
        });
      }
    }
    if (spots.isNotEmpty) {
      double temp = 0;
      for (var element in spots) {
        temp += element.y;
      }

      avg = temp / spots.length;
      List.generate(spots.length, (i) {
        avgSpotList.add(FlSpot(i.toDouble(), avg));
      });
      //print(avg);
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
            reservedSize: 70,
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
          spots: spots,
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
            reservedSize: 70,
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(days[0], style: style);
        break;
      case 1:
        text = Text(days[1], style: style);
        break;
      case 2:
        text = Text(days[2], style: style);
        break;
      case 3:
        text = Text(days[3], style: style);
        break;
      case 4:
        text = Text(days[4], style: style);
        break;
      case 5:
        text = Text(days[5], style: style);
        break;
      case 6:
        text = Text(days[6], style: style);
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
        text = control ? values[0] : '0K';
        break;
      case 2:
        text = control ? values[2] : '0K';
        break;
      case 4:
        text = control ? values[4] : '0K';
        break;
      case 6:
        text = control ? values[6] : '0K';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }
}
