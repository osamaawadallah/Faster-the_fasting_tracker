import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fasting_api.dart';
import '../../../shared/utils/date_utils.dart';

final fastingDaysProvider =
    StateNotifierProvider<FastingController, Set<DateTime>>((ref) {
      return FastingController(FastingAPI());
    });

class FastingController extends StateNotifier<Set<DateTime>> {
  final FastingAPI api;

  FastingController(this.api) : super({}) {
    loadFastingDays();
  }

  Future<void> loadFastingDays() async {
    final days = await api.getFastingDays();
    state = days.map(normalizeDate).toSet();
  }

  Future<void> toggleFastingDay(DateTime date) async {
    final today = normalizeDate(DateTime.now());
    final targetDate = normalizeDate(date);

    if (targetDate.isAfter(today)) {
      throw Exception("You can only toggle past or current dates.");
    }

    final copy = {...state};
    if (copy.contains(targetDate)) {
      copy.remove(targetDate);
      await api.removeFastingDay(targetDate);
    } else {
      copy.add(targetDate);
      await api.addFastingDay(targetDate, "voluntary", "manual");
    }

    state = copy;
  }

  bool isFastingDay(DateTime date) => state.contains(date);
}
