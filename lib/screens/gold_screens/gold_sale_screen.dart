import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/models/product_sale.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldSaleScreen extends StatefulWidget {
  const GoldSaleScreen({super.key});

  @override
  State<GoldSaleScreen> createState() => _GoldSaleScreenState();
}

class _GoldSaleScreenState extends State<GoldSaleScreen> {
  String? earningRate;
  String fineGoldBuy = '.......';
  String fineGoldSale = '.......';
  String usdBuy = '.......';
  String usdSale = '.......';
  String eurBuy = '.......';
  String eurSale = '.......';
  String caratTxt = '..';
  String gramTxt = '..';
  String costTxt = '....';
  String costPriceTxt = '....';

  GoldProduct? product;

  TextEditingController barcodeTextEditingController = TextEditingController();
  TextEditingController earningRateTextEditingController =
      TextEditingController();
  TextEditingController saleTextEditingController = TextEditingController();

  @override
  void initState() {
    CurrencyService.getCurrenciesOfHakanAltin().then(
      (value) => setState(
        () {
          buildCurrencies(value);
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: _buildLeftOfBody(),
        ),
        _buildRightOfBody(),
      ],
    );
  }

  Column _buildLeftOfBody() {
    return Column(
      children: [
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: _buildBarcodeAndEarningRateRow(),
        ),
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: _buildProductInformationRow(),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: _buildSaleRow(),
        ),
      ],
    );
  }

  Row _buildBarcodeAndEarningRateRow() {
    return Row(
      children: [
        // Barcode TextFormField
        _buildBarcodeRow(),
        // Earning Rate TextFormField
        _buildEarningRateRow(),
        // Calculation button
        _buildCalculatingButton()
      ],
    );
  }

  SizedBox _buildBarcodeRow() {
    return SizedBox(
      width: 420,
      height: 28,
      //color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _buildBarcodeText(),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: _buildBarcodeTextFormField(),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildBarcodeText() {
    return const SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          'Barkod:',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  SizedBox _buildBarcodeTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: barcodeTextEditingController,
        cursorHeight: 18,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          border: UnderlineInputBorder(),
          //hintText: '9789756249840',
        ),
        style: const TextStyle(
          fontSize: 20,
          height: 1,
        ),
        onChanged: onSearch,
      ),
    );
  }

  SizedBox _buildEarningRateRow() {
    return SizedBox(
      width: 180,
      height: 28,
      //color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.only(left: 45.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _buildEarningRateText(),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: _buildEarningRateTextFormField(),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildEarningRateText() {
    return const SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          'Kar %:',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  SizedBox _buildEarningRateTextFormField() {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: earningRateTextEditingController,
        cursorHeight: 18,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          border: UnderlineInputBorder(),
          //hintText: '9789756249840',
        ),
        style: const TextStyle(
          fontSize: 20,
          height: 1,
        ),
        onFieldSubmitted: (value) => onCalculateProfit(),
      ),
    );
  }

  Padding _buildCalculatingButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: ElevatedButton(
        onPressed: onCalculateProfit,
        child: const Text(
          'Hesapla',
          style: TextStyle(
            fontSize: 20,
            height: 1,
          ),
        ),
      ),
    );
  }

  void onCalculateProfit() {
    int? earningRate = int.tryParse(earningRateTextEditingController.text);
    if (earningRate != null) {
      if (product != null) {
        setState(() {
          saleTextEditingController
              .text = NumberFormat('#,##0.0', 'tr_TR').format((double.parse(
                  (product!.cost * CurrencyService.fineGoldSale).toString()) +
              (double.parse((product!.cost * CurrencyService.fineGoldSale)
                      .toString()) *
                  earningRate /
                  100)));
        });
      }
    }
  }

  Row _buildProductInformationRow() {
    return Row(
      children: [
        // Carat of product
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 34),
          child: Row(
            children: [
              const Text(
                'Karat: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                caratTxt,
                style: const TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 34),
          child: Row(
            children: [
              const Text(
                'Gram: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                gramTxt,
                style: const TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 34),
          child: Row(
            children: [
              const Text(
                'Maliyet: ',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                width: 116,
                child: Text(
                  costTxt,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 34),
          child: Row(
            children: [
              const Text(
                'Maliyet Fiyatı: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                costPriceTxt,
                style: const TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Align _buildSaleRow() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSalePriceTextAndForm(),
            _buildSaleButton(),
            _buildRefreshButton()
          ],
        ),
      ),
    );
  }

  Padding _buildSalePriceTextAndForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 80),
      child: Row(
        children: [
          const Text(
            'Satış Ücreti: ',
            style: TextStyle(fontSize: 22),
          ),
          TextFormField(
            controller: saleTextEditingController,
            cursorHeight: 18,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              border: const UnderlineInputBorder(),
              constraints: BoxConstraints.tight(const Size(115, 29)),
              //hintText: '9789756249840',
            ),
            style: const TextStyle(
              fontSize: 22,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildSaleButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 80),
      child: ElevatedButton(
        onPressed: onSale,
        child: const Text(
          'Satışı Onayla',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  void onSale() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    product!.piece -= 1;
    GoldProductDbHelper()
        .update(product!.toJson(), product!.id)
        .then((value) => {
          ProductSale(product: product!.toJson(), soldDate: DateTime.now(), piece: int.parse(pieceController.text), costPrice: costPrice, soldPrice: soldPrice, soldGram: soldGram, earnedProfitTL: earnedProfitTL, earnedProfitGram: earnedProfitGram)
              Navigator.of(context).pop(),
              print(product!.toJson()),
              setState(() {
                caratTxt = '..';
                gramTxt = '..';
                costTxt = '....';
                costPriceTxt = '....';
                barcodeTextEditingController.text = '';
                earningRateTextEditingController.text = '';
                saleTextEditingController.text = '';
              }),
            });
  }

  Flexible _buildRefreshButton() {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 80),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  CurrencyService.getCurrenciesOfHakanAltin().then(
                    (value) => setState(
                      () {
                        buildCurrencies(value);
                      },
                    ),
                  );
                  caratTxt = '..';
                  gramTxt = '..';
                  costTxt = '....';
                  costPriceTxt = '....';
                  barcodeTextEditingController.text = '';
                  earningRateTextEditingController.text = '';
                  saleTextEditingController.text = '';
                });
              },
              child: const Text(
                'Yenile',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildRightOfBody() {
    return Container(
      width: 340,
      //color: Colors.red,
      alignment: Alignment.topCenter,
      child: DataTable(
        columnSpacing: 45,
        columns: const [
          DataColumn(label: Text('')),
          DataColumn(
            label: Text(
              'Alış',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Satış',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(
                Text(
                  'Has Altın',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  fineGoldBuy,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  fineGoldSale,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(
                Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  usdBuy,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  usdSale,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(
                Text(
                  'EUR',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  eurBuy,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  eurSale,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSearch(value) {
    if (value.length == 13) {
      for (int i = 0; i < GoldProductDbHelper().products.length; i++) {
        if (GoldProductDbHelper().products[i].barcodeText == value) {
          print('ürün bulundu');
          setState(() {
            product = GoldProductDbHelper().products[i];
            caratTxt = product!.carat.intDefinition.toString();
            gramTxt = product!.gram.toString();
            costTxt = product!.cost.toString().split('')[0];
            // + product!.cost.toString().split('')[1].substring(0, 1)
            CurrencyService.getCurrenciesOfHakanAltin().then((value) => {
                  setState(() {
                    costPriceTxt =
                        '${NumberFormat('#,##0.0', 'tr_TR').format(product!.cost * CurrencyService.fineGoldSale)} TL';
                    buildCurrencies(value);
                  }),
                });
          });
        }
      }
      for (var element in GoldProductDbHelper().products) {
        if (element.barcodeText == value) {
          setState(() {
            product = element;
            caratTxt = product!.carat.intDefinition.toString();
            gramTxt = product!.gram.toString().replaceAll('.', ',');
            costTxt = product!.cost.toString().replaceAll('.', ',');
          });
          break;
        }
      }
    }
  }

  void buildCurrencies(Map<String, double> value) {
    fineGoldBuy = value['fineGoldBuy']!.toString();
    fineGoldSale = value['fineGoldSale']!.toString();
    usdBuy = value['usdBuy']!.toString();
    usdSale = value['usdSale']!.toString();
    eurBuy = value['eurBuy']!.toString();
    eurSale = value['eurSale']!.toString();
  }
}
