import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/product/model/game_model.dart';
import 'package:sessionrecord/product/model/session_model.dart';
import 'package:sessionrecord/product/model/user_model.dart';
import 'package:sessionrecord/views/home/viewmodel/home_viewmodel.dart';

class SessionWidget extends ConsumerWidget {
  SessionModel? sessionModel;
  String hour;
  GameModel game;
  ChangeNotifierProvider<HomeViewModel> provider;
  SessionWidget(
      {Key? key,
      this.sessionModel,
      required this.hour,
      required this.game,
      required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String subtitle = "";
    if (sessionModel != null) {
      subtitle += "Kişi sayısı: ${sessionModel!.count}\n";
      if (sessionModel!.discount != null) {
        subtitle += "İndirim: ${sessionModel!.discount}\n";
      }
      if (sessionModel!.extra != null) {
        subtitle += "Ekstra: ${sessionModel!.extra}\n";
      }
      if (sessionModel!.note != null) {
        subtitle += "Not: ${sessionModel!.note}\n";
      }
      if (sessionModel!.phoneNumber != null) {
        subtitle += "Telefon: ${sessionModel!.phoneNumber}\n";
      }
      subtitle +=
          "Ekleyen kişi: ${ref.watch(provider).users.firstWhere((element) => element.id == sessionModel!.addedBy, orElse: () => UserModel(username: "Silinmiş hesap")).username}\n";
    }

    return Card(
      child: ListTile(
        leading: Text(hour,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        title: sessionModel != null
            ? Center(
                child: Text(
                sessionModel!.name.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ))
            : null,
        subtitle: Text(subtitle),
        trailing: sessionModel != null
            ? sessionModel!.video
                ? const Icon(Icons.video_call)
                : null
            : null,
        isThreeLine: true,
        tileColor: _isPassed() ? Colors.red.shade300 : Colors.white,
        onTap: () async {
          if (sessionModel == null) {
            _addSession(context, ref);
          } else {
            _editSession(context, ref);
          }
        },
        onLongPress: sessionModel != null
            ? () {
                AwesomeDialog(
                  title: "Silmek istediğine emin misin?",
                  context: context,
                  dialogType: DialogType.QUESTION,
                  animType: AnimType.BOTTOMSLIDE,
                  btnCancelColor: Colors.red,
                  btnCancelText: "Sil",
                  btnCancelOnPress: () {
                    ref.read(provider).deleteSession(sessionModel!);
                  },
                  btnOkColor: Colors.green,
                  btnOkText: "İptal",
                  btnOkOnPress: () {},
                ).show();
              }
            : null,
      ),
    );
  }

  bool _isPassed() {
    final _now = DateTime.now();
    final _nowHour = _now.hour;
    final _nowMinute = _now.minute;
    final _hour = int.parse(hour.split(":")[0]);
    final _minute = int.parse(hour.split(":")[1]);
    if (_nowHour > _hour) {
      return true;
    } else if (_nowHour == _hour) {
      if (_nowMinute > _minute) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  _addSession(BuildContext context, WidgetRef ref) async {
    await Navigator.pushNamed(context, "/edit_session", arguments: {
      "game": game,
      "hour": hour,
      "date": ref.watch(provider).date,
      "provider": provider
    });
    ref.read(provider).notify();
  }

  _editSession(BuildContext context, WidgetRef ref) async {
    await Navigator.pushNamed(context, "/edit_session", arguments: {
      "game": game,
      "hour": hour,
      "date": ref.watch(provider).date,
      "provider": provider,
      "session": sessionModel,
    });
    ref.read(provider).notify();
  }
}
