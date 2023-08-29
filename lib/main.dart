import "package:flutter/material.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/core/initialization.dart';
import 'package:sessionrecord/views/admin/games/view/games_view.dart';
import 'package:sessionrecord/views/admin/users/view/users_view.dart';
import 'package:sessionrecord/views/authenticate/login/login_view.dart';
import 'package:sessionrecord/views/authenticate/splash/splash_view.dart';
import 'package:sessionrecord/views/expanses/view/add_expanse.dart';
import 'package:sessionrecord/views/expanses/view/expanses_view.dart';
import 'package:sessionrecord/views/home/view/edit_session_view.dart';
import 'package:sessionrecord/views/home/view/home_view.dart';

void main() async {
  await initApp();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
        supportedLocales: const [
          Locale('tr'),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          "/splash": (context) => const SplashScreen(),
          "/home": (context) => const HomeView(),
          "/login": (context) => LoginView(),
          "/users": (context) => const UserView(),
          "/games": (context) => const GameView(),
          "/expanses": (context) => const ExpansesView(),
          "/add_expanse": (context) => const AddExpanseView(),
          "/edit_session": (context) => const EditSessionView(),
        },
      ),
    );
  }
}
