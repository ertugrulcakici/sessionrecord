// ignore_for_file: non_constant_identifier_names, must_be_immutable

import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/product/model/user_model.dart';
import 'package:sessionrecord/views/admin/users/viewmodel/users_viewmodel.dart';

class AddUser extends ConsumerStatefulWidget {
  ChangeNotifierProvider<UserViewModel> provider;
  AddUser({Key? key, required this.provider}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddUserState();
}

class _AddUserState extends ConsumerState<AddUser> {
  bool is_admin = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (_usernameController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Kullanıcı adı ve şifre boş bırakılamaz."),
              backgroundColor: Colors.red,
            ));
          } else {
            final _result = await ref.read(widget.provider).addUser(
                  UserModel(
                    is_admin: is_admin,
                    username: _usernameController.text,
                    password: _passwordController.text,
                  ),
                );
            if (_result) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kullanıcı eklendi")));
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Kullanıcı eklenirken bir hata oluştu: $_result"),
                backgroundColor: Colors.red,
              ));
            }
          }
        },
      ),
      appBar: AppBar(
        title: const Text("Kullanıcı Ekle"),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı",
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Şifre",
                ),
              ),
              SwitchListTile(
                title: const Text("Admin"),
                value: is_admin,
                onChanged: (value) {
                  setState(() {
                    is_admin = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
