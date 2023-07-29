class Barcode {
  late int id;
  late String text;
  late String path;

  Barcode({
    required this.text,
    required this.path,
  });

  Barcode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'path': path,
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      'id' : id,
      'text': text,
      'path': path,
    };
  }
}
