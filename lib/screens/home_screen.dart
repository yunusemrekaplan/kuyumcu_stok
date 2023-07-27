// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:kuyumcu_stok/screens/barcode_screen.dart';
import 'package:kuyumcu_stok/widgets/my_drawer.dart';

import 'dart:typed_data';
import 'dart:io';

import 'package:aspose_barcode_cloud/api.dart';
import 'package:http/http.dart' as http;
import 'package:aspose_barcode_cloud/api.dart' as barcode;


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                generateBarcode();
                //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BarcodeScreen()));
              },
              child: Text('Barkod Üret', style: TextStyle(fontSize: 26,),),
            ),
            /*TextButton(
              onPressed: () {},
              style: const ButtonStyle(
                textStyle: MaterialStatePropertyAll(
                  TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              child: const Text('Ürünler'),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> generateBarcode() async {
    //String fileName = "isbn$counter"".png";
    //counter++;

    const fileName = 'isbn.png';

    final apiClient = barcode.ApiClient(
      clientId: '8db0173e-794a-4e7c-b8d7-778253fb2d6a',
      clientSecret: '96102d9afec010df26c8f421a55adbfc',
    );

    final api = barcode.BarcodeApi(apiClient);

    Uint8List? generated = await api.getBarcodeGenerate("ISBN", "9789756249840", alwaysShowChecksum: true,);
    await File(fileName).writeAsBytes(generated);
    print("Generated image saved to $fileName");

    //print(await api.putBarcodeGenerateFile("isbn.png", "ISBN", "123456789"));

    /*final formFile = http.MultipartFile.fromBytes("image", [generated.length], filename: "barcode.png");
    BarcodeResponseList? recognized = await api.postBarcodeRecognizeFromUrlOrContent(url: 'C:\\FlutterProjects\\kuyumcu_stok\\isbn.png' ,image: formFile);

    print("Recognized Type: ${recognized.barcodes![0].type!}");
    print("Recognized Value: ${recognized.barcodes![0].barcodeValue!}");*/

    //print(await api.getBarcodeGenerate('ISBN', 'isbn'));
    //print(barcode.StorageExist());
  }
}
