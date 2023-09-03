import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/enum/extension/route_extension.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_entries_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_sale_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_products_inventory_screen.dart';
import 'package:kuyumcu_stok/screens/home_screen.dart';
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

  await GoldProductDbHelper().open();
  await ProductEntryDbHelper().open();
  await ProductSaleDbHelper().open();

  runApp(const MyApp());

  GoldProductDbHelper().queryAllRows().then((value) {
    for (int i = 0; i < value.length; i++) {
      GoldProductDbHelper().products.add(GoldProduct.fromJson(value[i], value[i]['id']));
    }
    ProductEntryDbHelper().open().then((value) {
      ProductEntryDbHelper().queryAllRows().then((value) {
        for (int i = 0; i < value.length; i++) {
          ProductEntryDbHelper().entries.add(ProductEntry.fromJson(value[i], value[i]['id']));
        }
        runApp(const MyApp());
      });
    });
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
    Routes initialRoute = Routes.homeScreen;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainThemeData,
      routes: {
        Routes.homeScreen.nameDefinition: (BuildContext context) => const HomeScreen(),
        Routes.goldProductsInventoryScreen.nameDefinition: (BuildContext context) => const GoldProductsInventoryScreen(),
        Routes.goldProductAddScreen.nameDefinition: (BuildContext context) => const GoldProductAddScreen(),
        Routes.goldProductEntriesScreen.nameDefinition: (BuildContext context) => const GoldProductEntriesScreen(),
        Routes.goldSaleScreen.nameDefinition: (BuildContext context) => const GoldProductSaleScreen(),
        //'/gold-products-sold-screen': (BuildContext context) => const GoldProductsSoldScreen(),
        //'/diamond-products-screen': (BuildContext context) => const DiamondProductsScreen(),
        //'/diamond-product-add-screen': (BuildContext context) => const DiamondProductAddScreen(),
      },
      initialRoute: initialRoute.nameDefinition,
    );
  }
}
