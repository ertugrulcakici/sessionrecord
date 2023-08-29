// ignore_for_file: non_constant_identifier_names

import 'package:sessionrecord/utils/extentions/datetime_extentions.dart';

class ExpanseModel {
  String category;
  double amount;
  String note;
  String added_by;
  DateTime date;

  ExpanseModel({
    // fill all fields with required
    required this.category,
    required this.amount,
    required this.note,
    required this.added_by,
    required this.date,
  });

  toJson() {
    return {
      "category": category,
      "amount": amount,
      "note": note,
      "added_by": added_by,
      "date": date.onlyDate(),
    };
  }
}
