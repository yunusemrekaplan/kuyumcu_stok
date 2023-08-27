import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/diamond_product_db_helper.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/models/diamond_product.dart';
import 'package:kuyumcu_stok/models/stock_gold_product.dart';
import 'package:kuyumcu_stok/screens/diamond_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/diamond_products_screen.dart';
import 'package:kuyumcu_stok/screens/gold_products_sold_screen.dart';
import 'package:kuyumcu_stok/screens/home_screen.dart';
import 'package:kuyumcu_stok/screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_products_inventory_screen.dart';
import 'package:kuyumcu_stok/screens/gold_sale_screen.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1120, 740),
    minimumSize: Size(1120, 740),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  BarcodeDbHelper().open();
  List<StockGoldProduct> goldProducts = [];
  List<DiamondProduct> diamondProducts = [];

  CurrencyService.getCurrenciesOfHakanAltin().then((value) => {
        GoldProductDbHelper().open().then((value) => {
              GoldProductDbHelper().queryAllRows().then((value) => {
                    for (int i = 0; i < value.length; i++)
                      {
                        goldProducts.add(
                            StockGoldProduct.fromJson(value[i], value[i]['id'])),
                      }
                  }),
            }),
        DiamondProductDbHelper().open().then((value) => {
              DiamondProductDbHelper().queryAllRows().then((value) => {
                    for (int i = 0; i < value.length; i++)
                      {
                        diamondProducts.add(DiamondProduct.fromJson(value[i])),
                      }
                  }),
            }),
        GoldProductDbHelper().products = goldProducts,
        DiamondProductDbHelper().products = diamondProducts,
        runApp(const MyApp()),
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return Center(
        child: Text(
          "Bir hata oluştu. Lütfen daha sonra tekrar deneyin.",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    };*/
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      routes: {
        '/': (BuildContext context) => const HomeScreen(),
        '/gold-products-inventory-screen': (BuildContext context) =>
            const GoldProductsInventoryScreen(),
        '/gold-products-sold-screen': (BuildContext context) =>
            const GoldProductsSoldScreen(),
        '/diamond-products-screen': (BuildContext context) =>
            const DiamondProductsScreen(),
        '/gold-sale-screen': (BuildContext context) => const GoldSaleScreen(),
        '/gold-product-add-screen': (BuildContext context) =>
            const GoldProductAddScreen(),
        '/diamond-product-add-screen': (BuildContext context) =>
            const DiamondProductAddScreen(),
      },
      initialRoute: '/',
    );
  }
}
