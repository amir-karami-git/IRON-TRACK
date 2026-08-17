import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

const kAccent = Color.fromARGB(255, 150, 0, 0);
const kBackground = Colors.black;
const kFieldFill = Color.fromARGB(255, 28, 28, 28);

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo mark
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: kAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: kAccent, width: 2),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: kAccent,
                  size: 40,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "WELCOME TO",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                  letterSpacing: 8,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "IRON TRACK",
                style: TextStyle(
                  fontSize: 44,
                  color: kAccent,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Track your gyms. Track your gains.",
                style: TextStyle(fontSize: 14, color: Colors.white38),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
