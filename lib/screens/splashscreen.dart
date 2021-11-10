import 'package:blather_app/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetoonboard();
  }

  _navigatetoonboard() async {
    await Future.delayed(const Duration(milliseconds: 8000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Onbording()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.asset('assets/lottie/paperplane.json'),
        ),
      ),
    );
  }
}
