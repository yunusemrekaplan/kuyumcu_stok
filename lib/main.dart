
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/product_diamond_db_helper.dart';
import 'package:kuyumcu_stok/data/product_gold_db_helper.dart';
import 'package:kuyumcu_stok/models/product_gold.dart';
import 'package:kuyumcu_stok/screens/diamond_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/diamond_products_screen.dart';
import 'package:kuyumcu_stok/screens/home_screen.dart';
import 'package:kuyumcu_stok/screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_products_screen.dart';
import 'package:kuyumcu_stok/screens/sale_screen.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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
  await ProductGoldDbHelper().open();
  await ProductDiamondDbHelper().open();
  await GoldService.getGoldPrices();

  var list = await ProductGoldDbHelper().queryAllRows().then((value) => value);
  List<ProductGold> products = [];

  for(int i=0; i<list.length; i++) {
    products.add(ProductGold.fromJson(list[i], list[i]['id']));
  }
  ProductGoldDbHelper().products = products;

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
        '/sale-screen': (BuildContext context) => const SaleScreen(),
        '/gold-product-add-screen': (BuildContext context) => const GoldProductAddScreen(),
        '/diamond-product-add-screen': (BuildContext context) => const DiamondProductAddScreen(),
      },
      initialRoute: '/',
    );
  }
}