import 'package:flutter/material.dart';
import 'screens/signin_page.dart';

class IronTrack extends StatelessWidget {
  const IronTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iron Track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 150, 0, 0),
        ),
      ),
      home: const SigninPage(),
    );
  }
}
