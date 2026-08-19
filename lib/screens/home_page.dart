import 'package:flutter/material.dart';
import '../models/gym.dart';
import '../services/auth_service.dart';
import '../services/json_storage_service.dart';
import 'signin_page.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Each account's gyms live in their own file, e.g. "gyms_alice.json",
  // so two users never read or overwrite each other's data.
  late final String _gymsFile = AuthService.gymsFileNameFor(widget.username);

  List<Gym> gyms = [];
  bool _isLoading = true;
  final TextEditingController _textController = TextEditingController();

  Future<void> loadGyms() async {
    final data = await JsonStorageService.loadFile(_gymsFile);
    final loadedGyms = data.map((gymMap) => Gym.fromJson(gymMap)).toList();

    setState(() {
      gyms = loadedGyms;
      _isLoading = false;
    });
  }

  Future<void> _persistGyms() async {
    final gymMaps = gyms.map((gym) => gym.toJson()).toList();
    await JsonStorageService.saveFile(_gymsFile, gymMaps);
  }

  Future<void> addGym() async {
    final name = _textController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      gyms.add(Gym(name: name));
    });

    await _persistGyms();
    _textController.clear();
  }

  Future<void> deleteGym(int index) async {
    final removed = gyms[index];

    setState(() {
      gyms.removeAt(index);
    });

    await _persistGyms();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.name} removed'),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _logOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SigninPage()),
      (route) => false,
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final passwordController = TextEditingController();
    String? errorMessage;
    bool isDeleting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: !isDeleting,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> handleConfirm() async {
              if (passwordController.text.isEmpty) {
                setDialogState(() {
                  errorMessage = "Enter your password to confirm";
                });
                return;
              }

              setDialogState(() {
                isDeleting = true;
                errorMessage = null;
              });

              final error = await AuthService.deleteAccount(
                widget.username,
                passwordController.text,
              );

              if (error != null) {
                setDialogState(() {
                  isDeleting = false;
                  errorMessage = error;
                });
                return;
              }

              if (!mounted) return;
              Navigator.pop(dialogContext); // close the dialog

              // Account and all their data are gone — send them back to
              // the very start, clearing the whole navigation stack.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SigninPage()),
                (route) => false,
              );
            }

            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 22, 22, 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Delete your account?",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This permanently deletes your account and every gym "
                    "you've saved. This can't be undone.",
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    autofocus: true,
                    enabled: !isDeleting,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Confirm your password",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 34, 34, 34),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: isDeleting ? null : handleConfirm,
                  child: isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addLocation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 260,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Add a Gym",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _textController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Gym Name",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 34, 34, 34),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 150, 0, 0),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 150, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        addGym();
                      },
                      child: const Text(
                        "Add Gym",
                        style: TextStyle(
                          fontSize: 18,
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "My Gyms",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              widget.username,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: (value) {
              if (value == "logout") {
                _logOut();
              } else if (value == "delete_account") {
                _confirmDeleteAccount();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 10),
                    Text("Log Out"),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: "delete_account",
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_forever,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 150, 0, 0),
              ),
            )
          : gyms.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 90),
              itemCount: gyms.length,
              itemBuilder: (context, index) {
                final gym = gyms[index];
                return _buildGymCard(gym, index);
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 150, 0, 0),
        onPressed: addLocation,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, color: Colors.white24, size: 64),
            const SizedBox(height: 16),
            const Text(
              "No gyms yet",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap the + button to add your first gym",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGymCard(Gym gym, int index) {
    return GestureDetector(
      onTap: () {
        // Open this gym later
      },
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/Gym_cover.jpeg", fit: BoxFit.cover),

            // Gradient so text stays readable over any image
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Text(
                gym.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                ),
              ),
            ),

            Positioned(
              top: 8,
              right: 8,
              child: PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == "delete") {
                    deleteGym(index);
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
  }
}
