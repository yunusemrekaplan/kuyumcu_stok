// Bu dosyada barkod oluşturma işlemleri yapılıyor.
import 'dart:math';
import 'package:kuyumcu_stok/data/gold_product_db_helper.dart';
// import 'package:aspose_barcode_cloud/api.dart' as barcode;
// import 'package:kuyumcu_stok/model/barcode.dart';

class BarcodeService {
  static const String firstCode = '978';
  static const List<String> numbers = ['1','2','3','4','5','6','7','8','9'];

  // Barkod numarası oluşturma algoritması
  static String generateCode() {
    String res = firstCode;
    int sum = 38; // 9*1 + 7*3 + 8*1

    var random = Random();

    for(int i=0; i<9; i++) {
      int temp = random.nextInt(9);
      res += numbers[temp];
      if(i % 2 == 0) {
        sum += int.tryParse(numbers[temp])! * 3;
      }
      else {
        sum += int.tryParse(numbers[temp])!;
      }
    }

    int checkDigit = (sum % 10 == 0) ? 0 : (10-sum % 10);

    res += checkDigit.toString();

    GoldProductDbHelper().products.where((element) => element.barcodeText == res).isEmpty ? res : generateCode();

    return res;
  }
}

/*// Isbn barkodu oluşturan fonksiyon
  static Future<Barcode> generateBarcode(String code) async {
    //final isbnCode = generateCode();
    final fileName = '$code.png';
    const filePath = 'barcodes/';

    final apiClient = barcode.ApiClient(
      clientId: 'c276982d-208d-479f-88a7-8a8acfe19523',
      clientSecret: 'ea0bdfba04f63c25254eef8c9bdf924f',
    );

    final api = barcode.BarcodeApi(apiClient);

    Uint8List? generated = await api.getBarcodeGenerate("ISBN", code);
    print(await File(filePath+fileName).writeAsBytes(generated));
    print("Generated image saved to $fileName");

    return Barcode(text: code, path: (filePath+fileName));
  }*/