import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/services/gold_service.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  String? barcodeTextFormField;
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
  String priceTxt = '....';

  TextEditingController barcodeTextEditingController = TextEditingController();
  TextEditingController earningRateTextEditingController =
      TextEditingController();
  TextEditingController saleTextEditingController = TextEditingController();

  @override
  void initState() {
    var map;
    GoldService.getGoldPrices().then(
      (value) => setState(
        () {
          map = value;
          fineGoldBuy = map['fine_gold_buy'];
          fineGoldSale = map['fine_gold_sale'];
          usdBuy = map['USD_buy'];
          usdSale = map['USD_sale'];
          eurBuy = map['EUR_buy'];
          eurSale = map['EUR_sale'];
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
        onChanged: (value) {

        },
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
                'Son fiyat: ',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                priceTxt,
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
}
