import 'package:flutter/material.dart';
import '../models/gym.dart';
import '../services/jsonStorageService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Gym> gyms = [];
  final TextEditingController _textController = TextEditingController();

  Future<void> loadGyms() async {
    final data = await JsonStorageService.loadFile();

    final loadedGyms = data.map((gymMap) {
      return Gym.fromJson(gymMap);
    }).toList();

    setState(() {
      gyms = loadedGyms;
    });
  }

  Future<void> addGym() async {
    final newGym = Gym(name: _textController.text);

    setState(() {
      gyms.add(newGym);
    });

    final gymMaps = gyms.map((gym) => gym.toJson()).toList();

    await JsonStorageService.saveFile(gymMaps);

    _textController.clear();
  }

  void addLocation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: "Gym Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  addGym();
                },
                child: const Text("Add Gym", style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    loadGyms();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    _textController.dispose();
    super.dispose();
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

              child: Stack(
                children: [
                  Center(
                    child: Text(
                      gym.name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 150, 0, 0),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(20),
                      ),
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) async {
                        if (value == "delete") {
                          setState(() {
                            gyms.removeAt(index);
                          });

                          final gymMaps = gyms
                              .map((gym) => gym.toJson())
                              .toList();

                          await JsonStorageService.saveFile(gymMaps);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          height: 20,

                          value: "delete",
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  ),
                ],
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
