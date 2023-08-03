import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/data/barcode_db_helper.dart';
import 'package:kuyumcu_stok/data/product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/product.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];

  ProductDbHelper productDbHelper = ProductDbHelper();

  /*
      productDbHelper.queryAllRows().then(
          (value) => {
        value.map((e) => products.add(Product.fromJson(e))),
        //Navigator.of(context).pop(),
      },
    );
   */
  /*
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
   */
  @override
  void initState() {
    ProductDbHelper().queryAllRows().then(
          (value) => {
            value.map((e) => products.add(Product.fromJson(e))),
            print(products.length),
          },
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('İsim')),
                        DataColumn(label: Text('Gram')),
                        DataColumn(label: Text('Karat')),
                        DataColumn(label: Text('Maliyet')),
                      ],
                      rows: ProductDbHelper().products
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(Text(e.name!)),
                                DataCell(Text(e.gram.toString())),
                                DataCell(Text(e.carat.intDefinition.toString())),
                                DataCell(Text(e.costPrice.toString())),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1050,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/product-add-screen', (route) => false);
                  },
                  child: Text('Ürün Ekle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
