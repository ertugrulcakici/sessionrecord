import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sessionrecord/product/model/user_model.dart';
import 'package:sessionrecord/views/admin/users/view/add_user.dart';
import 'package:sessionrecord/views/admin/users/viewmodel/users_viewmodel.dart';

class UserView extends ConsumerStatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<UserView> {
  final ChangeNotifierProvider<UserViewModel> _userProvider =
      ChangeNotifierProvider((ref) => UserViewModel());

  @override
  void initState() {
    ref.read(_userProvider).init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addUser(context),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: ref.watch(_userProvider).users.length,
          itemBuilder: (context, index) {
            UserModel _user = ref.watch(_userProvider).users[index];
            return ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(_user.username ?? ""),
              subtitle: Text(_user.password ?? ""),
              trailing: _user.is_admin!
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteUser(_user),
                    ),
            );
          },
          shrinkWrap: true,
        ),
      ),
    );
  }

  Future<void> _addUser(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUser(provider: _userProvider),
      ),
    );
  }

  Future<void> _deleteUser(UserModel _user) async {
    var _result = await ref.read(_userProvider).deleteUser(_user);
    if (_result == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Kullanıcı silindi")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Kullanıcı şu hata yüzüne silinemedi: $_result")));
    }
  }
}
