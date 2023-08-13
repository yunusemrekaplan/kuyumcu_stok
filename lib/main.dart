
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/diamond_product_db_helper.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/models/diamond_product.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/screens/diamond_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/diamond_products_screen.dart';
import 'package:kuyumcu_stok/screens/home_screen.dart';
import 'package:kuyumcu_stok/screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_products_screen.dart';
import 'package:kuyumcu_stok/screens/gold_sale_screen.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1080, 720),
    minimumSize: Size(1120, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await BarcodeDbHelper().open();
  await GoldProductDbHelper().open();
  await DiamondProductDbHelper().open();
  await CurrencyService.getGoldPrices();

  var goldList = await GoldProductDbHelper().queryAllRows().then((value) => value);
  List<GoldProduct> goldProducts = [];

  var diamondList = await DiamondProductDbHelper().queryAllRows().then((value) => value);
  List<DiamondProduct> diamondProducts = [];

  for(int i=0; i<goldList.length; i++) {
    goldProducts.add(GoldProduct.fromJson(goldList[i], goldList[i]['id']));
  }
  GoldProductDbHelper().products = goldProducts;

  for(int i=0; i<diamondList.length; i++) {
    diamondProducts.add(DiamondProduct.fromJson(diamondList[i]));
  }
  DiamondProductDbHelper().products = diamondProducts;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routes: {
        '/': (BuildContext context) => const HomeScreen(),
        '/gold-products-screen': (BuildContext context) => const GoldProductsScreen(),
        '/diamond-products-screen': (BuildContext context) => const DiamondProductsScreen(),
        '/gold-sale-screen': (BuildContext context) => const GoldSaleScreen(),
        '/gold-product-add-screen': (BuildContext context) => const GoldProductAddScreen(),
        '/diamond-product-add-screen': (BuildContext context) => const DiamondProductAddScreen(),
      },
      initialRoute: '/',
    );
  }
}