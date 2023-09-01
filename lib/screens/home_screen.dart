// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kuyumcu_stok/line_chart.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      backgroundColor: backgroundColor,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Satış Grafiği',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        width: 425,
                        height: 250,
                        //color: Colors.white,
                        child: LineChartSample2(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'TL Kar Grafiği',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        width: 425,
                        height: 250,
                        //color: Colors.white,
                        child: LineChartSample2(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Gram Kar Grafiği',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        width: 425,
                        height: 250,
                        //color: Colors.white,
                        child: LineChartSample2(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
