// ignore_for_file: must_be_immutable
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/enum/my_error.dart';
import 'package:kuyumcu_stok/line_chart.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/log.dart';
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
  List<String> days = [];
  List<String> values = [];

  @override
  void initState() {
    if (ProductSaleDbHelper().sales.isNotEmpty) {
      DateTime lastDate = ProductSaleDbHelper().sales.last.soldDate;
      DateTime firstDate = lastDate.subtract(const Duration(days: 7));
      List<ProductSale> filteredSales =
          ProductSaleDbHelper().sales.where((sale) {
        // print(sale.toJson());
        return sale.soldDate.isAfter(firstDate);
      }).toList();

      List<List<ProductSale>> chunks = chunkByDate(
        filteredSales,
        firstDate,
        lastDate,
      );

      List<double> revenues = [];
      List.generate(chunks.length, (i) {
        if (chunks[i].isNotEmpty) {
          double totalRevenue = chunks[i]
              .map((sale) => sale.soldPrice * sale.piece)
              .reduce((a, b) => a + b);
          revenues.add(totalRevenue);
        } else {
          revenues.add(0);
        }
      });

      double minRevenue = revenues.reduce(min);
      double maxRevenue = revenues.reduce(max);
      double scaleRevenue(double revenue) {
        return (revenue - minRevenue) / (maxRevenue - minRevenue) * 6;
      }

      List<double> newRevenues = [];

      switch (DateTime.now().weekday) {
        case 1:
          days = ['Salı', 'Çar', 'Per', 'Cuma', 'Cmt', 'Pzr', 'Pzt'];
          newRevenues = [
            revenues[1],
            revenues[2],
            revenues[3],
            revenues[4],
            revenues[5],
            revenues[6],
            revenues[0]
          ];
      }

      revenues.sort((a, b) => a.compareTo(b));

      List.generate(revenues.length, (i) {
        int tempInt = revenues[i] ~/ 1000;
        double tempDouble = revenues[i] / 1000;
        bool control = (tempDouble - tempInt) > 0.5;
        tempInt = tempInt > 0 ? tempInt + 1 : tempInt;
        values.add('${tempInt}K');
      });

      List.generate(revenues.length, (i) {
        spots.add(FlSpot(i.toDouble(), scaleRevenue(newRevenues[i])));
      });

      // print(spots);
    }

    salesChartSpotList = const [];

    //getProducts();
    super.initState();
  }

  List<List<ProductSale>> chunkByDate(
      List<ProductSale> sales, DateTime startDate, DateTime endDate) {
    List<List<ProductSale>> chunks = [];
    // Başlangıç tarihinden itibaren bir gün arttırarak bitiş tarihine kadar döngü oluştur
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      // Sales listesinden o gün satılan ürünleri filtrele
      List<ProductSale>? dailySales =
          sales.where((sale) => sale.soldDate.day == date.day).toList();
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
                padding: buildEdgeInsets(),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 425,
                        height: 280,
                        //color: Colors.white,
                        child: LineChartSample2(
                          chartName: 'Satış Grafiği',
                          spotList: spots,
                          days: days,
                          values: values,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: buildEdgeInsets(),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 425,
                        height: 280,
                        //color: Colors.white,
                        child: LineChartSample2(
                          chartName: 'TL Kar Grafiği',
                          spotList: salesChartSpotList,
                          days: days,
                          values: values,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: buildEdgeInsets(),
                child: SizedBox(
                  width: 400,
                  height: 290,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 425,
                        height: 280,
                        //color: Colors.white,
                        child: LineChartSample2(
                          chartName: 'Gram Kar Grafiği',
                          spotList: salesChartSpotList,
                          days: days,
                          values: values,
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

  EdgeInsets buildEdgeInsets() {
    return const EdgeInsets.only(
      left: 10.0,
      top: 15.0,
      right: 10.0,
      bottom: 15.0,
    );
  }
}
