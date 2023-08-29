import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sessionrecord/core/service/firebase/firebase_service.dart';
import 'package:sessionrecord/product/model/user_model.dart';

class UserViewModel extends ChangeNotifier with FirebaseService {
  UserViewModel();

  List<UserModel> users = [];

  Future init() async {
    await firestore.collection("users").get().then((value) {
      for (var element in value.docs) {
        final _userData = element.data();
        users.add(UserModel(
          is_admin: _userData["is_admin"],
          username: _userData["username"],
          id: _userData["id"],
          password: _userData["password"],
          token: _userData["token"],
        ));
      }
    });
    notifyListeners();
  }

  Future<dynamic> deleteUser(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.id).delete().then((value) {
        users.remove(user);
      });
      return true;
    } catch (e) {
      return e;
    } finally {
      notifyListeners();
    }
  }

  Future<dynamic> addUser(UserModel user) async {
    try {
      String id = firestore.collection("users").doc().id;
      user.id = id;
      firestore
          .collection("users")
          .doc(id)
          .set(user.toJson(), SetOptions(merge: true))
          .then((value) {
        users.add(user);
      });
      return true;
    } catch (e) {
      return e;
    } finally {
      Future.delayed(
          const Duration(milliseconds: 500), () => notifyListeners());
    }
  }
}
