import 'package:flutter/material.dart';
import '../models/workout_set.dart';
import 'login_page.dart'; // for buildInputDecoration
import 'signin_page.dart'; // for kAccent / kBackground / kFieldFill constants

class AddSetPage extends StatefulWidget {
  const AddSetPage({super.key});

  @override
  State<AddSetPage> createState() => _AddSetPageState();
}

class _AddSetPageState extends State<AddSetPage> {
  final _formKey = GlobalKey<FormState>();

  final _moveNameController = TextEditingController();
  final _machineNameController = TextEditingController();
  final _otherDescriptionController = TextEditingController();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _secondsController = TextEditingController();
  final _notesController = TextEditingController();

  String _equipmentType = EquipmentType.dumbbell;
  String _weightUnit = 'lb';

  bool get _needsWeightAndReps =>
      _equipmentType == EquipmentType.dumbbell ||
      _equipmentType == EquipmentType.bar ||
      _equipmentType == EquipmentType.machine;

  bool get _needsMachineName => _equipmentType == EquipmentType.machine;

  bool get _needsOtherDescription => _equipmentType == EquipmentType.other;

  bool get _needsSeconds => _equipmentType == EquipmentType.isometric;

  void _saveSet() {
    if (!_formKey.currentState!.validate()) return;

    final newSet = WorkoutSet(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      moveName: _moveNameController.text.trim(),
      equipmentType: _equipmentType,
      machineName: _needsMachineName
          ? _machineNameController.text.trim()
          : null,
      otherDescription: _needsOtherDescription
          ? _otherDescriptionController.text.trim()
          : null,
      weight: _needsWeightAndReps && _weightController.text.trim().isNotEmpty
          ? double.tryParse(_weightController.text.trim())
          : null,
      weightUnit: _needsWeightAndReps ? _weightUnit : null,
      reps: _needsWeightAndReps && _repsController.text.trim().isNotEmpty
          ? int.tryParse(_repsController.text.trim())
          : null,
      seconds: _needsSeconds && _secondsController.text.trim().isNotEmpty
          ? int.tryParse(_secondsController.text.trim())
          : null,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    Navigator.pop(context, newSet);
  }

  @override
  void dispose() {
    _moveNameController.dispose();
    _machineNameController.dispose();
    _otherDescriptionController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _secondsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        title: const Text(
          "Add Set",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label("Move name"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _moveNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: buildInputDecoration("e.g. Bench Press"),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? "Enter the move name"
                      : null,
                ),

                const SizedBox(height: 20),

                _label("Equipment"),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _equipmentType,
                  dropdownColor: const Color.fromARGB(255, 34, 34, 34),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: buildInputDecoration("Choose equipment"),
                  items: EquipmentType.all
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _equipmentType = value);
                  },
                ),

                if (_needsMachineName) ...[
                  const SizedBox(height: 20),
                  _label("Machine name"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _machineNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: buildInputDecoration("e.g. Leg Press Machine"),
                    validator: (value) {
                      if (!_needsMachineName) return null;
                      return (value == null || value.trim().isEmpty)
                          ? "Enter the machine name"
                          : null;
                    },
                  ),
                ],

                if (_needsOtherDescription) ...[
                  const SizedBox(height: 20),
                  _label("Description"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _otherDescriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    decoration: buildInputDecoration("Describe what you did"),
                    validator: (value) {
                      if (!_needsOtherDescription) return null;
                      return (value == null || value.trim().isEmpty)
                          ? "Enter a description"
                          : null;
                    },
                  ),
                ],

                if (_needsWeightAndReps) ...[
                  const SizedBox(height: 20),
                  _label("Weight"),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(color: Colors.white),
                          decoration: buildInputDecoration("e.g. 45"),
                          validator: (value) {
                            if (!_needsWeightAndReps) return null;
                            if (value == null || value.trim().isEmpty) {
                              return null; // weight is optional
                            }
                            return double.tryParse(value.trim()) == null
                                ? "Enter a valid number"
                                : null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _weightUnit,
                          dropdownColor: const Color.fromARGB(255, 34, 34, 34),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          decoration: buildInputDecoration("Unit"),
                          items: const [
                            DropdownMenuItem(value: 'lb', child: Text('lb')),
                            DropdownMenuItem(value: 'kg', child: Text('kg')),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _weightUnit = value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _label("Reps"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: buildInputDecoration("e.g. 10"),
                    validator: (value) {
                      if (!_needsWeightAndReps) return null;
                      if (value == null || value.trim().isEmpty) return null;
                      return int.tryParse(value.trim()) == null
                          ? "Enter a whole number"
                          : null;
                    },
                  ),
                ],

                if (_needsSeconds) ...[
                  const SizedBox(height: 20),
                  _label("Seconds held"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _secondsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: buildInputDecoration("e.g. 30"),
                    validator: (value) {
                      if (!_needsSeconds) return null;
                      if (value == null || value.trim().isEmpty) {
                        return "Enter how many seconds";
                      }
                      return int.tryParse(value.trim()) == null
                          ? "Enter a whole number"
                          : null;
                    },
                  ),
                ],

                const SizedBox(height: 20),

                _label("Additional description (optional)"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: buildInputDecoration(
                    "Notes about form, how it felt, etc.",
                  ),
                ),

                const SizedBox(height: 32),

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
                    onPressed: _saveSet,
                    child: const Text(
                      "Save Set",
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
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
