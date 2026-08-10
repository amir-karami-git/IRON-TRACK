import 'package:flutter/material.dart';

void main() {
  runApp(const IronTrack());
}

class IronTrack extends StatelessWidget {
  const IronTrack({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 150, 0, 0)),
      ),
      home: const SigninPage(),
    );
  }
}

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            SizedBox(
              child: Text(
                "WELCOME TO",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  letterSpacing: 7,
                ),
              ),
            ),

            SizedBox(
              child: Text(
                "IRON TRACK",
                style: TextStyle(
                  fontSize: 55,
                  color: const Color.fromARGB(255, 150, 0, 0),
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color.fromARGB(255, 150, 0, 0);
                      }

                      return Colors.white;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }

                      return Color.fromARGB(255, 150, 0, 0);
                    }),
                  ),
                  onPressed: () {},
                  child: const Text("Log In", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),

            const SizedBox(height: 12.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color.fromARGB(255, 150, 0, 0);
                      }

                      return Colors.white;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }

                      return Color.fromARGB(255, 150, 0, 0);
                    }),
                  ),
                  onPressed: () {},
                  child: const Text("Sign Up", style: TextStyle(fontSize: 25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
