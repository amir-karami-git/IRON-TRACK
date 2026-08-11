import 'package:flutter/material.dart';
import '../models/gym.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Gym> gyms = [];

  void addLocation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Gym Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FilledButton(
                onPressed: () {},
                child: const Text("Add Gym", style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 124, 123, 121),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 150, 0, 0),
        title: const Text("Gyms", style: TextStyle(color: Colors.black)),
      ),

      body: ListView.builder(
        itemCount: gyms.length,
        itemBuilder: (context, index) {
          final gym = gyms[index];

          return GestureDetector(
            onTap: () {
              // Open this gym later
            },
            child: Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage("assets/Gym_cover.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  gym.name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 150, 0, 0),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addLocation,
        child: const Icon(Icons.add),
      ),
    );
  }
}
