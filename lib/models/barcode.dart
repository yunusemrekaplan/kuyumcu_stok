class Barcode {
  late int id;
  late int productId;
  late String text;
  late String path;

  Barcode({
    required this.text,
    required this.path,
  });

  Barcode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    text = json['text'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'text': text,
      'path': path,
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      'id': id,
      'text': text,
      'path': path,
    };
  }
}
