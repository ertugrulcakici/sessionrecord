import "package:flutter/material.dart";
import 'package:sessionrecord/core/service/firebase/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 0);
    _controller.addListener(() {
      setState(() {});
    });
    _controller
        .animateTo(1,
            duration: const Duration(milliseconds: 500), curve: Curves.linear)
        .then((value) {
      AuthService.instance.isLoggedIn().then((value) {
        if (value) {
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Opacity(
            child: Center(child: Image.asset("assets/images/png/logo.png")),
            opacity: _controller.value));
  }
}
