import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_sale_db_helper.dart';
import 'package:kuyumcu_stok/localization/converters.dart';
import 'package:kuyumcu_stok/localization/input_formatters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:kuyumcu_stok/services/currency_service.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
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
  String soldGramTxt = '. . . . . . .';

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
  late Size size;

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
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      backgroundColor: backgroundColor,
      body: Container(
        child: buildBody(),
      ),
    );
  }

  Row buildBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 16.0,
                  right: 16.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: MediaQuery.of(context).size.height * 0.32,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: buildCurrenciesTable(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 16.0,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: buildRefreshButton(),
                      ),
                    ],
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: buildFormRow(
            label: 'Barkod: ',
            controller: barcodeTextEditingController,
            size: Size((size.width * 0.15), 40),
            inputFormatters: [inputFormatOnlyDigits],
            onChanged: (value) => onSearch(value, context),
            onFieldSubmitted: (value) {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: buildFormRow(
            label: 'Kar %: ',
            controller: earningRateTLTextEditingController,
            size: Size((size.width * 0.05), 40),
            inputFormatters: [inputFormatOnlyDigits],
            onChanged: (value) => onCalculatePercent(),
            onFieldSubmitted: (value) => onCalculatePercent(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: buildFormRow(
            label: 'Gram: ',
            controller: earningRateGramTextEditingController,
            size: Size((size.width * 0.08), 40),
            inputFormatters: [inputFormatDouble],
            onChanged: (value) => onCalculateGram(),
            onFieldSubmitted: (value) => onCalculateGram(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: buildCalculatingButton(),
        )
      ],
    );
  }

  Row buildProductInformationDataTable() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            child: DataTable(
              columnSpacing: 45,
              border: DataTableStyles.buildTableBorder(),
              columns: buildInformationTableColumns(),
              rows: buildInformationTableRows(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildSaleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: buildFormRow(
            label: 'Satış Ücreti: ',
            controller: saleTLTextEditingController,
            size: Size((size.width * 0.08), 40),
            inputFormatters: [
              LengthLimitingTextInputFormatter(7),
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,6}')),
              ThousandsFormatter(),
            ],
            onChanged: onChangedSalePrice,
            onFieldSubmitted: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              Text(
                'Satış Gramı: ',
                style: buildTextStyle(),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: 90,
                height: size.height * 0.065,
                child: Text(
                  soldGramTxt,
                  style: TextStyle(
                    fontSize: size.height * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: buildFormRow(
            label: 'Adedi: ',
            controller: pieceTextEditingController,
            size: Size((size.width * 0.04), 40),
            inputFormatters: [inputFormatOnlyDigits],
            onChanged: (value) {
              setState(() {
                pieceTextEditingController;
              });
            },
            onFieldSubmitted: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 15.0,
          ),
          child: buildSaleButton(),
        ),
      ],
    );
  }

  Container buildCurrenciesTable() {
    return Container(
      alignment: Alignment.topCenter,
      child: DataTable(
        border: DataTableStyles.buildTableBorder(),
        columnSpacing: 30,
        headingRowHeight: size.height * 0.08,
        dataRowMaxHeight: size.height * 0.08,
        columns: [
          const DataColumn(
            numeric: true,
            label: SizedBox(),
          ),
          DataColumn(
            numeric: true,
            label: SizedBox(
              width: size.width * 0.06,
              height: size.height * 0.07,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  ' Alış',
                  style: buildTableColumnTextStyle(),
                ),
              ),
            ),
          ),
          DataColumn(
            numeric: true,
            label: SizedBox(
              width: size.width * 0.06,
              height: size.height * 0.07,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  'Satış',
                  style: buildTableColumnTextStyle(),
                ),
              ),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: size.width * 0.035,
                  height: size.height * 0.05,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      'HAS',
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  height: size.height * 0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      fineGoldBuy,
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  height: size.height * 0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      fineGoldSale,
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: size.width * 0.035,
                  height: size.height * 0.05,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      'USD',
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  height: size.height * 0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      usdBuy,
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  height: size.height * 0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      usdSale,
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: size.width * 0.035,
                  height: size.height * 0.05,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      'EUR',
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  height: size.height * 0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      eurBuy,
                      style: buildTableTextStyle(),
                    ),
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  height: size.height * 0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      eurSale,
                      style: buildTableTextStyle(),
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

  List<DataColumn> buildInformationTableColumns() {
    return [
      DataColumn(
        label: Text(
          'İsim',
          style: buildDataColumnTextStyle(),
        ),
      ),
      DataColumn(
        numeric: true,
        label: Text(
          'Adet',
          style: buildDataColumnTextStyle(),
        ),
      ),
      DataColumn(
        numeric: true,
        label: Text(
          'Gram',
          style: buildDataColumnTextStyle(),
        ),
      ),
      DataColumn(
        numeric: true,
        label: Text(
          'S. Gramı',
          style: buildDataColumnTextStyle(),
        ),
      ),
      DataColumn(
        numeric: true,
        label: Text(
          'Maliyet Fiyatı',
          style: buildDataColumnTextStyle(),
        ),
      ),
    ];
  }

  List<DataRow> buildInformationTableRows() {
    return [
      DataRow(
        cells: [
          DataCell(
            Text(
              nameCellTxt, //27
              style: buildDataCellTextStyle(),
            ),
          ),
          DataCell(
            Text(
              pieceCellTxt,
              style: buildDataCellTextStyle(),
            ),
          ),
          DataCell(
            Text(
              gramCellTxt,
              style: buildDataCellTextStyle(),
            ),
          ),
          DataCell(
            Text(
              salesGramsCellTxt,
              style: buildDataCellTextStyle(),
            ),
          ),
          DataCell(
            Text(
              costPriceTxt,
              style: buildDataCellTextStyle(),
            ),
          ),
        ],
      ),
    ];
  }

  Row buildFormRow({
    required String label,
    required TextEditingController controller,
    required Size size,
    required List<TextInputFormatter> inputFormatters,
    required void Function(String)? onChanged,
    required void Function(String)? onFieldSubmitted,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: buildTextStyle(),
        ),
        buildTextFormField(
          controller: controller,
          size: size,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }

  TextFormField buildTextFormField({
    required TextEditingController controller,
    required Size size,
    required List<TextInputFormatter> inputFormatters,
    required void Function(String)? onChanged,
    required void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      // textAlignVertical: TextAlignVertical.top,
      // cursorHeight: size.height * 0.5,
      // textAlign: TextAlign.center,
      controller: controller,
      decoration: buildInputDecoration(size),
      inputFormatters: inputFormatters,
      style: buildTextFormFieldTextStyle(),
      cursorColor: textFormFieldColors,
      onChanged: onChanged,
    );
  }

  ElevatedButton buildCalculatingButton() {
    return ElevatedButton(
      onPressed: onCalculate,
      style: buttonStyles.buildBasicButtonStyle(),
      child: Text(
        ' Hesapla ',
        style: buildButtonTextStyle(),
      ),
    );
  }

  ElevatedButton buildSaleButton() {
    return ElevatedButton(
      onPressed: onSale,
      style: buttonStyles.buildSaveButtonStyle(isSalable()),
      child: Text(
        '  Onayla  ',
        style: buildButtonTextStyle(),
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
          barcodeTextEditingController.text = '';
          earningRateTLTextEditingController.text = '';
          earningRateGramTextEditingController.text = '';
          saleTLTextEditingController.text = '';
          pieceTextEditingController.text = '';
          nameCellTxt = '';
          pieceCellTxt = '';
          gramCellTxt = '';
          salesGramsCellTxt = '';
          costPriceTxt = '';
          soldGramTxt = '. . . . . . .';
        });
      },
      style: ButtonStyles().buildBasicButtonStyle(),
      child: Text(
        '  Yenile  ',
        style: buildButtonTextStyle(),
      ),
    );
  }

  TextStyle buildButtonTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.04,
      color: Colors.white,
      height: 1.5,
      letterSpacing: 1.5,
    );
  }

  TextStyle buildDataCellTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.035,
      color: Colors.white,
    );
  }

  TextStyle buildDataColumnTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.04,
      color: Colors.white,
    );
  }

  TextStyle buildTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.045,
      color: Colors.white,
    );
  }

  TextStyle buildTableColumnTextStyle() {
    return const TextStyle(
      color: Colors.white,
      letterSpacing: 1,
    );
  }

  TextStyle buildTableTextStyle() {
    return const TextStyle(
      color: Colors.white,
    );
  }

  TextStyle buildTextFormFieldTextStyle() {
    return TextStyle(
      fontSize: size.height * 0.0368,
      height: 1,
      color: Colors.white,
    );
  }

  InputDecoration buildInputDecoration(Size size) {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      constraints: BoxConstraints.tight(size),
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
            soldGramTxt = '. . . . . . .';
            pieceTextEditingController.text = '';
            product = GoldProductDbHelper().products[i];
            nameCellTxt = product!.name.substring(
                0, product!.name.length <= 20 ? product!.name.length : 20);
            pieceCellTxt = product!.piece.toString();
            gramCellTxt = OutputFormatters.buildNumberFormat2f(product!.gram);
            salesGramsCellTxt =
                OutputFormatters.buildNumberFormat2f(product!.salesGrams);
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
        double temp = soldPrice / costPrice;
        double gram = product!.salesGrams * temp;
        setState(() {
          earningRateGramTextEditingController.text =
              OutputFormatters.buildNumberFormat2f(gram);
          saleTLTextEditingController.text =
              OutputFormatters.buildNumberFormat0f(soldPrice);
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
              OutputFormatters.buildNumberFormat0f(soldPrice);
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
          soldGramTxt =
              OutputFormatters.buildNumberFormat3f(product!.salesGrams);
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
      soldPrice =
          double.parse(saleTLTextEditingController.text.replaceAll('.', ''));
      soldGram = double.parse(soldGramTxt.replaceAll(',', '.'));
      earnedProfitTL = soldPrice - costPrice;
      earnedProfitGram = soldGram - product!.salesGrams;

      GoldProductDbHelper().update(product!.toJson(), product!.id).then((value) {
        GoldProductDbHelper().products[productIndex] = product!;

        ProductSale productSale = ProductSale(
          product: product!.toJson(),
          soldDate: DateTime.now(),
          piece: piece,
          costPrice: costPrice,
          soldPrice: soldPrice,
          soldGram: soldGram,
          earnedProfitTL: earnedProfitTL,
          earnedProfitGram: earnedProfitGram,
        );

        // print(productSale.toJson());
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
          ProductSaleDbHelper()
              .sales
              .add(ProductSale.fromJson(productSale.toJson(), value));
          Navigator.of(context).pop();
        });
      });
    }
  }

  bool isVariablesEmpty() {
    return saleTLTextEditingController.text.isEmpty ||
        pieceTextEditingController.text.isEmpty;
  }

  bool isSalable() {
    return saleTLTextEditingController.text.isEmpty || pieceTextEditingController.text.isEmpty;
  }
}
