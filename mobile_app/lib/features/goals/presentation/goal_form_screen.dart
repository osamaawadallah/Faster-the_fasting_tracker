// File: lib/features/goals/presentation/goal_form_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/features/goals/application/fasting_goal.dart';

class GoalFormScreen extends StatefulWidget {
  const GoalFormScreen({super.key});

  @override
  State<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _targetCountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate({required bool isStart}) async {
    final initial =
        isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (result != null) {
      setState(() {
        if (isStart) {
          _startDate = result;
        } else {
          _endDate = result;
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      final goal = FastingGoal(
        label: _labelController.text,
        targetCount: int.tryParse(_targetCountController.text) ?? 0,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      Navigator.pop(context, goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Fasting Goal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Goal Label'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _targetCountController,
                decoration: const InputDecoration(labelText: 'Target Days'),
                keyboardType: TextInputType.number,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null
                        ? 'Start: ${_startDate!.toLocal().toString().split(' ')[0]}'
                        : 'Select start date',
                  ),
                  ElevatedButton(
                    onPressed: () => _pickDate(isStart: true),
                    child: const Text('Pick Start'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endDate != null
                        ? 'End: ${_endDate!.toLocal().toString().split(' ')[0]}'
                        : 'Select end date',
                  ),
                  ElevatedButton(
                    onPressed: () => _pickDate(isStart: false),
                    child: const Text('Pick End'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text("Save Goal"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
