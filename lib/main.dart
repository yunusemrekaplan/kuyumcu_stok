import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/models/product_entry.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_entries_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_sale_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_product_add_screen.dart';
import 'package:kuyumcu_stok/screens/gold_screens/gold_products_inventory_screen.dart';
import 'package:window_manager/window_manager.dart';

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

  /*BarcodeDbHelper().open();
  List<StockGoldProduct> goldProducts = [];
  List<DiamondProduct> diamondProducts = [];

  CurrencyService.getCurrenciesOfHakanAltin().then((value) => {
        StockGoldProductDbHelper().open().then((value) => {
              StockGoldProductDbHelper().queryAllRows().then((value) => {
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
        StockGoldProductDbHelper().stockProducts = goldProducts,
        DiamondProductDbHelper().products = diamondProducts,

      });*/

  GoldProductDbHelper().open().then((value) {
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
        //'/': (BuildContext context) => const HomeScreen(),
        '/gold-products-inventory-screen': (BuildContext context) => const GoldProductsInventoryScreen(),
        '/gold-product-add-screen': (BuildContext context) => const GoldProductAddScreen(),
        '/gold-product-entries-screen': (BuildContext context) => const GoldProductEntriesScreen(),
        '/gold-sale-screen': (BuildContext context) => const GoldProductSaleScreen(),
        //'/gold-products-sold-screen': (BuildContext context) => const GoldProductsSoldScreen(),
        //'/diamond-products-screen': (BuildContext context) => const DiamondProductsScreen(),
        //'/diamond-product-add-screen': (BuildContext context) => const DiamondProductAddScreen(),
      },
      initialRoute: '/gold-products-inventory-screen',
    );
  }
}
