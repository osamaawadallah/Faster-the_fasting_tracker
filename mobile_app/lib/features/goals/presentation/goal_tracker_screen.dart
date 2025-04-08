import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_app/shared/utils/date_utils.dart' as date_utils;
import 'package:mobile_app/features/fasting/application/fasting_controller.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mobile_app/features/goals/application/fasting_goal.dart';

class GoalTrackerScreen extends ConsumerWidget {
  final FastingGoal goal;
  const GoalTrackerScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastingDays = ref.watch(fastingDaysProvider);
    final controller = ref.read(fastingDaysProvider.notifier);

    final goalFastedDays =
        fastingDays
            .where(
              (d) =>
                  d.isAfter(goal.startDate.subtract(const Duration(days: 1))) &&
                  d.isBefore(goal.endDate.add(const Duration(days: 1))),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text(goal.label)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("${goalFastedDays.length} / ${goal.targetCount} days fasted"),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (goalFastedDays.length / goal.targetCount).clamp(0.0, 1.0),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TableCalendar(
                focusedDay: goal.startDate,
                firstDay: goal.startDate,
                lastDay: goal.endDate,
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) {
                    final hijri = HijriCalendar.fromDate(day);
                    final isMarked = fastingDays.contains(
                      date_utils.normalizeDate(day),
                    );

                    return GestureDetector(
                      onTap: () async {
                        if (date_utils
                            .normalizeDate(day)
                            .isAfter(DateTime.now()))
                          return;
                        await controller.toggleFastingDay(
                          date_utils.normalizeDate(day),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                          color: isMarked ? Colors.teal.withOpacity(0.3) : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day.day.toString().padLeft(2, '0'),
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              hijri.hDay.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
