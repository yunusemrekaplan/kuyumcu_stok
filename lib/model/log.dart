import 'package:kuyumcu_stok/enum/extension/my_error_extension.dart';
import 'package:kuyumcu_stok/enum/my_error.dart';

class Log {
  late DateTime dateTime;
  late MyError state;
  late String errorMessage;

  Log({required this.dateTime, required this.state, required this.errorMessage,});

  Log.fromJson(Map<String, dynamic> json) {
    dateTime = DateTime.parse(json['dateTime']);
    state = json['state'].toString().myErrorDefinition;
    errorMessage = json['errorMessage'];
  }

  Map toMap() {
    return {
      'dateTime' : dateTime.toIso8601String(),
      'state' : state.stringDefinition,
      'errorMessage' : errorMessage,
    };
  }
}