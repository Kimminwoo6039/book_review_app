import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // 전체영역
        children: [
          Image.asset(
            'assets/images/splash_bg.png',
          ),
        ],
      ),
    );
  }
}
