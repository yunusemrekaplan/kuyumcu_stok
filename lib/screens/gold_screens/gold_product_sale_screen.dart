import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum/carat.dart';
import 'package:kuyumcu_stok/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localizations/input_formatters.dart';
import 'package:kuyumcu_stok/localizations/output_formatters.dart';
import 'package:kuyumcu_stok/models/gold_product.dart';
import 'package:kuyumcu_stok/models/product_sale.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';

class GoldProductSaleScreen extends StatefulWidget {
  const GoldProductSaleScreen({super.key});

  @override
  State<GoldProductSaleScreen> createState() => _GoldProductSaleScreenState();
}

class _GoldProductSaleScreenState extends State<GoldProductSaleScreen> {
  GoldProduct? product;
  late List<GoldProduct> products;

  String? earningRate;
  String fineGoldBuy = '.......';
  String fineGoldSale = '.......';
  String usdBuy = '.......';
  String usdSale = '.......';
  String eurBuy = '.......';
  String eurSale = '.......';
  String nameTxt = '';
  String pieceTxt = '';
  String caratTxt = '';
  String gramTxt = '';
  String salesGramsTxt = '';
  String costTxt = '';
  String costPriceTxt = '';

  double tableWidth = 840;
  double? soldPrice;
  double? soldGram;
  double? earnedProfitTL;
  double? earnedProfitGram;

  int? isFun;
  var textFormFieldColors = Colors.white;

  late TextEditingController barcodeTextEditingController;
  late TextEditingController earningRateTLTextEditingController;
  late TextEditingController earningRateGramTextEditingController;
  late TextEditingController saleTextEditingController;
  late TextEditingController saleGramTextEditingController;
  late TextEditingController pieceTextEditingController;

  _GoldProductSaleScreenState() {
    products = GoldProductDbHelper().products;
    barcodeTextEditingController = TextEditingController();
    earningRateTLTextEditingController = TextEditingController();
    earningRateGramTextEditingController = TextEditingController();
    saleTextEditingController = TextEditingController();
    saleGramTextEditingController = TextEditingController();
    pieceTextEditingController = TextEditingController();
  }

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
      appBar: appBar,
      drawer: const MyDrawer(),
      backgroundColor: const Color(0xFF07263C),
      body: Container(
        child: _buildBody(),
      ),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Row(
            children: [
              _buildLeftOfBody(),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _buildRightOfBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 30),
                  child: buildProductInformationDataTable(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 20.0, right: 20.0, bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSaleRow(),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: _buildRefreshButton(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildLeftOfBody() {
    return Column(
      children: [
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: _buildBarcodeAndEarningRateRow(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildBarcodeAndEarningRateRow() {
    return Container(
      width: 950,
      decoration: const BoxDecoration(
        color: Color(0xFF2b384a),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
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
      ),
    );
  }

  Row _buildBarcodeRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Barkod: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: barcodeTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(220, 38)),
          inputFormatters: <TextInputFormatter>[
            InputFormatters.inputOnlyDigits(),
          ],
          style: buildTextFormFieldTextStyle(),
          cursorColor: textFormFieldColors,
          onChanged: onSearch,
        ),
      ],
    );
  }

  Row _buildEarningRateTLRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Kar %: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: earningRateTLTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(70, 38)),
          inputFormatters: <TextInputFormatter>[
            InputFormatters.inputOnlyDigits(),
          ],
          style: buildTextFormFieldTextStyle(),
          cursorColor: textFormFieldColors,
          onChanged: (value) => onCalculatePercent(),
          onFieldSubmitted: (value) => onCalculatePercent(),
        ),
      ],
    );
  }

  Row _buildEarningRateGramRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Gram: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: earningRateGramTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(100, 38)),
          inputFormatters: <TextInputFormatter>[
            InputFormatters.inputDouble(),
          ],
          style: buildTextFormFieldTextStyle(),
          cursorColor: textFormFieldColors,
          onChanged: (value) => onCalculateGram(),
          onFieldSubmitted: (value) => onCalculateGram(),
        ),
      ],
    );
  }

  ElevatedButton _buildCalculatingButton() {
    return ElevatedButton(
      onPressed: onCalculate,
      child: const Text(
        'Hesapla',
        style: TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }

  Container buildProductInformationDataTable() {
    return Container(
      width: tableWidth,
      decoration: const BoxDecoration(
        color: Color(0xFF2b384a),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: DataTable(
                columnSpacing: 45,
                border: const TableBorder(
                  top: BorderSide(width: 1, color: Colors.white),
                  left: BorderSide(width: 1, color: Colors.white),
                  right: BorderSide(width: 1, color: Colors.white),
                  bottom: BorderSide(width: 1, color: Colors.white),
                  horizontalInside: BorderSide(width: 1, color: Colors.white),
                  verticalInside: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'İsim',
                      style: buildDataColumnTextStyle(),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Adet',
                      style: buildDataColumnTextStyle(),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Ayar',
                      style: buildDataColumnTextStyle(),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Gram',
                      style: buildDataColumnTextStyle(),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Satış Gramı',
                      style: buildDataColumnTextStyle(),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Maliyet Fiyatı',
                      style: buildDataColumnTextStyle(),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            nameTxt, //27
                            style: buildDataCellTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            pieceTxt,
                            style: buildDataCellTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            caratTxt,
                            style: buildDataCellTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            gramTxt,
                            style: buildDataCellTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            salesGramsTxt,
                            style: buildDataCellTextStyle(),
                          ),
                        ),
                      ),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            costPriceTxt,
                            style: buildDataCellTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSaleRow() {
    return Row(
      children: [
        Container(
          width: 1120,
          decoration: const BoxDecoration(
            color: Color(0xFF2b384a),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20, top: 30.0, right: 20, bottom: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSalePriceTextAndForm(),
                _buildSaleGramTextAndForm(),
                _buildSalePieceTextAndForm(),
                _buildSaleButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildSalePriceTextAndForm() {
    return Row(
      children: [
        Text(
          'Satış Ücreti: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: saleTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(160, 38)),
          inputFormatters: <TextInputFormatter>[
            InputFormatters.inputDouble(),
          ],
          cursorColor: textFormFieldColors,
          style: buildTextFormFieldTextStyle(),
        ),
      ],
    );
  }

  Padding _buildSaleGramTextAndForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Row(
        children: [
          Text(
            'Satış Gramı: ',
            style: buildTextStyle(),
          ),
          TextFormField(
            controller: saleGramTextEditingController,
            cursorHeight: 20,
            decoration: buildInputDecoration(const Size(120, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputDouble(),
            ],
            cursorColor: textFormFieldColors,
            style: buildTextFormFieldTextStyle(),
          ),
        ],
      ),
    );
  }

  Padding _buildSalePieceTextAndForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: Row(
        children: [
          Text(
            'Adedi: ',
            style: buildTextStyle(),
          ),
          TextFormField(
            controller: pieceTextEditingController,
            cursorHeight: 20,
            decoration: buildInputDecoration(const Size(70, 38)),
            inputFormatters: <TextInputFormatter>[
              InputFormatters.inputOnlyDigits(),
            ],
            cursorColor: textFormFieldColors,
            style: buildTextFormFieldTextStyle(),
          ),
        ],
      ),
    );
  }

  Padding _buildSaleButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: ElevatedButton(
        onPressed: onSale,
        child: const Text(
          'Satışı Onayla',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildRefreshButton() {
    return ElevatedButton(
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
          fontSize: 24,
        ),
      ),
    );
  }

  Container _buildRightOfBody() {
    return Container(
      width: 450,
      color: const Color(0xFF07263C),
      alignment: Alignment.topCenter,
      child: DataTable(
        columnSpacing: 45,
        columns: [
          DataColumn(
            label: SizedBox(
              //width: 10,
              child: Text(
                '',
                style: buildTableTextStyle(),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Alış',
                  style: buildTableTextStyle(),
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Satış',
                  style: buildTableTextStyle(),
                ),
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Has Altın',
                  style: buildTableTextStyle(),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    fineGoldBuy,
                    style: buildTableTextStyle(),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    fineGoldSale,
                    style: buildTableTextStyle(),
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Text(
                  'USD',
                  style: buildTableTextStyle(),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    usdBuy,
                    style: buildTableTextStyle(),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    usdSale,
                    style: buildTableTextStyle(),
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Text(
                  'EUR',
                  style: buildTableTextStyle(),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    eurBuy,
                    style: buildTableTextStyle(),
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    eurSale,
                    style: buildTableTextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle buildDataCellTextStyle() {
    return const TextStyle(
      fontSize: 24,
      color: Colors.white,
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return const TextStyle(
      fontSize: 26,
      color: Colors.white,
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      fontSize: 30,
      color: Colors.white,
    );
  }

  TextStyle buildTableTextStyle() {
    return const TextStyle(
      fontSize: 26,
      color: Colors.white,
    );
  }

  TextStyle buildTextFormFieldTextStyle() {
    return const TextStyle(
      fontSize: 28,
      height: 0.9,
      color: Colors.white,
      //backgroundColor: Colors.black,
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

  void buildCurrencies(Map<String, double> value) {
    fineGoldBuy = value['fineGoldBuy']!.toString();
    fineGoldSale = value['fineGoldSale']!.toString();
    usdBuy = value['usdBuy']!.toString();
    usdSale = value['usdSale']!.toString();
    eurBuy = value['eurBuy']!.toString();
    eurSale = value['eurSale']!.toString();
    fineGoldBuy =
        OutputFormatters.buildNumberFormat1f(double.parse(fineGoldBuy));
    fineGoldSale =
        OutputFormatters.buildNumberFormat1f(double.parse(fineGoldSale));
    usdBuy = OutputFormatters.buildNumberFormat1f(double.parse(usdBuy));
    usdSale = OutputFormatters.buildNumberFormat1f(double.parse(usdSale));
    eurBuy = OutputFormatters.buildNumberFormat1f(double.parse(eurBuy));
    eurSale = OutputFormatters.buildNumberFormat1f(double.parse(eurSale));
  }

  void onSearch(value) {
    if (value.length == 13) {
      for (int i = 0; i < products.length; i++) {
        if (products[i].barcodeText == value) {
          setState(() {
            tableWidth = 840;
            product = GoldProductDbHelper().products[i];
            nameTxt = product!.name.substring(
                0, product!.name.length <= 25 ? product!.name.length : 26);
            tableWidth += product!.name.length * 9;
            pieceTxt = product!.piece.toString();
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
      soldPrice = (double.parse(costPrice.toString()) +
          (double.parse(costPrice.toString()) * percent / 100));
      double temp = soldPrice! / costPrice;
      double gram = product!.salesGrams * temp;
      //print(gram);
      //gram.toString().split('.')[1][0] == '0' ?
      setState(() {
        earningRateGramTextEditingController.text =
            OutputFormatters.buildNumberFormat2f(gram);
        saleTextEditingController.text =
            OutputFormatters.buildNumberFormat1f(soldPrice!);
        saleGramTextEditingController.text =
            earningRateGramTextEditingController.text;
      });
    }
  }

  void onCalculateGram() {
    isFun = 1;
    double? gram = double.tryParse(
        earningRateGramTextEditingController.text.replaceAll(',', '.'));
    double costPrice = (product!.cost * CurrencyService.fineGoldSale);
    if (gram != null && product != null) {
      double gramDiff = gram - product!.salesGrams;
      double? percent = gramDiff == 0
          ? 0
          : double.tryParse(
              (100 / (product!.salesGrams / gramDiff)).toString());
      soldPrice = (double.parse(costPrice.toString()) +
          (double.parse(costPrice.toString()) * percent! / 100));
      setState(() {
        earningRateTLTextEditingController.text =
            percent.toString().split('.')[1][0] == '0'
                ? OutputFormatters.buildNumberFormat0f(percent)
                : OutputFormatters.buildNumberFormat1f(percent);
        saleTextEditingController.text =
            OutputFormatters.buildNumberFormat1f(soldPrice!);
        saleGramTextEditingController.text =
            earningRateGramTextEditingController.text;
      });
    }
  }

  // isCorrect? isNull? onSale
  void onSale() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    product!.piece -= int.tryParse(pieceTextEditingController.text)!;
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
