import 'package:flutter/material.dart';
import 'package:sessionrecord/core/service/firebase/firebase_service.dart';
import 'package:sessionrecord/product/model/game_model.dart';

class GameViewModel extends ChangeNotifier with FirebaseService {
  List<GameModel> games = [];

  Future init() async {
    await fillGames();
  }

  Future fillGames() async {
    games.clear();
    await firestore.collection("games").get().then((value) {
      for (var element in value.docs) {
        final _elementData = element.data();
        final _gameModel = GameModel(
          id: element.id,
          name: _elementData["name"],
          hours: _elementData["hours"],
          person_fee: _elementData["person_fee"],
          person_fee_double: _elementData["person_fee_double"],
          video_fee: _elementData["video_fee"],
        );
        games.add(_gameModel);
      }
    });
    notifyListeners();
  }

  Future<dynamic> deleteGame(String id) async {
    try {
      await firestore.collection("games").doc(id).delete();
      return true;
    } catch (e) {
      return e;
    } finally {
      await fillGames();
    }
  }

  Future<dynamic> addGame(Map<String, dynamic> data) async {
    try {
      String id = firestore.collection("games").doc().id;
      data["id"] = id;
      await firestore.collection("games").doc(id).set(data);
      return true;
    } catch (e) {
      return e;
    } finally {
      await fillGames();
    }
  }

  Future<dynamic> editGame(GameModel game) async {
    try {
      await firestore
          .collection("games")
          .doc(game.id)
          .update(game.toJsonWithoutId());
      return true;
    } catch (e) {
      return e;
    } finally {
      await fillGames();
    }
  }
}
