import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/calculator.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/data/product_entry_db_helper.dart';
import 'package:kuyumcu_stok/enum/carat.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localization/input_formatters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:kuyumcu_stok/services/barcode_service.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductAddScreen extends StatefulWidget {
  const GoldProductAddScreen({super.key});

  @override
  State<GoldProductAddScreen> createState() => _GoldProductAddScreenState();
}

class _GoldProductAddScreenState extends State<GoldProductAddScreen> {
  late String barcodeNo;
  late Carat dropdownValue;
  late TextEditingController pieceController;
  late TextEditingController nameController;
  late TextEditingController purityRateController;
  late TextEditingController laborCostController;
  late TextEditingController gramController;
  late TextEditingController salesGramsController;
  late TextEditingController costController;

  late ButtonStyles buttonStyles;
  Color cursorColor = Colors.white;
  List<TextInputFormatter> inputFormattersDouble = <TextInputFormatter>[
    inputFormatDouble,
  ];
  List<TextInputFormatter> inputFormattersOnlyDigits = <TextInputFormatter>[
    inputFormatOnlyDigits,
  ];

  _GoldProductAddScreenState() {
    // initializeDateFormatting('tr_TR', null);
    buttonStyles = ButtonStyles();
    dropdownValue = Carat.twentyFour;
    barcodeNo = '0000000000000';
    pieceController = TextEditingController();
    nameController = TextEditingController();
    purityRateController = TextEditingController();
    laborCostController = TextEditingController();
    gramController = TextEditingController();
    salesGramsController = TextEditingController();
    costController = TextEditingController();
    purityRateController.text = OutputFormatters.buildNumberFormat1f(
        dropdownValue.purityRateDefinition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: const MyDrawer(),
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: secondColor,
            borderRadius: BorderRadius.circular(25),
          ),
          width: MediaQuery.of(context).size.width - 300,
          height: MediaQuery.of(context).size.height - 90,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: DataTable(
                dataRowMinHeight: 48,
                dataRowMaxHeight: 55,
                columnSpacing: 30,
                horizontalMargin: 50,
                showCheckboxColumn: false,
                border: DataTableStyles.buildTableBorder(),
                columns: buildDataColumns(),
                rows: buildDataRows(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> buildDataColumns() {
    return [
      DataColumn(
        label: Text(
          '    Barkod No:',
          textAlign: TextAlign.center,
          style: buildTextStyle(),
        ),
      ),
      DataColumn(
        label: Text(
          '$barcodeNo      ',
          textAlign: TextAlign.center,
          style: buildTextFormFieldTextStyle(),
        ),
      ),
      DataColumn(
        label: buildBarcodeGeneratorButton(),
      ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return [
      buildDataRow(
        label: '    Adet:',
        formWidget: buildTextFormField(
          controller: pieceController,
          inputFormatters: inputFormattersOnlyDigits,
          onChanged: (value) {
            setState(() {
              pieceController;
              buttonStyles;
            });
          },
        ),
      ),
      buildDataRow(
        label: '    İsim:',
        formWidget: buildTextFormField(
          controller: nameController,
          inputFormatters: [],
          onChanged: (value) {
            setState(() {
              nameController;
              buttonStyles;
            });
          },
        ),
      ),
      buildDataRow(
        label: '    Ayar:',
        formWidget: buildDropdownButtonFormField(),
      ),
      buildDataRow(
        label: '    Saflık Oranı:',
        formWidget: buildTextFormField(
          controller: purityRateController,
          inputFormatters: inputFormattersDouble,
          onChanged: (value) {
            setState(() {
              laborCostController;
              buttonStyles;
            });
            buildCalculate();
          },
        ),
      ),
      buildDataRow(
        label: '    İşçilik:',
        formWidget: buildTextFormField(
          controller: laborCostController,
          inputFormatters: inputFormattersDouble,
          onChanged: (value) {
            setState(() {
              laborCostController;
              buttonStyles;
            });
            buildCalculate();
          },
        ),
      ),
      buildDataRow(
        label: '    Gram:',
        formWidget: buildTextFormField(
          controller: gramController,
          inputFormatters: inputFormattersDouble,
          onChanged: (value) {
            setState(() {
              gramController;
              buttonStyles;
            });
          },
        ),
      ),
      buildDataRow(
        label: '    Satış Gramı:',
        formWidget: buildTextFormField(
          controller: salesGramsController,
          inputFormatters: inputFormattersDouble,
          onChanged: (value) {
            setState(() {
              salesGramsController;
              buttonStyles;
            });
            buildCalculate();
          },
        ),
      ),
      buildDataRow(
        label: '    Maliyet:',
        formWidget: buildTextFormField(
          controller: costController,
          inputFormatters: inputFormattersDouble,
          onChanged: (value) {
            setState(() {
              costController;
              buttonStyles;
            });
          },
        ),
      ),
      DataRow(
        cells: [
          DataCell(
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: ElevatedButton(
                      style: buildSaveButtonStyle(),
                      onPressed: onSaved,
                      child: Text(
                        '   Kaydet   ',
                        style: buildButtonTextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: buttonStyles.buildBasicButtonStyle(),
                onPressed: onRefresh,
                child: Text(
                  '   Yenile   ',
                  style: buildButtonTextStyle(),
                ),
              ),
            ),
          ),
          DataCell(
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                style: buttonStyles.buildBasicButtonStyle(),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context,
                      '/gold-products-inventory-screen', (route) => false);
                },
                child: Text(
                  ' Geri Dön ',
                  style: buildButtonTextStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  DataRow buildDataRow({
    required String label,
    required Center formWidget,
  }) {
    return DataRow(
      cells: [
        DataCell(
          buildFirstDataCell(
            label: label,
          ),
        ),
        DataCell(
          formWidget,
        ),
        const DataCell(Text('')),
      ],
    );
  }

  SizedBox buildFirstDataCell({required String label}) {
    return SizedBox(
      width: 250,
      child: Text(
        label,
        textAlign: TextAlign.start,
        style: buildTextStyle(),
      ),
    );
  }

  Center buildTextFormField({
    required TextEditingController controller,
    required List<TextInputFormatter> inputFormatters,
    required void Function(String)? onChanged,
  }) {
    return Center(
      child: TextFormField(
        validator: NumberValidator.validate,
        controller: controller,
        style: buildTextFormFieldTextStyle(),
        decoration: buildFormDecor(),
        cursorColor: cursorColor,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
      ),
    );
  }

  Center buildDropdownButtonFormField() {
    return Center(
      child: DropdownButtonFormField(
        alignment: Alignment.centerLeft,
        value: dropdownValue,
        icon: Icon(
          Icons.arrow_downward,
          color: cursorColor,
        ),
        dropdownColor: backgroundColor,
        decoration: DecorationStyles.buildDropdownButtonInputDecoration(),
        style: buildTextFormFieldTextStyle(),
        items: buildDropdownMenuItemList(),
        onChanged: (Carat? newValue) {
          dropdownValue = newValue!;
          purityRateController.text = OutputFormatters.buildNumberFormat1f(
              dropdownValue.purityRateDefinition);
          setState(() {
            purityRateController;
            buttonStyles;
          });
          buildCalculate();
        },
      ),
    );
  }

  ElevatedButton buildBarcodeGeneratorButton() {
    return ElevatedButton(
      style: buttonStyles.buildBasicButtonStyle(),
      onPressed: () {
        barcodeNo = BarcodeService.generateCode();
        setState(() {
          barcodeNo;
        });
      },
      child: Text(
        'Barkod Oluştur',
        style: buildButtonTextStyle(),
      ),
    );
  }

  List<DropdownMenuItem<Carat>> buildDropdownMenuItemList() {
    return Carat.values.map<DropdownMenuItem<Carat>>((Carat value) {
      return DropdownMenuItem<Carat>(
        alignment: AlignmentDirectional.center,
        value: value,
        child: Text(
          value.intDefinition.toString(),
          style: TextStyles.buildTextFormFieldTextStyle(),
          textAlign: TextAlign.right,
        ),
      );
    }).toList();
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  TextStyle buildTextFormFieldTextStyle() {
    return const TextStyle(
      fontSize: 26,
      height: 0.9,
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle buildButtonTextStyle() {
    return const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  ButtonStyle buildSaveButtonStyle() {
    return buttonStyles.buildSaveButtonStyle(
      (isVariablesEmpty() || isCorrectFormat() || barcodeNo == '0000000000000'),
    );
  }

  InputDecoration buildFormDecor() {
    return DecorationStyles.buildInputDecoration(const Size(240, 38));
  }

  bool isVariablesEmpty() {
    return pieceController.text.isEmpty ||
        nameController.text.isEmpty ||
        purityRateController.text.isEmpty ||
        laborCostController.text.isEmpty ||
        gramController.text.isEmpty ||
        salesGramsController.text.isEmpty ||
        costController.text.isEmpty;
  }

  bool isCorrectFormat() {
    return double.tryParse(purityRateController.text.replaceAll(",", ".")) ==
            null ||
        int.tryParse(pieceController.text) == null ||
        double.tryParse(laborCostController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(gramController.text.replaceAll(",", ".")) == null ||
        double.tryParse(costController.text.replaceAll(",", ".")) == null ||
        double.tryParse(salesGramsController.text.replaceAll(",", ".")) == null;
  }

  void onSaved() async {
    if (barcodeNo == '0000000000000') {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Barkod oluşturun!'),
          actions: [
            TextButton(
              child: const Text('Tamam'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else if (isVariablesEmpty()) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Boş alanları doldurun!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else if (isCorrectFormat()) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Doğru formatta veri girin!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      /*showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });*/

      Map<String, dynamic> goldProductJson = GoldProduct(
        barcodeText: barcodeNo,
        piece: int.parse(pieceController.text),
        name: nameController.text,
        carat: dropdownValue,
        gram: double.parse(gramController.text.replaceAll(',', '.')),
        purityRate:
            double.parse(purityRateController.text.replaceAll(",", ".")),
        laborCost: double.parse(laborCostController.text.replaceAll(',', '.')),
        cost: double.parse(costController.text.replaceAll(',', '.')),
        salesGrams:
            double.parse(salesGramsController.text.replaceAll(',', '.')),
      ).toJson();

      try {
        GoldProductDbHelper()
            .insert(goldProductJson)
            .then(
              (value) => {
                GoldProductDbHelper().products.add(
                      GoldProduct.fromJson(goldProductJson, value),
                    ),
              },
            );
        ProductEntry productEntry = ProductEntry(
          product: goldProductJson,
          enteredDate: DateTime.now(),
          piece: int.parse(pieceController.text),
        );
        ProductEntryDbHelper()
            .insert(productEntry.toJson())
            .then((value) => {
          ProductEntryDbHelper().entries.add(
              ProductEntry.fromJson(productEntry.toJson(), value)),
          onRefresh(),
          //Navigator.of(context).pop(),
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/gold-product-add-screen', (route) => false),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  void onRefresh() {
    return setState(
      () {
        barcodeNo = '0000000000000';
        pieceController.text = '';
        nameController.text = '';
        dropdownValue = Carat.twentyFour;
        purityRateController.text = OutputFormatters.buildNumberFormat1f(
            dropdownValue.purityRateDefinition);
        laborCostController.text = '';
        gramController.text = '';
        costController.text = '';
        salesGramsController.text = '';
      },
    );
  }

  void buildCalculate() {
    if (purityRateController.text.isNotEmpty &&
        salesGramsController.text.isNotEmpty &&
        laborCostController.text.isNotEmpty) {
      setState(() {
        double cost = Calculator.calculateCostPrice(
              double.parse(purityRateController.text.replaceAll(",", ".")),
              // salesGran vs gram
              double.parse(salesGramsController.text.replaceAll(",", ".")),
              double.parse(laborCostController.text.replaceAll(",", ".")),
            ) /
            1000;
        costController.text = OutputFormatters.buildNumberFormat3f(cost);
      });
    }
  }
}
