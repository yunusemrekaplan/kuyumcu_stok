class Product {
  late String barcode;
  late int id;
  late int carat; // x
  late double gram; // y
  late double costGram; // t
  late double mil; // z
  late String name;
  late double costPrice; // s

  // (x + z) * y = t
  // t * g = s
  // (x + z) * y * g = s

  Product({required this.name, required this.gram, required this.mil});
}