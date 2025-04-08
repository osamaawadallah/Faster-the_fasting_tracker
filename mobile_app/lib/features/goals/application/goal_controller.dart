import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/goals/data/goal_api.dart';
import 'package:mobile_app/features/goals/application/fasting_goal.dart';

final goalsProvider = StateNotifierProvider<GoalController, List<FastingGoal>>((
  ref,
) {
  return GoalController(GoalApi())..loadGoals();
});

class GoalController extends StateNotifier<List<FastingGoal>> {
  final GoalApi api;

  GoalController(this.api) : super([]);

  Future<void> loadGoals() async {
    state = await api.getGoals();
  }

  Future<void> addGoal(FastingGoal goal) async {
    final created = await api.createGoal(goal);
    state = [...state, created];
  }

  Future<void> updateGoal(FastingGoal goal) async {
    final updated = await api.updateGoal(goal);
    state = [
      for (final g in state)
        if (g.id == updated.id) updated else g,
    ];
  }
}
