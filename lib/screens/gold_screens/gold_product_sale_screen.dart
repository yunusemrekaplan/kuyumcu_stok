import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localization/input_formatters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/localization/converters.dart';

import '../../styles/button_styles.dart';

class GoldProductSaleScreen extends StatefulWidget {
  const GoldProductSaleScreen({super.key});

  @override
  State<GoldProductSaleScreen> createState() => _GoldProductSaleScreenState();
}

class _GoldProductSaleScreenState extends State<GoldProductSaleScreen> {
  late GoldProduct product;
  late List<GoldProduct> products;
  late int productIndex;

  String fineGoldBuy = '.......';
  String fineGoldSale = '.......';
  String usdBuy = '.......';
  String usdSale = '.......';
  String eurBuy = '.......';
  String eurSale = '.......';
  String nameCellTxt = '';
  String pieceCellTxt = '';
  String gramCellTxt = '';
  String salesGramsCellTxt = '';
  String costPriceTxt = '';
  String soldGramTxt = '..........';

  late double soldPrice;
  late double soldGram;
  late double earnedProfitTL;
  late double earnedProfitGram;

  late int isFun;
  var textFormFieldColors = Colors.white;

  late TextEditingController barcodeTextEditingController;
  late TextEditingController earningRateTLTextEditingController;
  late TextEditingController earningRateGramTextEditingController;
  late TextEditingController saleTLTextEditingController;
  late TextEditingController pieceTextEditingController;
  late ButtonStyles buttonStyles;

  _GoldProductSaleScreenState() {
    products = GoldProductDbHelper().products;
    buttonStyles = ButtonStyles();
    barcodeTextEditingController = TextEditingController();
    earningRateTLTextEditingController = TextEditingController();
    earningRateGramTextEditingController = TextEditingController();
    saleTLTextEditingController = TextEditingController();
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
      backgroundColor: backgroundColor,
      body: Container(
        child: _buildBody(),
      ),
    );
  }

  Row _buildBody() {
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.75,
                    color: secondColor,
                    child: buildBarcodeAndEarningRateRow(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.75,
                    color: secondColor,
                    child: buildProductInformationDataTable(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.75,
                    color: secondColor,
                    child: buildSaleRow(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildBarcodeAndEarningRateRow() {
    return Row(
      children: [
        // Barcode TextFormField
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: buildBarcodeRow(),
        ),
        // Earning Rate TextFormField
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: buildEarningRateTLRow(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: buildEarningRateGramRow(),
        ),
        // Calculation button
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: buildCalculatingButton(),
        )
      ],
    );
  }

  Row buildBarcodeRow() {
    return Row(
      children: [
        Text(
          'Barkod: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: barcodeTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(190, 38)),
          inputFormatters: <TextInputFormatter>[
            inputFormatOnlyDigits,
          ],
          style: buildTextFormFieldTextStyle(),
          cursorColor: textFormFieldColors,
          onChanged: (value) => onSearch(value, context),
        ),
      ],
    );
  }

  Row buildEarningRateTLRow() {
    return Row(
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
            inputFormatOnlyDigits,
          ],
          style: buildTextFormFieldTextStyle(),
          cursorColor: textFormFieldColors,
          onChanged: (value) => onCalculatePercent(),
          onFieldSubmitted: (value) => onCalculatePercent(),
        ),
      ],
    );
  }

  Row buildEarningRateGramRow() {
    return Row(
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
            inputFormatDouble,
          ],
          style: buildTextFormFieldTextStyle(),
          cursorColor: textFormFieldColors,
          onChanged: (value) => onCalculateGram(),
          onFieldSubmitted: (value) => onCalculateGram(),
        ),
      ],
    );
  }

  ElevatedButton buildCalculatingButton() {
    return ElevatedButton(
      onPressed: onCalculate,
      style: buttonStyles.buildBasicButtonStyle(),
      child: const Text(
        'Hesapla',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          height: 2.2,
        ),
      ),
    );
  }

  Row buildProductInformationDataTable() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: DataTable(
            columnSpacing: 45,
            border: buildInformationTableBorder(),
            columns: buildInformationTableColumns(),
            rows: buildInformationTableRows(),
          ),
        ),
      ],
    );
  }

  List<DataRow> buildInformationTableRows() {
    return [
      DataRow(
        cells: [
          DataCell(
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nameCellTxt, //27
                style: buildDataCellTextStyle(),
              ),
            ),
          ),
          DataCell(
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                pieceCellTxt,
                style: buildDataCellTextStyle(),
              ),
            ),
          ),
          DataCell(
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                gramCellTxt,
                style: buildDataCellTextStyle(),
              ),
            ),
          ),
          DataCell(
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                salesGramsCellTxt,
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
    ];
  }

  List<DataColumn> buildInformationTableColumns() {
    return [
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
    ];
  }

  TableBorder buildInformationTableBorder() {
    return const TableBorder(
      top: BorderSide(width: 1, color: Colors.white),
      left: BorderSide(width: 1, color: Colors.white),
      right: BorderSide(width: 1, color: Colors.white),
      bottom: BorderSide(width: 1, color: Colors.white),
      horizontalInside: BorderSide(width: 1, color: Colors.white),
      verticalInside: BorderSide(width: 1, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
  }

  Row buildSaleRow() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: buildSalePriceTextAndForm(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: buildSaleGramTextAndForm(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: buildSalePieceTextAndForm(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: buildSaleButton(),
        ),
      ],
    );
  }

  Row buildSalePriceTextAndForm() {
    return Row(
      children: [
        Text(
          'Satış Ücreti: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: saleTLTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(105, 38)),
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(7),
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,6}')),
            ThousandsFormatter(),
          ],
          cursorColor: textFormFieldColors,
          style: buildTextFormFieldTextStyle(),
          onChanged: onChangedSalePrice,
        ),
      ],
    );
  }

  Row buildSaleGramTextAndForm() {
    return Row(
      children: [
        Text(
          'Satış Gramı: ',
          style: buildTextStyle(),
        ),
        SizedBox(
          width: 90,
          height: 33,
          child: Text(
            soldGramTxt,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Row buildSalePieceTextAndForm() {
    return Row(
      children: [
        Text(
          'Adedi: ',
          style: buildTextStyle(),
        ),
        TextFormField(
          controller: pieceTextEditingController,
          cursorHeight: 20,
          decoration: buildInputDecoration(const Size(50, 38)),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            inputFormatOnlyDigits,
          ],
          cursorColor: textFormFieldColors,
          style: buildTextFormFieldTextStyle(),
        ),
      ],
    );
  }

  ElevatedButton buildSaleButton() {
    return ElevatedButton(
      onPressed: onSale,
      style: buttonStyles.buildBasicButtonStyle(),
      child: const Text(
        'Satışı Onayla',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          height: 2.2,
        ),
      ),
    );
  }

  ElevatedButton buildRefreshButton() {
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
          gramCellTxt = '..';
          // costTxt = '....';
          costPriceTxt = '....';
          barcodeTextEditingController.text = '';
          earningRateTLTextEditingController.text = '';
          saleTLTextEditingController.text = '';
        });
      },
      child: const Text(
        'Yenile',
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
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
              width: 70,
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
                  'HAS',
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
      fontSize: 22,
      color: Colors.white,
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return const TextStyle(
      fontSize: 24,
      color: Colors.white,
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      fontSize: 26,
      color: Colors.white,
    );
  }

  TextStyle buildTableTextStyle() {
    return const TextStyle(
      fontSize: 22,
      color: Colors.white,
    );
  }

  TextStyle buildTextFormFieldTextStyle() {
    return const TextStyle(
      fontSize: 24,
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

  void onSearch(value, BuildContext context) {
    bool control = false;
    if (value.length == 13) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      for (int i = 0; i < products.length; i++) {
        if (products[i].barcodeText == value) {
          productIndex = i;
          setState(() {
            earningRateTLTextEditingController.text = '';
            earningRateGramTextEditingController.text = '';
            saleTLTextEditingController.text = '';
            soldGramTxt = '';
            pieceTextEditingController.text = '';
            //tableWidth = 700;
            product = GoldProductDbHelper().products[i];
            nameCellTxt = product!.name.substring(
                0, product!.name.length <= 21 ? product!.name.length : 21);
            //tableWidth += nameCellTxt.length > 5 ? (nameCellTxt.length - 5) * 18 : 0;
            pieceCellTxt = product!.piece.toString();
            gramCellTxt = product!.carat.intDefinition.toString();
            salesGramsCellTxt = OutputFormatters.buildNumberFormat2f(product!.salesGrams);
            CurrencyService.getCurrenciesOfHakanAltin().then((value) => {
                  setState(() {
                    double costPrice =
                        product!.cost * CurrencyService.fineGoldSale;
                    costPriceTxt =
                        '${OutputFormatters.buildNumberFormat0f(costPrice)} TL';
                    buildCurrencies(value);
                  }),
                });
          });
          control = true;
          break;
        }
      }
      Navigator.of(context).pop();
      if (!control) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Stokta bu barkoda ait ürün bulunmamaktadır'),
            actions: [
              TextButton(
                child: const Text(
                  'Tamam',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
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
    if (product != null) {
      isFun = 0;
      int? percent = int.tryParse(earningRateTLTextEditingController.text);
      double costPrice = (product!.cost * CurrencyService.fineGoldSale);
      if (percent != null) {
        soldPrice = (double.parse(costPrice.toString()) +
            (double.parse(costPrice.toString()) * percent / 100));
        double temp = soldPrice! / costPrice;
        double gram = product!.salesGrams * temp;
        setState(() {
          earningRateGramTextEditingController.text =
              OutputFormatters.buildNumberFormat2f(gram);
          saleTLTextEditingController.text =
              OutputFormatters.buildNumberFormat0f(soldPrice!);
          soldGramTxt = earningRateGramTextEditingController.text;
        });
      }
    }
  }

  void onCalculateGram() {
    if (product != null) {
      isFun = 1;
      double? gram = double.tryParse(
          earningRateGramTextEditingController.text.replaceAll(',', '.'));
      double costPrice = (product!.cost * CurrencyService.fineGoldSale);
      if (gram != null) {
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
          saleTLTextEditingController.text =
              OutputFormatters.buildNumberFormat0f(soldPrice!);
          soldGramTxt = earningRateGramTextEditingController.text;
        });
      }
    }
  }

  void onChangedSalePrice(value) {
    if (product != null && value.isNotEmpty) {
      double costPrice = product!.cost * CurrencyService.fineGoldSale;
      double price = double.parse(Converters.doubleNumToTr(value));
      double diff = price - costPrice;
      String percentString = (100 / (costPrice / diff)).toString();
      double percent = double.parse(percentString);
      double profit = (product!.salesGrams * percent / 100);
      double newSalesGram = (product!.salesGrams + profit);

      if (percent != 0) {
        setState(() {
          soldGramTxt = OutputFormatters.buildNumberFormat3f(newSalesGram);
        });
      } else {
        setState(() {
          soldGramTxt = OutputFormatters.buildNumberFormat3f(product!.salesGrams);
        });
      }
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
    int? piece = int.tryParse(pieceTextEditingController.text);
    if (isVariablesEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Boş alanları doldurun!'),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                Navigator.of(context).pop(),
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else if (piece! > product!.piece) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Yeterli sayıda ürün bulunmamaktadır'),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                Navigator.of(context).pop(),
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      product!.piece -= piece;

      double costPrice = (product!.cost * CurrencyService.fineGoldSale);
      soldPrice = double.parse(saleTLTextEditingController.text.replaceAll('.', ''));
      soldGram = double.parse(soldGramTxt.replaceAll(',', '.'));
      earnedProfitTL = soldPrice! - costPrice;
      earnedProfitGram = soldGram! - product!.salesGrams;

      GoldProductDbHelper()
          .update(product!.toJson(), product!.id)
          .then((value) {
        GoldProductDbHelper().products[productIndex] = product!;

        ProductSale productSale = ProductSale(
          product: product!.toJson(),
          soldDate: DateTime.now(),
          piece: piece,
          costPrice: costPrice,
          soldPrice: soldPrice!,
          soldGram: soldGram!,
          earnedProfitTL: earnedProfitTL!,
          earnedProfitGram: earnedProfitGram!,
        );

        print(productSale.toJson());
        setState(() {
          nameCellTxt = '';
          pieceCellTxt = '';
          gramCellTxt = '';
          salesGramsCellTxt = '';
          costPriceTxt = '';
          barcodeTextEditingController.text = '';
          earningRateTLTextEditingController.text = '';
          earningRateGramTextEditingController.text = '';
          saleTLTextEditingController.text = '';
          salesGramsCellTxt = '';
          pieceTextEditingController.text = '';
        });

        ProductSaleDbHelper().insert(productSale.toJson()).then((value) {
          ProductSaleDbHelper().sales.add(ProductSale.fromJson(productSale.toJson(), value));
          Navigator.of(context).pop();
        });
      });
    }
  }

  bool isVariablesEmpty() {
    return saleTLTextEditingController.text.isEmpty ||
        pieceTextEditingController.text.isEmpty;
  }
}
