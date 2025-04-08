import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/goals/application/goal_controller.dart';
import 'package:mobile_app/features/goals/application/fasting_goal.dart';
import 'package:mobile_app/features/goals/presentation/goal_tracker_screen.dart';

class FastingGoalListScreen extends ConsumerWidget {
  const FastingGoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final controller = ref.read(goalsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Fasting Goals")),
      body:
          goals.isEmpty
              ? const Center(child: Text("No goals yet."))
              : ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return ListTile(
                    title: Text(goal.label),
                    subtitle: Text(
                      "${goal.targetCount} days | ${goal.startDate.toLocal().toString().split(' ')[0]} → ${goal.endDate.toLocal().toString().split(' ')[0]}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GoalTrackerScreen(goal: goal),
                          ),
                        ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newGoal = FastingGoal(
            label: 'New Goal',
            targetCount: 5,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 30)),
          );
          await controller.addGoal(newGoal);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Goal"),
      ),
    );
  }
}
