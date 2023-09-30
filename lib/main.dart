import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/enum/extension/route_extension.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_entries_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_sale_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_sales_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_products_inventory_screen.dart';
import 'package:kuyumcu_stok/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kuyumcu_stok/enum/routes.dart';
import 'package:kuyumcu_stok/options/window_options.dart';
import 'package:kuyumcu_stok/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await GoldProductDbHelper().open();
  await ProductEntryDbHelper().open();
  await ProductSaleDbHelper().open();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

    Routes initialRoute = Routes.homeScreen;

    return MaterialApp(
      title: 'Kuyumcu Stok Takibi',
      theme: mainThemeData,
      routes: {
        Routes.homeScreen.nameDefinition: (BuildContext context) =>
            const HomeScreen(),
        Routes.goldProductsInventoryScreen.nameDefinition:
            (BuildContext context) => const GoldProductsInventoryScreen(),
        Routes.goldProductAddScreen.nameDefinition: (BuildContext context) =>
            const GoldProductAddScreen(),
        Routes.goldProductEntriesScreen.nameDefinition:
            (BuildContext context) => const GoldProductEntriesScreen(),
        Routes.goldSaleScreen.nameDefinition: (BuildContext context) =>
            const GoldProductSaleScreen(),
        Routes.goldProductSalesScreen.nameDefinition: (BuildContext context) =>
            const GoldProductSalesScreen(),
      },
      initialRoute: initialRoute.nameDefinition,
    );
  }
}
