// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kuyumcu_stok/styles/decoration_styles.dart';

class DatePickerRow extends StatefulWidget {
  late String label;
  late DateTime startTime;
  late DateTime endTime;
  late DateTime initialTime;

  DatePickerRow({
    super.key,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.initialTime,
  });

  @override
  State<DatePickerRow> createState() => _DatePickerRowState();
}

class _DatePickerRowState extends State<DatePickerRow> {
  late TextEditingController dateController;

  @override
  void initState() {
    initializeDateFormatting('tr_TR', null);
    dateController = TextEditingController();
    dateController.text = DateFormat.yMd('tr-Tr').format(widget.initialTime);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextFormField(
            controller: dateController,
            decoration: DecorationStyles.buildInputDecoration(const Size(125, 40)),
            style: const TextStyle(
              fontSize: 20,
              height: 1,
            ),
            textAlignVertical: TextAlignVertical.top,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());

              widget.initialTime = (await showDatePicker(
                context: context,
                initialDate: widget.initialTime,
                firstDate: DateTime(DateTime.now().year, DateTime.now().month - 3),
                lastDate: DateTime.now(),
              ))!;

              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format((widget.initialTime));
              String newTime = widget.label == 'Bitiş Tarihi' ? '23:59:59':'00:00:00';
              String newFormattedDate = '${formattedDate.substring(0, 11)}$newTime';
              widget.initialTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(newFormattedDate);

              print(widget.initialTime.hour);
              dateController.text = DateFormat.yMd('tr-Tr').format(widget.initialTime);
            },
          ),
        ),
      ],
    );
  }
}
