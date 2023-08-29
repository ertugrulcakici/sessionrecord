// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:sessionrecord/core/service/firebase/auth_service.dart';
import 'package:sessionrecord/core/service/firebase/firebase_service.dart';
import 'package:sessionrecord/product/model/expanse_model.dart';
import 'package:sessionrecord/product/model/game_model.dart';
import 'package:sessionrecord/product/model/session_model.dart';
import 'package:sessionrecord/product/model/user_model.dart';
import 'package:sessionrecord/utils/extentions/datetime_extentions.dart';

class HomeViewModel extends ChangeNotifier with FirebaseService {
  HomeViewModel();

  late GameModel _selectedGame;
  GameModel get selectedGame => _selectedGame;
  set selectedGame(GameModel value) {
    _selectedGame = value;
    currentTab = selectedGameIndex;
    notifyListeners();
  }

  int get selectedGameIndex =>
      games.indexWhere((game) => game.id == selectedGame.id);

  int _currentTab = 0;
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int get currentTab => _currentTab;
  set currentTab(int value) {
    _currentTab = value;
    getSessions();
  }

  DateTime get date => _date;
  set date(DateTime value) {
    _date = value;
    getSessions();
  }

  int old = 0;
  int _counter = 0;

  bool initDone = false;
  Future<bool> init() async {
    if (initDone) return true;

    _currentTab = 0;
    await fillGames();
    await fillUsers();
    firestore.collection("sessions").snapshots().listen((snapshot) {
      if (_counter % 2 == 0) {
        if (initDone) {
          String status = "";
          if (old > snapshot.docs.length) {
            status = "silindi";
          } else if (old == snapshot.docs.length) {
            status = "düzenlendi";
          } else {
            status = "eklendi";
          }
          old = snapshot.docs.length;
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'sessionrecord_channel',
                  title: 'Seans kayıt uygulaması',
                  body: 'Seans $status'));
          getSessions();
        }
      }
      _counter++;
    });
    initDone = true;
    return true;
  }

  List<GameModel> games = [];
  List<SessionModel> sessions = [];
  List<UserModel> users = [];

  Future fillGames() async {
    games.clear();
    final _result = await firestore.collection("games").get();
    for (var element in _result.docs) {
      final _data = element.data();
      final _game = GameModel(
        id: element.id,
        name: _data["name"],
        hours: _data["hours"],
        person_fee: _data["person_fee"],
        person_fee_double: _data["person_fee_double"],
        video_fee: _data["video_fee"],
      );
      games.add(_game);
    }
    selectedGame = games.first;
    notifyListeners();
  }

  Future refresh() async {
    await fillGames();
    await fillUsers();
    await getSessions();
  }

  Future fillUsers() async {
    users.clear();
    final _result = await firestore.collection("users").get();
    for (var element in _result.docs) {
      final _data = element.data();
      final _user = UserModel(
        id: element.id,
        username: _data["username"],
      );
      users.add(_user);
    }
  }

  Future getSessions() async {
    sessions.clear();
    final _result = await firestore
        .collection("sessions")
        .where("date", isEqualTo: date.toDayMonthYearString())
        .where("gameId", isEqualTo: selectedGame.id)
        .get();

    for (var element in _result.docs) {
      sessions.add(SessionModel.fromJson(element.data()));
    }
    notifyListeners();
  }

  Future<bool> addExpanse(ExpanseModel expanse) async {
    firestore.collection("expanses").add(expanse.toJson());
    return true;
  }

  Future deleteSession(SessionModel session) async {
    firestore.collection("sessions").doc(session.id).delete();
    sessions.removeWhere((element) => element.id == session.id);
    notifyListeners();
  }

  Future updateSession(SessionModel session) async {
    firestore.collection("sessions").doc(session.id).update(session.toJson());
    for (var element in sessions) {
      if (element.id == session.id) {
        element = session;
      }
    }
    notifyListeners();
  }

  Future addSession(
      Map<String, dynamic> sessionData, DateTime date, GameModel game) async {
    final _session = SessionModel(
        gameId: sessionData["gameId"],
        count: sessionData["count"],
        hour: sessionData["hour"],
        name: sessionData["name"],
        video: sessionData["video"],
        id: firestore.collection("sessions").doc().id,
        date: date.toDayMonthYearString(),
        addedBy: AuthService.currentUser.id!,
        discount: sessionData.containsKey("discount")
            ? sessionData["discount"]
            : null,
        extra: sessionData.containsKey("extra") ? sessionData["extra"] : null,
        note: sessionData.containsKey("note") ? sessionData["note"] : null,
        phoneNumber: sessionData.containsKey("phoneNumber")
            ? sessionData["phoneNumber"]
            : null,
        income: (sessionData["count"] == 2
                ? sessionData["count"] * game.person_fee_double
                : sessionData["count"] * game.person_fee) +
            (sessionData["extra"] ?? 0) -
            (sessionData["discount"] ?? 0) +
            (sessionData["video"] ? game.video_fee : 0));

    firestore.collection("sessions").doc(_session.id).set(_session.toJson());
    sessions.add(_session);
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
