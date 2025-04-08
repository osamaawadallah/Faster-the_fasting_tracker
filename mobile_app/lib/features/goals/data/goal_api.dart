import 'dart:convert';
import 'package:mobile_app/features/goals/application/fasting_goal.dart';
import 'package:mobile_app/shared/utils/api_client.dart';

class GoalApi {
  final client = ApiClient();

  Future<List<FastingGoal>> getGoals() async {
    final res = await client.get('/api/goals');
    final data = jsonDecode(res.body)['goals'] as List<dynamic>;
    return data.map((e) => FastingGoal.fromJson(e)).toList();
  }

  Future<FastingGoal> createGoal(FastingGoal goal) async {
    final res = await client.post('/api/goals', body: goal.toJson());
    return FastingGoal.fromJson(jsonDecode(res.body));
  }

  Future<FastingGoal> updateGoal(FastingGoal goal) async {
    final res = await client.put('/api/goals/${goal.id}', body: goal.toJson());
    return FastingGoal.fromJson(jsonDecode(res.body));
  }
}
