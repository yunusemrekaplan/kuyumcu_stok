// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuyumcu_stok/calculator.dart';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
import 'package:kuyumcu_stok/enum/carat.dart';
import 'package:kuyumcu_stok/enum/extension/carat_extension.dart';
import 'package:kuyumcu_stok/localization/input_formatters.dart';
import 'package:kuyumcu_stok/localization/output_formatters.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';
import 'package:kuyumcu_stok/styles/button_styles.dart';
import 'package:kuyumcu_stok/styles/data_table_styles.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';
import 'package:kuyumcu_stok/styles/text_styles.dart';
import 'package:kuyumcu_stok/theme/theme.dart';
import 'package:kuyumcu_stok/validations/number_validator.dart';
import 'package:kuyumcu_stok/widgets/app_bar.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class GoldProductEditScreen extends StatefulWidget {
  late GoldProduct product;
  GoldProductEditScreen({super.key, required this.product});

  @override
  State<GoldProductEditScreen> createState() =>
      _GoldProductEditScreenState(product: product);
}

class _GoldProductEditScreenState extends State<GoldProductEditScreen> {
  late GoldProduct product;
  late Carat dropdownValue;
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

  _GoldProductEditScreenState({required this.product}) {
    buttonStyles = ButtonStyles();
    dropdownValue = product.carat;
    nameController = TextEditingController();
    purityRateController = TextEditingController();
    laborCostController = TextEditingController();
    gramController = TextEditingController();
    salesGramsController = TextEditingController();
    costController = TextEditingController();
    purityRateController.text = OutputFormatters.buildNumberFormat1f(
        dropdownValue.purityRateDefinition);
    nameController.text = product.name.toString();
    purityRateController.text = OutputFormatters.buildNumberFormat1f(product.purityRate);
    laborCostController.text = OutputFormatters.buildNumberFormat1f(product.laborCost);
    gramController.text = OutputFormatters.buildNumberFormat3f(product.gram);
    salesGramsController.text = OutputFormatters.buildNumberFormat3f(product.salesGrams);
    costController.text = OutputFormatters.buildNumberFormat3f(product.cost);
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
          height: MediaQuery.of(context).size.height - 130,
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
          '    İsim:',
          textAlign: TextAlign.center,
          style: buildTextStyle(),
        ),
      ),
      DataColumn(
        label: buildTextFormField(
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
      const DataColumn(
        label: Text(''),
      ),
    ];
  }

  List<DataRow> buildDataRows(BuildContext context) {
    return [
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
                    child: buildUpdateButtonRow(),
                  ),
                ],
              ),
            ),
          ),
          const DataCell(
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(''),
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

  Align buildUpdateButtonRow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          ElevatedButton(
            style: buttonStyles.buildUpdateButtonStyle(isUpdatable()),
            onPressed: onUpdateFun,
            child: Text(
              'Güncelle',
              style: buildButtonTextStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
      child: Row(
        children: [
          ElevatedButton(
            style: buttonStyles.buildBasicButtonStyle(),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/gold-products-inventory-screen', (route) => false);
            },
            child: Text(
              'Geri Dön',
              style: TextStyles.buildButtonTextStyle(),
            ),
          ),
        ],
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

  InputDecoration buildFormDecor() {
    return DecorationStyles.buildInputDecoration(const Size(240, 38));
  }

  void buildCalculate() {
    if (purityRateController.text.isNotEmpty &&
        salesGramsController.text.isNotEmpty &&
        laborCostController.text.isNotEmpty) {
      setState(() {
        costController.text = OutputFormatters.buildNumberFormat3f(Calculator.calculateCostPrice(
          double.parse(purityRateController.text.replaceAll(",", ".")),
          double.parse(salesGramsController.text.replaceAll(",", ".")),
          double.parse(laborCostController.text.replaceAll(",", ".")),
        ) / 1000);
      });
    }
  }

  void onUpdateFun() {
    if (isUpdatable() == 0) {
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
    } else if (isUpdatable() == 1) {
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
      product.name = nameController.text;
      product.carat = dropdownValue;
      product.gram = double.parse(gramController.text.replaceAll(',', '.'));
      product.laborCost =
          double.parse(laborCostController.text.replaceAll(',', '.'));
      product.cost = double.parse(costController.text.replaceAll(',', '.'));
      product.purityRate =
          double.parse(purityRateController.text.replaceAll(',', '.'));

      GoldProductDbHelper()
          .update(product.toJson(), product.id)
          .then((value) => {
                GoldProductDbHelper()
                    .getProductById(product.id)
                    .then((value) => print(value)),
                Navigator.pushNamedAndRemoveUntil(context,
                    '/gold-products-inventory-screen', (route) => false),
              });
    }
  }

  int isUpdatable() {
    if (nameController.text.isEmpty ||
        purityRateController.text.isEmpty ||
        laborCostController.text.isEmpty ||
        gramController.text.isEmpty ||
        salesGramsController.text.isEmpty ||
        costController.text.isEmpty) {
      return 0;
    }
    if (double.tryParse(purityRateController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(laborCostController.text.replaceAll(",", ".")) ==
            null ||
        double.tryParse(gramController.text.replaceAll(",", ".")) == null ||
        double.tryParse(costController.text.replaceAll(",", ".")) == null) {
      return 1;
    }
    return 2;
  }
}
