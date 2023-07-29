class Log {
  late DateTime dateTime;
  late String? errorMessage;
  late Map? process;

  Log({required this.dateTime, this.errorMessage, this.process});

  Map toMap() {
    return {
      'dateTime' : dateTime.toIso8601String(),
      'errorMessage' : errorMessage,
      'process' : process,
    };
  }
}