// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/views/authenticate/login/login_viewmodel.dart';

class LoginView extends ConsumerWidget {
  String _username = "";
  String _password = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  final ChangeNotifierProvider<LoginViewModel> _provider =
      ChangeNotifierProvider(
    (ref) => LoginViewModel(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (value) {
                      _username = value ?? "";
                    },
                    decoration: InputDecoration(
                      labelText: "Kullanıcı adı",
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    onSaved: (value) {
                      _password = value ?? "";
                    },
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _login(context, ref),
                    child: const Text("Giriş yap"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _login(BuildContext context, WidgetRef ref) async {
    _formKey.currentState!.save();
    bool _success = await ref.read(_provider).login(_username, _password);
    if (_success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Giriş başarılı"),
        duration: Duration(seconds: 1),
      ));
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Giriş başarısız"),
        duration: Duration(seconds: 1),
      ));
      _formKey.currentState!.reset();
    }
  }
}
