import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/goals/application/fasting_goal.dart';
import 'package:mobile_app/features/goals/application/goal_controller.dart';

class EditGoalScreen extends ConsumerStatefulWidget {
  final FastingGoal? goal;

  const EditGoalScreen({super.key, this.goal});

  @override
  ConsumerState<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends ConsumerState<EditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _countController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.goal?.label ?? '');
    _countController = TextEditingController(
      text: widget.goal?.targetCount.toString() ?? '',
    );
    _startDate = widget.goal?.startDate ?? DateTime.now();
    _endDate =
        widget.goal?.endDate ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _labelController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart ? _startDate! : _endDate!;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(goalsProvider.notifier);
      final goal = FastingGoal(
        id: widget.goal?.id,
        label: _labelController.text.trim(),
        targetCount: int.parse(_countController.text),
        startDate: _startDate!,
        endDate: _endDate!,
      );
      if (goal.id == null) {
        await controller.addGoal(goal);
      } else {
        await controller.updateGoal(goal);
      }
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'New Goal' : 'Edit Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label'),
                validator: (value) => value!.isEmpty ? 'Enter label' : null,
              ),
              TextFormField(
                controller: _countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Target Count'),
                validator: (value) => value!.isEmpty ? 'Enter count' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Start: ${_startDate!.toLocal().toString().split(" ")[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(isStart: true),
                    child: const Text('Change'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'End: ${_endDate!.toLocal().toString().split(" ")[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(isStart: false),
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Save Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
