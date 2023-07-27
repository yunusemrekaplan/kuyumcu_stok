import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  String? barcodeTextFormField;
  String? earningRate;

  TextEditingController barcodeTextEditingController = TextEditingController();
  TextEditingController earningRateTextEditingController =
      TextEditingController();
  TextEditingController saleTextEditingController = TextEditingController();

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
      ),
    );
  }

  Padding _buildCalculatingButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0),
      child: ElevatedButton(
        onPressed: () {},
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

  Row _buildProductInformationRow() {
    return const Row(
      children: [
        // Carat of product
        Padding(
          padding: EdgeInsets.only(left: 20, top: 34),
          child: Row(
            children: [
              Text(
                'Karat: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                '24',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 34),
          child: Row(
            children: [
              Text(
                'Gram: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                '13',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 34),
          child: Row(
            children: [
              Text(
                'Maliyet: ',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                width: 116,
                child: Text(
                  '4568',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, top: 34),
          child: Row(
            children: [
              Text(
                'Son fiyat: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                '5320',
                style: TextStyle(fontSize: 22),
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
        onPressed: () {},
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
              onPressed: () {},
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
      width: 320,
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
        rows: const [
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Has Altın',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '1.650',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '1.700',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Gram',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '1687',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '1715',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Ons',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '1.945',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '1.945',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Usd/Kg',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '62.570',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '62.770',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Eur/Kg',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '56.970',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              DataCell(
                Text(
                  '57.260',
                  style: TextStyle(
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
}
