import 'package:kuyumcu_stok/enum/my_error.dart';

extension ToString on MyError {
  String get stringDefinition {
    switch (this) {
      case MyError.dataBaseOpen:
        return 'DataBase Open Error';
      case MyError.dataBaseQueryAllRows:
        return 'DataBase QueryAllRows Error';
      case MyError.dataBaseGetById:
        return 'DataBase GetById Error';
      case MyError.dataBaseInsert:
        return 'DataBase Insert Error';
      case MyError.dataBaseUpdate:
        return 'DataBase Update Error';
      case MyError.dataBaseDelete:
        return 'DataBase Delete Error';
      case MyError.unknownError:
        return 'Unknown Error';
    }
  }
}

extension ToMyError on String {
  MyError get myErrorDefinition {
    switch (this) {
      case 'DataBase Open Error':
        return MyError.dataBaseOpen;
      case 'DataBase QueryAllRows Error':
        return MyError.dataBaseQueryAllRows;
      case 'DataBase GetById Error':
        return MyError.dataBaseGetById;
      case 'DataBase Insert Error':
        return MyError.dataBaseInsert;
      case 'DataBase Update Error':
        return MyError.dataBaseUpdate;
      case 'DataBase Delete Error':
        return MyError.dataBaseDelete;
      default:
        return MyError.unknownError;
    }
  }
}