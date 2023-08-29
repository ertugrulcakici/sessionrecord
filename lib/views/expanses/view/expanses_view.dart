import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpansesView extends ConsumerStatefulWidget {
  const ExpansesView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpansesViewState();
}

class _ExpansesViewState extends ConsumerState<ExpansesView> {
  // late ChangeNotifierProvider<ExpanseViewModel> _expanseProvider;
  // create form key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _expanseProvider = ChangeNotifierProvider((ref) => ExpanseViewModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giderleri gör'),
      ),
      body: const Center(
        child: Text("Giderleri gör"),
      ),
    );
  }
}
