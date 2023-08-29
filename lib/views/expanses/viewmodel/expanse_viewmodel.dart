import "package:flutter/material.dart";
import 'package:sessionrecord/core/service/firebase/firebase_service.dart';
import 'package:sessionrecord/product/model/expanse_model.dart';

class ExpanseViewModel extends ChangeNotifier with FirebaseService {
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();

  ExpanseViewModel();

  Future getExpanseList() async {
    List<ExpanseModel> _list = [];
    await firestore.collection("expanse").get().then((value) {
      notifyListeners();
    });
  }
}
