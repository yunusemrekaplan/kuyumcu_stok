import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/services/isbn_service.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

import '../enum_carat.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}
// ToDo validatörleri unutma!!!

class _ProductAddScreenState extends State<ProductAddScreen> {
  late String barcodeNo;

  late TextEditingController nameController;
  late TextEditingController caratController;
  late TextEditingController gramController;
  late TextEditingController costGramController;
  late TextEditingController milController;
  late TextEditingController costPriceController;

  late Carat dropdownValue;

  _ProductAddScreenState() {
    dropdownValue = Carat.twentyFour;
    barcodeNo = '0000000000000';
    nameController = TextEditingController();
    caratController = TextEditingController();
    gramController = TextEditingController();
    costGramController = TextEditingController();
    milController = TextEditingController();
    costPriceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'Barkod No: ',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  width: 180,
                  child: Text(
                    barcodeNo,
                    style: const TextStyle(
                      fontSize: 22,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    barcodeNo = IsbnService.generateCode();
                    setState(() {
                      barcodeNo;
                    });
                  },
                  child: const Text(
                    'Barkod Oluştur',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Barkodu Çıkart',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'İsim: ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                // ToDo validatörleri unutma!!!
                Container(
                  width: 200,
                  height: 35,
                  alignment: Alignment.bottomLeft,
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                      border: const OutlineInputBorder(),
                      constraints: BoxConstraints.tight(const Size(150, 30)),
                      //hintText: '9789756249840',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const Text(
                    'Karat: ',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  DropdownButtonFormField(
                    alignment: Alignment.centerLeft,
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      constraints: BoxConstraints.tight(const Size(100, 120)),
                    ),
                    items: Carat.values
                        .map<DropdownMenuItem<Carat>>((Carat value) {
                      return DropdownMenuItem<Carat>(
                        alignment: AlignmentDirectional.center,
                        value: value,
                        child: Text(
                          value.intDefinition.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    }).toList(),
                    onChanged: (Carat? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    /*
                    <int>[
                      Carat.twentyFour.intDefinition,
                      Carat.values.
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                     */
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'Gram: ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                // ToDo validatörleri unutma!!!
                TextFormField(
                  controller: gramController,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                    border: const OutlineInputBorder(),
                    constraints: BoxConstraints.tight(const Size(90, 35)),
                    //hintText: '9789756249840',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'Gram Maliyeti: ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                // ToDo validatörleri unutma!!!
                Container(
                  width: 100,
                  height: 35,
                  alignment: Alignment.bottomLeft,
                  child: TextFormField(
                    controller: costGramController,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                      border: const OutlineInputBorder(),
                      constraints: BoxConstraints.tight(const Size(100, 30)),
                      //hintText: '9789756249840',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'Milyem: ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                // ToDo validatörleri unutma!!!
                Container(
                  width: 100,
                  height: 35,
                  alignment: Alignment.bottomLeft,
                  child: TextFormField(
                    controller: milController,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                      border: const OutlineInputBorder(),
                      constraints: BoxConstraints.tight(const Size(100, 30)),
                      //hintText: '9789756249840',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                const Text(
                  'Maliyet Fiyatı: ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                // ToDo validatörleri unutma!!!
                Container(
                  width: 100,
                  height: 35,
                  alignment: Alignment.bottomLeft,
                  child: TextFormField(
                    controller: costPriceController,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 20),
                      border: const OutlineInputBorder(),
                      constraints: BoxConstraints.tight(const Size(100, 30)),
                      //hintText: '9789756249840',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 16, bottom: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
