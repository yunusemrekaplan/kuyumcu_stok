class Product {
  late int id;
  late String barcodeText;
  late String barcodePath;
  late String name;
  late int carat; // x
  late double gram; // y
  late double costGram; // t
  late double mil; // z
  late double costPrice; // s

  // (x + z) * y = t
  // t * g = s
  // (x + z) * y * g = s

  Product({required this.name, required this.gram, required this.mil});
}