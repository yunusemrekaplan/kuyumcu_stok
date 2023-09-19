// ignore_for_file: must_be_immutable
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
  List<double> salesChartRevenues = [];
  List<double> tLProfitChartRevenues = [];
  List<double> gramProfitChartRevenues = [];

  @override
  void initState() {
    if (ProductSaleDbHelper().sales.isNotEmpty) {
      DateTime lastDate = DateTime.now();
      String newLastDate = lastDate.toIso8601String();
      List<String> array = newLastDate.split('');
      array[11] = '0';
      array[12] = '0';
      array[14] = '0';
      array[15] = '0';
      array[17] = '0';
      array[18] = '0';

      lastDate = DateTime.parse(array.join().substring(0, 19));

      lastDate = lastDate.add(const Duration(days: 1));
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

      List.generate(chunks.length, (i) {
        if (chunks[i].isNotEmpty) {
          double totalSalesRevenue = chunks[i].map((sale) {
            // print(sale.toJson());
            return sale.soldPrice * sale.piece;
          }).reduce((a, b) => a + b);
          salesChartRevenues.add(totalSalesRevenue);

          double totalTLProfitRevenues = chunks[i]
              .map((sale) => sale.earnedProfitTL * sale.piece)
              .reduce((a, b) => a + b);
          tLProfitChartRevenues.add(totalTLProfitRevenues);
          // print(totalTLProfitRevenues);

          double totalGramProfitRevenues = chunks[i]
              .map((sale) => sale.earnedProfitGram * sale.piece)
              .reduce((a, b) => a + b);
          gramProfitChartRevenues.add(totalGramProfitRevenues);
        } else {
          salesChartRevenues.add(0);
          tLProfitChartRevenues.add(0);
          gramProfitChartRevenues.add(0);
        }
      });
    }

    // print(gramProfitChartRevenues);

    // print(salesChartRevenues);
    // print(tLProfitChartRevenues);
    // print(gramProfitChartRevenues);
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
      // print(date.toIso8601String());
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
                          revenues: salesChartRevenues,
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
                          revenues: tLProfitChartRevenues,
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
                          revenues: gramProfitChartRevenues,
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
