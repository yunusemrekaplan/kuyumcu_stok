// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/enum/my_error.dart';
import 'package:kuyumcu_stok/line_chart.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/log.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:kuyumcu_stok/widgets/show_dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getProducts();
    ProductEntryDbHelper().queryAllRows().then((value) {
      for (int i = 0; i < value.length; i++) {
        ProductEntryDbHelper()
            .entries
            .add(ProductEntry.fromJson(value[i], value[i]['id']));
      }
    });
    ProductSaleDbHelper().queryAllRows().then((value) {
      for (int i = 0; i < value.length; i++) {
        ProductSaleDbHelper()
            .sales
            .add(ProductSale.fromJson(value[i], value[i]['id']));
      }
    });
    super.initState();
  }

  void getProducts() {
    try {
      GoldProductDbHelper().queryAllRows().then((value) {
        for (int i = 0; i < value.length; i++) {
          GoldProductDbHelper()
              .products
              .add(GoldProduct.fromJson(value[i], value[i]['id']));
        }
      });
    } catch (e) {
      Log log = Log(
        dateTime: DateTime.now(),
        state: MyError.dataBaseQueryAllRows,
        errorMessage: e.toString(),
      );

      String errorMessage =
          'Ürünleri veritabanından çekerken bir hata oluştur!';
      ShowDialogs().errorShowDialog(context, errorMessage);
    }
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
