import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({super.key});

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late Widget _body;

  @override
  void initState() {
    //_body = loadingScreen();
    //delayFunction();
    super.initState();
  }

  void delayFunction() {
    Future.delayed(
      const Duration(seconds: 0),
      () {
        setState(() {
          _body = Center(
            child: Image.file(
              File("C:\\FlutterProjects\\kuyumcu_stok\\isbn.png"),
              width: 200,
              height: 200,
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Image.file(
                  File("C:\\FlutterProjects\\kuyumcu_stok\\isbn.png"),
                  width: 300,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
      ),//_body,
    );
  }

  Widget loadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LoadingAnimationWidget.fourRotatingDots(color: Colors.red, size: 80),
        ],
      ),
    );
  }
}
