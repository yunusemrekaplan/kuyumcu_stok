class NumberValidator {
  static String? validate(String? value) {
    if (value == null) {
      return 'Boş alanları doldurun.';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'Lütfen sadece sayı girin.';
    }
    return null;
  }
}