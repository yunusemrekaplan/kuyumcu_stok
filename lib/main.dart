import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/extension/route_extension.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_entries_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_sale_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_products_inventory_screen.dart';
import 'package:kuyumcu_stok/screens/home_screen.dart';
import 'package:window_manager/window_manager.dart';
import 'package:kuyumcu_stok/enum/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    title: 'Kuyumcu Stok Takibi',
    //size: Size(1500, 740),
    //minimumSize: Size(1500, 740),
    size: Size(1360, 680),
    minimumSize: Size(1360, 680),
    center: true,
    //fullScreen: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await GoldProductDbHelper().open();
  await ProductEntryDbHelper().open();

  /*GoldProductDbHelper().queryAllRows().then((value) {
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
  });*/
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
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2b384a),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 36,
          ),
        ),
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      routes: {
        '/home-screen': (BuildContext context) => const HomeScreen(),
        '/gold-products-inventory-screen': (BuildContext context) => const GoldProductsInventoryScreen(),
        '/gold-product-add-screen': (BuildContext context) => const GoldProductAddScreen(),
        '/gold-product-entries-screen': (BuildContext context) => const GoldProductEntriesScreen(),
        '/gold-sale-screen': (BuildContext context) => const GoldProductSaleScreen(),
        //'/gold-products-sold-screen': (BuildContext context) => const GoldProductsSoldScreen(),
        //'/diamond-products-screen': (BuildContext context) => const DiamondProductsScreen(),
        //'/diamond-product-add-screen': (BuildContext context) => const DiamondProductAddScreen(),
      },
      initialRoute: initialRoute.nameDefinition,
    );
  }
}
