import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum_carat.dart';
import 'package:kuyumcu_stok/localizations/input_formatters.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/models/product_sale.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductSaleScreen extends StatefulWidget {
  const GoldProductSaleScreen({super.key});

  @override
  State<GoldProductSaleScreen> createState() => _GoldProductSaleScreenState();
}

class _GoldProductSaleScreenState extends State<GoldProductSaleScreen> {
  GoldProduct? product;

  String? earningRate;
  String fineGoldBuy = '.......';
  String fineGoldSale = '.......';
  String usdBuy = '.......';
  String usdSale = '.......';
  String eurBuy = '.......';
  String eurSale = '.......';
  String caratTxt = '..';
  String gramTxt = '..';
  String salesGramsTxt = '..';
  String costTxt = '....';
  String costPriceTxt = '....';

  double? soldPrice;
  double? soldGram;
  double? earnedProfitTL;
  double? earnedProfitGram;

  int? isFun;
  var textFormFieldColors = Colors.white;

  TextEditingController barcodeTextEditingController = TextEditingController();
  TextEditingController earningRateTLTextEditingController =
      TextEditingController();
  TextEditingController earningRateGramTextEditingController =
      TextEditingController();
  TextEditingController saleTextEditingController = TextEditingController();
  TextEditingController pieceTextEditingController = TextEditingController();

  @override
  void initState() {
    CurrencyService.getCurrenciesOfHakanAltin().then(
      (value) => setState(
        () {
          buildCurrencies(value);
          fineGoldBuy = NumberFormat('#,##0.0', 'tr_TR')
              .format(double.parse(fineGoldBuy));
          fineGoldSale = NumberFormat('#,##0.0', 'tr_TR')
              .format(double.parse(fineGoldSale));
          usdBuy =
              NumberFormat('#,##0.0', 'tr_TR').format(double.parse(usdBuy));
          usdSale =
              NumberFormat('#,##0.0', 'tr_TR').format(double.parse(usdSale));
          eurBuy =
              NumberFormat('#,##0.0', 'tr_TR').format(double.parse(eurBuy));
          eurSale =
              NumberFormat('#,##0.0', 'tr_TR').format(double.parse(eurSale));
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: Container(
        color: const Color(0xFF0B1820),
        child: _buildBody(),
      ),
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
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: _buildBarcodeAndEarningRateRow(),
          ),
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

  Container _buildBarcodeAndEarningRateRow() {
    return Container(
      //color: Colors.white,
      child: Row(
        children: [
          // Barcode TextFormField
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: _buildBarcodeRow(),
          ),
          // Earning Rate TextFormField
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: _buildEarningRateTLRow(),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: _buildEarningRateGramRow(),
          ),
          // Calculation button
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: _buildCalculatingButton(),
          )
        ],
      ),
    );
  }

  Row _buildBarcodeRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildBarcodeText(),
        _buildBarcodeTextFormField(),
      ],
    );
  }

  Text _buildBarcodeText() {
    return Text(
      'Barkod: ',
      style: buildTextStyle(),
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      fontSize: 22,
      color: Colors.white,
    );
  }

  TextFormField _buildBarcodeTextFormField() {
    return TextFormField(
      controller: barcodeTextEditingController,
      cursorHeight: 20,
      decoration: buildInputDecoration(const Size(160, 38)),
      style: buildTextFormFieldTextStyle(),
      cursorColor: textFormFieldColors,
      onChanged: onSearch,
    );
  }

  InputDecoration buildInputDecoration(Size size) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      constraints: DecorationStyles.buildBoxConstraints(size),
      focusedBorder: UnderlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      border: OutlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: buildBorderSide(),
      ),
      fillColor: textFormFieldColors,
      focusColor: textFormFieldColors,
      hoverColor: textFormFieldColors,
    );
  }

  BorderSide buildBorderSide() => const BorderSide(color: Colors.white);

  TextStyle buildTextFormFieldTextStyle() {
    return const TextStyle(
      fontSize: 20,
      height: 1,
      color: Colors.white,
      //backgroundColor: Colors.black,
    );
  }

  Row _buildEarningRateTLRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEarningRateTLText(),
        _buildEarningRateTLTextFormField(),
      ],
    );
  }

  Text _buildEarningRateTLText() {
    return Text(
      'Kar %: ',
      style: buildTextStyle(),
    );
  }

  TextFormField _buildEarningRateTLTextFormField() {
    return TextFormField(
      controller: earningRateTLTextEditingController,
      cursorHeight: 20,
      decoration: buildInputDecoration(const Size(60, 38)),
      inputFormatters: <TextInputFormatter>[
        InputFormatters.inputOnlyDigits(),
      ],
      style: buildTextFormFieldTextStyle(),
      cursorColor: textFormFieldColors,
      onChanged: (value) => onCalculatePercent(),
      onFieldSubmitted: (value) => onCalculatePercent(),
    );
  }

  Row _buildEarningRateGramRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEarningRateGramText(),
        _buildEarningRateGramTextFormField(),
      ],
    );
  }

  Text _buildEarningRateGramText() {
    return Text(
      'Gram: ',
      style: buildTextStyle(),
    );
  }

  TextFormField _buildEarningRateGramTextFormField() {
    return TextFormField(
      controller: earningRateGramTextEditingController,
      cursorHeight: 20,
      decoration: buildInputDecoration(const Size(75, 38)),
      inputFormatters: <TextInputFormatter>[
        InputFormatters.inputDouble(),
      ],
      style: buildTextFormFieldTextStyle(),
      cursorColor: textFormFieldColors,
      onChanged: (value) => onCalculateGram(),
      onFieldSubmitted: (value) => onCalculateGram(),
    );
  }

  ElevatedButton _buildCalculatingButton() {
    return ElevatedButton(
      onPressed: onCalculate,
      child: const Text(
        'Hesapla',
        style: TextStyle(
          fontSize: 20,
          height: 1,
        ),
      ),
    );
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
                'Satış Gram: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                salesGramsTxt,
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
                  earningRateTLTextEditingController.text = '';
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
      color: const Color(0xFF07263C),
      alignment: Alignment.topCenter,
      child: DataTable(
        columnSpacing: 45,
        columns: const [
          DataColumn(label: Text('')),
          DataColumn(
            label: SizedBox(
              width: 68,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Alış',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 60,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Satış',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
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
                    color: Colors.white,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    fineGoldBuy,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    fineGoldSale,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
                    color: Colors.white,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    usdBuy,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    usdSale,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
                    color: Colors.white,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    eurBuy,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    eurSale,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void buildCurrencies(Map<String, double> value) {
    fineGoldBuy = value['fineGoldBuy']!.toString();
    fineGoldSale = value['fineGoldSale']!.toString();
    usdBuy = value['usdBuy']!.toString();
    usdSale = value['usdSale']!.toString();
    eurBuy = value['eurBuy']!.toString();
    eurSale = value['eurSale']!.toString();
  }

  void onSearch(value) {
    if (value.length == 13) {
      for (int i = 0; i < GoldProductDbHelper().products.length; i++) {
        if (GoldProductDbHelper().products[i].barcodeText == value) {
          setState(() {
            product = GoldProductDbHelper().products[i];
            caratTxt = product!.carat.intDefinition.toString();
            gramTxt = product!.gram.toString().replaceAll('.', ',');
            salesGramsTxt = product!.salesGrams.toString().replaceAll('.', ',');
            costTxt = NumberFormat('#,##0.00', 'tr_TR').format(
                product!.cost); //product!.cost.toString().replaceAll('.', ',');
            // + product!.cost.toString().split('')[1].substring(0, 1)
            CurrencyService.getCurrenciesOfHakanAltin().then((value) => {
                  setState(() {
                    costPriceTxt =
                        '${NumberFormat('#,##0.0', 'tr_TR').format(product!.cost * CurrencyService.fineGoldSale)} TL';
                    buildCurrencies(value);
                  }),
                });
          });
          break;
        }
      }
    }
  }

  void onCalculate() {
    if (isFun == 0) {
      onCalculatePercent();
    } else if (isFun == 1) {
      onCalculateGram();
    }
  }

  void onCalculatePercent() {
    isFun = 0;
    int? percent = int.tryParse(earningRateTLTextEditingController.text);
    double costPrice = (product!.cost * CurrencyService.fineGoldSale);
    if (percent != null && product != null) {
      setState(() {
        soldPrice = (double.parse(costPrice.toString()) +
            (double.parse(costPrice.toString()) * percent / 100));
        double temp = soldPrice! / costPrice;
        earningRateGramTextEditingController
            .text = NumberFormat('#,##0.000', 'tr_TR').format(product!
                .salesGrams *
            temp); //(product!.salesGrams * temp).toString().replaceAll('.', ',');
        saleTextEditingController.text =
            NumberFormat('#,##0.0', 'tr_TR').format(soldPrice);
      });
    }
  }

  void onCalculateGram() {
    isFun = 1;
    double? gram = double.tryParse(
        earningRateGramTextEditingController.text.replaceAll(',', '.'));
    //double costPrice = (product!.cost * CurrencyService.fineGoldSale);
    if (gram != null && product != null) {
      setState(() {
        double gramDiff = gram - product!.salesGrams;
        gramDiff = double.parse(gramDiff.toStringAsFixed(3));
        double? percent =
            double.tryParse((product!.salesGrams / gramDiff).toString());
        print(product!.salesGrams / gramDiff);
        earningRateTLTextEditingController.text = percent!.toStringAsFixed(0);
      });
    }
  }

  void onSale() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    product!.piece -= 1;
    GoldProductDbHelper().update(product!.toJson(), product!.id).then((value) {
      ProductSale(
          product: product!.toJson(),
          soldDate: DateTime.now(),
          piece: int.parse(pieceTextEditingController.text),
          costPrice: (product!.cost * CurrencyService.fineGoldSale),
          soldPrice: soldPrice!,
          soldGram: soldGram!,
          earnedProfitTL: earnedProfitTL!,
          earnedProfitGram: earnedProfitGram!);
      Navigator.of(context).pop();
      print(product!.toJson());
      setState(() {
        caratTxt = '..';
        gramTxt = '..';
        costTxt = '....';
        costPriceTxt = '....';
        barcodeTextEditingController.text = '';
        earningRateTLTextEditingController.text = '';
        saleTextEditingController.text = '';
      });
    });
  }
}
