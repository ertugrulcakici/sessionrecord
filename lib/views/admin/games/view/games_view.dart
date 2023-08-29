import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/product/model/game_model.dart';
import 'package:sessionrecord/views/admin/games/view/add_game.dart';
import 'package:sessionrecord/views/admin/games/view/edit_game.dart';
import 'package:sessionrecord/views/admin/games/viewmodel/games_viewmodel.dart';

class GameView extends ConsumerStatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<GameView> {
  final ChangeNotifierProvider<GameViewModel> _gameProvider =
      ChangeNotifierProvider((ref) => GameViewModel());

  @override
  void initState() {
    ref.read(_gameProvider).init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addGame,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Oyunlar"),
      ),
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: ref.watch(_gameProvider).games.length,
          itemBuilder: (context, index) {
            GameModel _game = ref.watch(_gameProvider).games[index];
            return Card(
              child: ListTile(
                title: Center(child: Text(_game.name)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text("Seans saatleri: ${_game.hours.join(", ")}",
                        overflow: TextOverflow.clip, softWrap: true),
                    Text("Kişi Ücreti: ${_game.person_fee} TL"),
                    Text(
                        "Kişi Ücreti (2 kişilik): ${_game.person_fee_double} TL"),
                    Text("Video Ücreti: ${_game.video_fee} TL"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () => _editGame(_game),
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => _deleteGame(_game),
                            icon: const Icon(Icons.delete)),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future _deleteGame(GameModel game) async {
    final _result = await ref.read(_gameProvider).deleteGame(game.id);
    if (_result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oyun başarıyla silindi."),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Oyun silinirken bir hata oluştu: $_result"),
      ));
    }
  }

  Future _editGame(GameModel game) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditGame(provider: _gameProvider, game: game);
    }));
  }

  void _addGame() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddGame(provider: _gameProvider);
    }));
  }
}
