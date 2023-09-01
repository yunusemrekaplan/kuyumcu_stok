// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;

  String gold = '....';

  @override
  void initState() {
    //gold = CurrencyService.fineGoldSale.toString();
    CurrencyService.getCurrenciesOfHakanAltin().then(
      (value) => setState(
        () {
          gold = value['fineGoldSale']!.toString();
          print(value);
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return const Center(
        child: Text(
          "Bir hata oluştu. Lütfen daha sonra tekrar deneyin.",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    };*/
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await CurrencyService.getCurrenciesOfSaglamoglu().then((value) => print(value.toString()));
                /*await BarcodeService.generateBarcode(BarcodeService.generateCode()).then((value) => () {
                  print(value.toJson())});*/
                },
              child: const Text(
                'Altın',
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            Text(
              gold,
              style: const TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
