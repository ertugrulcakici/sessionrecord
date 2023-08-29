import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/core/service/firebase/auth_service.dart';
import 'package:sessionrecord/product/model/game_model.dart';
import 'package:sessionrecord/product/model/session_model.dart';
import 'package:sessionrecord/product/widget/session_widget.dart';
import 'package:sessionrecord/utils/extentions/datetime_extentions.dart';
import 'package:sessionrecord/views/home/viewmodel/home_viewmodel.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  final ChangeNotifierProvider<HomeViewModel> _provider =
      ChangeNotifierProvider((ref) => HomeViewModel());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          drawer: _homeDrawer(context),
          appBar: _appBar(),
          body: Center(
            child: FutureBuilder(
                future: ref.read(_provider).init(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: ref
                                    .watch(_provider)
                                    .games
                                    .map((GameModel game) {
                                  return InkWell(
                                    onTap: () {
                                      ref.watch(_provider).selectedGame = game;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Center(
                                        child: Text(
                                          game.name,
                                          style: TextStyle(
                                              color: ref
                                                          .watch(_provider)
                                                          .selectedGame ==
                                                      game
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList())),
                        Expanded(
                            flex: 18,
                            child: ListView.builder(
                              itemCount: ref
                                  .watch(_provider)
                                  .selectedGame
                                  .hours
                                  .length,
                              itemBuilder: (context, index) {
                                final _game = ref.watch(_provider).selectedGame;
                                final _sessions = ref.watch(_provider).sessions;
                                String _hour = _game.hours[index];
                                SessionModel? _session;
                                for (var item in _sessions) {
                                  if (item.hour == _hour) {
                                    _session = item;
                                    break;
                                  }
                                }
                                return SessionWidget(
                                    sessionModel: _session,
                                    hour: _hour,
                                    game: _game,
                                    provider: _provider);
                              },
                            ))
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ),
      ),
    );
  }

  Drawer _homeDrawer(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(AuthService.currentUser.username!),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Gider ekle"),
              onTap: () {
                Navigator.pushNamed(context, "/add_expanse");
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Çıkış yap"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Visibility(
              visible: AuthService.currentUser.is_admin!,
              child: ListTile(
                leading: const Icon(Icons.money_off),
                title: const Text("Giderleri gör"),
                onTap: () => Navigator.pushNamed(context, "/expanses"),
              ),
            ),
            Visibility(
              visible: AuthService.currentUser.is_admin!,
              child: ListTile(
                leading: const Icon(Icons.insert_chart),
                title: const Text("İstatistikler"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Visibility(
              visible: AuthService.currentUser.is_admin!,
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Kullanıcıları gör"),
                onTap: () {
                  Navigator.pushNamed(context, "/users");
                },
              ),
            ),
            Visibility(
              visible: AuthService.currentUser.is_admin!,
              child: ListTile(
                leading: const Icon(Icons.games),
                title: const Text("Oyunları gör"),
                onTap: () {
                  Navigator.pushNamed(context, "/games");
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _dateTimePicker() async {
    final _result = await showDatePicker(
        locale: const Locale("tr", "TR"),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        context: context,
        initialDate: DateTime.now());
    if (_result != null) {
      ref.watch(_provider).date = _result;
    }
  }

  AppBar _appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text(ref.watch(_provider).date.toDayMonthYearString())),
          IconButton(
              onPressed: _dateTimePicker, icon: const Icon(Icons.date_range)),
          IconButton(
              onPressed: ref.read(_provider).refresh,
              icon: const Icon(Icons.refresh))
        ],
      ),
    );
  }
}
