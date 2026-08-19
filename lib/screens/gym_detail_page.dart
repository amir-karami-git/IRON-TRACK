import 'package:flutter/material.dart';
import '../models/gym.dart';
import '../models/workout.dart';
import '../services/auth_service.dart';
import '../services/json_storage_service.dart';
import 'signin_page.dart'; // for kAccent / kBackground constants
import 'workout_detail_page.dart';

class GymDetailPage extends StatefulWidget {
  final String username;
  final Gym gym;

  const GymDetailPage({super.key, required this.username, required this.gym});

  @override
  State<GymDetailPage> createState() => _GymDetailPageState();
}

class _GymDetailPageState extends State<GymDetailPage> {
  late final String _workoutsFile = AuthService.workoutsFileNameFor(
    widget.username,
    widget.gym.id,
  );

  List<Workout> workouts = [];
  bool _isLoading = true;

  Future<void> _loadWorkouts() async {
    final data = await JsonStorageService.loadFile(_workoutsFile);
    final loaded = data.map((w) => Workout.fromJson(w)).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first

    setState(() {
      workouts = loaded;
      _isLoading = false;
    });
  }

  Future<void> _persistWorkouts() async {
    final data = workouts.map((w) => w.toJson()).toList();
    await JsonStorageService.saveFile(_workoutsFile, data);
  }

  Future<void> _addWorkout() async {
    final newWorkout = Workout(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _formatDate(DateTime.now()),
      date: DateTime.now(),
      sets: [],
    );

    setState(() {
      workouts.insert(0, newWorkout);
    });
    await _persistWorkouts();

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailPage(
          username: widget.username,
          gym: widget.gym,
          workout: newWorkout,
        ),
      ),
    );

    // The workout page may have added sets while we were away — reload so
    // the list here reflects the latest set count.
    _loadWorkouts();
  }

  Future<void> _deleteWorkout(int index) async {
    final removed = workouts[index];

    setState(() {
      workouts.removeAt(index);
    });
    await _persistWorkouts();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.name} removed'),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: Text(
          widget.gym.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : workouts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 90),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return _buildWorkoutCard(workouts[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccent,
        onPressed: _addWorkout,
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
            const Icon(Icons.history, color: Colors.white24, size: 64),
            const SizedBox(height: 16),
            const Text(
              "No workouts yet",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap + to log your first workout at ${widget.gym.name}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout, int index) {
    final setCount = workout.sets.length;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(
              username: widget.username,
              gym: widget.gym,
              workout: workout,
            ),
          ),
        );
        _loadWorkouts();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 24, 24),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: kAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fitness_center, color: kAccent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    setCount == 1 ? '1 set logged' : '$setCount sets logged',
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) {
                if (value == "delete") {
                  _deleteWorkout(index);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: "delete",
                  child: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
