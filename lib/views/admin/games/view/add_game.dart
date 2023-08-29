// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/views/admin/games/viewmodel/games_viewmodel.dart';

class AddGame extends ConsumerStatefulWidget {
  final ChangeNotifierProvider<GameViewModel> provider;
  AddGame({Key? key, required this.provider}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddGameState();
}

class _AddGameState extends ConsumerState<AddGame> {
  final Map<String, dynamic> _game = {
    "name": "",
    "hours": [],
    "person_fee": 0,
    "person_fee_double": 0,
    "video_fee": 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oyun ekle')),
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
              TextField(
                decoration: const InputDecoration(labelText: "Oyun Adı"),
                onChanged: (value) => _game["name"] = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Kişi Ücreti"),
                keyboardType: TextInputType.number,
                onChanged: (value) => _game["person_fee"] = int.parse(value),
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: "Kişi Ücreti (2 kişilik)"),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    _game["person_fee_double"] = int.parse(value),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Video Ücreti"),
                keyboardType: TextInputType.number,
                onChanged: (value) => _game["video_fee"] = int.parse(value),
              ),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: "Seans Saatleri (11:30,12:30,13:30)"),
                onChanged: (value) => _game["hours"] =
                    value.split(",").map((e) => e.trim()).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _submit() async {
    final _result = await ref.read(widget.provider).addGame(_game);
    if (_result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oyun başarıyla eklendi!"),
        duration: Duration(seconds: 1),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Oyun eklenirken hata oluştu: $_result!"),
        duration: const Duration(seconds: 1),
      ));
    }
  }
}
