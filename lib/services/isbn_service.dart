import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:aspose_barcode_cloud/api.dart' as barcode;
import 'package:kuyumcu_stok/models/barcode.dart';

class IsbnService {
  static const String firstCode = '978';
  static const List<String> codes = ['1','2','3','4','5','6','7','8','9'];

  // Barkod numarası oluşturma algoritması
  static String generateCode() {
    String res = firstCode;
    int sum = 38; // 9*1 + 7*3 + 8*1

    var random = Random();

    for(int i=0; i<9; i++) {
      int temp = random.nextInt(9);
      res += codes[temp];
      if(i % 2 == 0) {
        sum += int.tryParse(codes[temp])! * 3;
      }
      else {
        sum += int.tryParse(codes[temp])!;
      }
    }

    int checkDigit = (sum % 10 == 0) ? 0 : (10-sum % 10);

    return res + checkDigit.toString();
  }

  // Isbn barkodu oluşturan fonksiyon
  static Future<Barcode> generateBarcode(String isbnCode) async {
    //final isbnCode = generateCode();
    final fileName = '$isbnCode.png';
    const filePath = 'barcodes/';

    final apiClient = barcode.ApiClient(
      clientId: 'c276982d-208d-479f-88a7-8a8acfe19523',
      clientSecret: 'ea0bdfba04f63c25254eef8c9bdf924f',
    );

    final api = barcode.BarcodeApi(apiClient);

    //"9789756249840"
    Uint8List? generated = await api.getBarcodeGenerate("ISBN", isbnCode);
    print(await File(filePath+fileName).writeAsBytes(generated));
    print("Generated image saved to $fileName");

    return Barcode(text: isbnCode, path: (filePath+fileName));
  }
}