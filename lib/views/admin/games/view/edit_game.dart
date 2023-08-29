// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/product/model/game_model.dart';
import 'package:sessionrecord/views/admin/games/viewmodel/games_viewmodel.dart';

class EditGame extends ConsumerStatefulWidget {
  ChangeNotifierProvider<GameViewModel> provider;
  GameModel game;
  EditGame({Key? key, required this.provider, required this.game})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditGameState();
}

class _EditGameState extends ConsumerState<EditGame> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oyunu düzenle')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: _submit,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: widget.game.name,
                decoration: const InputDecoration(labelText: "Oyun Adı"),
                onChanged: (value) => widget.game.name = value,
              ),
              TextFormField(
                initialValue: widget.game.person_fee.toString(),
                decoration: const InputDecoration(labelText: "Kişi Ücreti"),
                keyboardType: TextInputType.number,
                onChanged: (value) => widget.game.person_fee = int.parse(value),
              ),
              TextFormField(
                initialValue: widget.game.person_fee_double.toString(),
                decoration:
                    const InputDecoration(labelText: "Kişi Ücreti (2 kişilik)"),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    widget.game.person_fee_double = int.parse(value),
              ),
              TextFormField(
                initialValue: widget.game.video_fee.toString(),
                decoration: const InputDecoration(labelText: "Video Ücreti"),
                keyboardType: TextInputType.number,
                onChanged: (value) => widget.game.video_fee = int.parse(value),
              ),
              TextFormField(
                initialValue: widget.game.hours.join(","),
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: "Seans Saatleri (11:30,12:30,13:30)"),
                onChanged: (value) => widget.game.hours =
                    value.split(",").map((e) => e.trim()).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _submit() async {
    final _result = await ref.read(widget.provider).editGame(widget.game);
    if (_result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Oyun düzenlendi'),
        duration: Duration(seconds: 1),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hata oluştu: $_result"),
      ));
    }
  }
}
