import 'package:flutter/material.dart';
import '../models/gym.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../services/auth_service.dart';
import '../services/json_storage_service.dart';
import 'add_set_page.dart';
import 'signin_page.dart'; // for kAccent / kBackground constants

class WorkoutDetailPage extends StatefulWidget {
  final String username;
  final Gym gym;
  final Workout workout;

  const WorkoutDetailPage({
    super.key,
    required this.username,
    required this.gym,
    required this.workout,
  });

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late final String _workoutsFile = AuthService.workoutsFileNameFor(
    widget.username,
    widget.gym.id,
  );

  late List<WorkoutSet> sets;

  @override
  void initState() {
    super.initState();
    sets = List.of(widget.workout.sets);
  }

  /// The workouts file holds the FULL list of workouts for this gym, so to
  /// persist a change to just this workout's sets we load everything,
  /// swap this workout's set list, and save everything back.
  Future<void> _persist() async {
    final data = await JsonStorageService.loadFile(_workoutsFile);
    final allWorkouts = data.map((w) => Workout.fromJson(w)).toList();
    final index = allWorkouts.indexWhere((w) => w.id == widget.workout.id);

    if (index != -1) {
      allWorkouts[index] = allWorkouts[index].copyWithSets(sets);
    }

    await JsonStorageService.saveFile(
      _workoutsFile,
      allWorkouts.map((w) => w.toJson()).toList(),
    );
  }

  Future<void> _addSet() async {
    final newSet = await Navigator.push<WorkoutSet>(
      context,
      MaterialPageRoute(builder: (context) => const AddSetPage()),
    );

    if (newSet == null) return;

    setState(() {
      sets.add(newSet);
    });
    await _persist();
  }

  Future<void> _deleteSet(int index) async {
    setState(() {
      sets.removeAt(index);
    });
    await _persist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: Text(
          widget.workout.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: sets.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: sets.length,
              itemBuilder: (context, index) {
                return _buildSetCard(sets[index], index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccent,
        onPressed: _addSet,
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
            const Icon(Icons.list_alt, color: Colors.white24, size: 64),
            const SizedBox(height: 16),
            const Text(
              "No sets logged yet",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap + to add your first set",
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetCard(WorkoutSet set, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 24, 24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  set.moveName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: kAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  set.equipmentType,
                  style: const TextStyle(
                    color: kAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white38,
                  size: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (value) {
                  if (value == "delete") {
                    _deleteSet(index);
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
          const SizedBox(height: 10),
          Wrap(spacing: 16, runSpacing: 6, children: _buildDetailChips(set)),
          if (set.notes != null && set.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              set.notes!,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildDetailChips(WorkoutSet set) {
    final details = <Widget>[];

    Widget stat(IconData icon, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white38),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      );
    }

    if (set.equipmentType == EquipmentType.machine &&
        set.machineName != null &&
        set.machineName!.trim().isNotEmpty) {
      details.add(stat(Icons.precision_manufacturing, set.machineName!));
    }

    if (set.equipmentType == EquipmentType.other &&
        set.otherDescription != null &&
        set.otherDescription!.trim().isNotEmpty) {
      details.add(stat(Icons.info_outline, set.otherDescription!));
    }

    if (set.weight != null && set.weightUnit != null) {
      final weightText = set.weight! % 1 == 0
          ? set.weight!.toStringAsFixed(0)
          : set.weight!.toString();
      details.add(stat(Icons.fitness_center, '$weightText ${set.weightUnit}'));
    }

    if (set.reps != null) {
      details.add(stat(Icons.repeat, '${set.reps} reps'));
    }

    if (set.seconds != null) {
      details.add(stat(Icons.timer_outlined, '${set.seconds} sec'));
    }

    return details;
  }
}
