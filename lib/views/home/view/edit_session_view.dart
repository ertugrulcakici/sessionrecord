import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/product/model/game_model.dart';
import 'package:sessionrecord/product/model/session_model.dart';
import 'package:sessionrecord/utils/extentions/datetime_extentions.dart';
import 'package:sessionrecord/utils/validators.dart';
import 'package:sessionrecord/views/home/viewmodel/home_viewmodel.dart';

class EditSessionView extends ConsumerStatefulWidget {
  const EditSessionView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSessionViewState();
}

class _EditSessionViewState extends ConsumerState<EditSessionView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _sessionData = {
    "hour": "",
    "name": "",
    "count": 0,
    "video": false,
    "addedBy": "",
    "gameId": "",
  };

  @override
  Widget build(BuildContext context) {
    final _data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final GameModel _game = _data["game"];
    final String _hour = _data["hour"];
    final DateTime _date = _data["date"];
    final ChangeNotifierProvider<HomeViewModel> provider = _data["provider"];

    SessionModel? _session;
    if (_data.containsKey("session")) {
      _session = _data["session"];
    }

    _sessionData["gameId"] = _game.id;
    _sessionData["hour"] = _hour;

    return WillPopScope(
      onWillPop: () async {
        if (_session != null) {
          if (_formKey.currentState!.validate()) {
            await ref.read(provider).updateSession(_session);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Değişiklikler kaydedildi")));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Veriler düzgün girilmemiş !!!")));
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_session == null) {
                ref.read(provider).addSession(_sessionData, _date, _game);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Seans eklendi")));
              } else {
                ref.read(provider).updateSession(_session);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Değişiklikler kaydedildi")));
              }
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Veriler düzgün girilmemiş !!!")));
            }
          },
        ),
        appBar: AppBar(
          title: Text(_hour +
              "\t-\t" +
              _game.name +
              "\t-\t" +
              _date.toDayMonthYearString()),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                        initialValue: _session?.name,
                        onChanged: (value) => _session != null
                            ? _session.name = value
                            : _sessionData["name"] = value,
                        decoration: const InputDecoration(labelText: "İsim")),
                    TextFormField(
                        initialValue: _session?.count.toString(),
                        decoration: const InputDecoration(labelText: "Sayı"),
                        keyboardType: TextInputType.number,
                        validator: validateInt,
                        onChanged: (value) => _session != null
                            ? _session.count = int.parse(value)
                            : _sessionData["count"] = int.parse(value)),
                    CheckboxListTile(
                        title: const Text("Video"),
                        value: _session != null
                            ? _session.video
                            : _sessionData["video"],
                        onChanged: (data) => setState(() {
                              _session != null
                                  ? _session.video = data ?? false
                                  : _sessionData["video"] = data;
                            })),
                    TextFormField(
                        initialValue: _sessionData.containsKey("phoneNumber")
                            ? _sessionData["phoneNumber"]
                            : "",
                        validator: validatePhoneNumber,
                        onChanged: (value) {
                          if (_session != null) {
                            if (value != "") {
                              _session.phoneNumber = value;
                            } else {
                              _session.phoneNumber = null;
                            }
                          } else {
                            if (value != "") {
                              _sessionData["phoneNumber"] = value;
                            } else {
                              _sessionData.remove("phoneNumber");
                            }
                          }
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: "Tel no")),
                    TextFormField(
                        initialValue: _sessionData.containsKey("extra")
                            ? _sessionData["extra"].toString()
                            : "",
                        validator: validateDouble,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => value != ""
                            ? _sessionData["extra"] = double.parse(value)
                            : _sessionData.remove("extra"),
                        decoration: const InputDecoration(labelText: "Ekstra")),
                    TextFormField(
                        initialValue: _sessionData.containsKey("discount")
                            ? _sessionData["discount"].toString()
                            : "",
                        validator: validateDouble,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => value != ""
                            ? _sessionData["discount"] = double.parse(value)
                            : _sessionData.remove("discount"),
                        decoration: const InputDecoration(labelText: "Eksik")),
                    TextFormField(
                        initialValue: _sessionData.containsKey("note")
                            ? _sessionData["note"]
                            : "",
                        onChanged: (value) => value != ""
                            ? _sessionData["note"] = value
                            : _sessionData.remove("note"),
                        decoration: const InputDecoration(labelText: "Not")),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
