import 'package:flutter/material.dart';

class ShowDialogs {
  static final ShowDialogs _instance = ShowDialogs._internal();

  factory ShowDialogs() {
    return _instance;
  }

  ShowDialogs._internal();

  Future errorShowDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text(
              style: TextStyle(fontSize: 20),
              'Tamam',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
