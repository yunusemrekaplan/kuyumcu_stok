// ignore_for_file: must_be_immutable
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
  late List<FlSpot> salesChartSpotList;

  List<FlSpot> spots = [];

  @override
  void initState() {
    print(DateTime.now().weekday);

    /*
    // TODO zamanı internetten çek
    /*DateTime now = DateTime.now();
    //DateTime now1 = DateTime.now();
    int year;
    int month;
    int day;
    year = now.year;
    month = now.month - 2;
    day = now.day;
    switch (now.month) {
      case 1:
        year = now.year - 1;
        month = 11;
        day = now.day > 30 ? 30 : now.day;
      case 2:
        year = now.year - 1;
        month = 12;
        day = now.day;
      case 4:
        // month = 2;
        bool isDivisibleFour = ((now.year % 4) == 0);
        day = isDivisibleFour
            ? ((now.day > 29) ? 29 : now.day)
            : ((now.day > 28) ? 28 : now.day);
      */
    /*case 5:
        // month = 3;
        day = now.day;
      case 6:
        // month = 4;
        day = now.day;
      case 7:
        // month = 5;
        day = now.day;
      case 8:
        // month = 6;
        day = now.day;
      case 9:
        // month = 7;
        day = now.day;
      case 10:
        // month = 8;
        day = now.day;
      case 11:
        // month = 9;
        day = now.day;
      case 12:
        // month = 10;
        day = now.day;*/
    /*
    }

    DateTime startTime = DateTime(
      year,
      month,
      day,
    );
    DateTime endTime = DateTime.now();*/
    */

    if (ProductSaleDbHelper().sales.isNotEmpty) {
      DateTime lastDate = ProductSaleDbHelper().sales.last.soldDate;
      DateTime firstDate = lastDate.subtract(Duration(days: 7));
      List<ProductSale> filteredSales = ProductSaleDbHelper()
          .sales
          .where((sale) {
            //print(sale.toJson());
            return sale.soldDate.isAfter(firstDate);
          })
          .toList();

      List<List<ProductSale>> chunks = chunkByDate(filteredSales, firstDate, lastDate,);
      //print(chunks);

      List<double> revenues = [];
      List.generate(chunks.length, (i) {
        if (chunks[i].isNotEmpty) {
          double totalRevenue = chunks[i].map((sale) => sale.soldPrice * sale.piece).reduce((a, b) => a + b);
          print(totalRevenue);
          revenues.add(totalRevenue);
        }
        else {
          revenues.add(0);
        }
      });
      print(revenues);
      double minRevenue = revenues.reduce(min);
      double maxRevenue = revenues.reduce(max);
      print('min: $minRevenue');
      print('max: $maxRevenue');
      double scaleRevenue(double revenue) {
        return (revenue - minRevenue) / (maxRevenue - minRevenue) * 6;
      }

      List.generate(revenues.length, (i) {
        spots.add(FlSpot(i.toDouble(), scaleRevenue(revenues[i])));
      });

      print(spots);
    }

    salesChartSpotList = const [];

    //getProducts();
    super.initState();
  }

  List<List<ProductSale>> chunkByDate(List<ProductSale> sales, DateTime startDate, DateTime endDate) {
    List<List<ProductSale>> chunks = [];
    // Başlangıç tarihinden itibaren bir gün arttırarak bitiş tarihine kadar döngü oluştur
    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
      // Sales listesinden o gün satılan ürünleri filtrele
      List<ProductSale>? dailySales = sales.where((sale) => sale.soldDate.day == date.day).toList();
      // Filtrelenen ürünleri chunks listesine ekle
      chunks.add(dailySales);
    }
    return chunks;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
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
                        child: LineChartSample2(
                          spotList: spots,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
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
                        child: LineChartSample2(
                          spotList: salesChartSpotList,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
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
                        child: LineChartSample2(
                          spotList: salesChartSpotList,
                        ),
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
