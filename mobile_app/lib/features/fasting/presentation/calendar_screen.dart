import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import '../application/fasting_controller.dart';
import 'package:mobile_app/shared/utils/fasting_logic.dart';
import 'package:mobile_app/shared/utils/fasting_type_metadata.dart';
import 'package:mobile_app/features/goals/presentation/goal_list_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();

  DateTime normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Fasting App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Goals'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FastingGoalListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboards'),
              onTap: () {
                // TODO: Add dashboards screen routing
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Community'),
              onTap: () {
                // TODO: Add community screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Donation'),
              onTap: () {
                // TODO: Add donation screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Add settings screen
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Fasting Calendar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: "Go to Today",
            onPressed: () => setState(() => _focusedDay = DateTime.now()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(3025, 12, 31),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    rowHeight: (constraints.maxHeight / 6).clamp(85.0, 120.0),
                    onPageChanged: (day) => setState(() => _focusedDay = day),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: buildCalendarCell,
                      todayBuilder: buildCalendarCell,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // buildFastingLegend(),
          ],
        ),
      ),
    );
  }

  Widget buildCalendarCell(BuildContext context, DateTime day, DateTime _) {
    final fastingDays = ref.watch(fastingDaysProvider);
    final controller = ref.read(fastingDaysProvider.notifier);

    final hijri = HijriCalendar.fromDate(day);
    final fastingTypes = getFastingTypes(day);
    final isFastingMarked = fastingDays.contains(normalizeDate(day));

    final tooltipMessage = fastingTypes
        .map((type) => fastingTypeMeta[type]?.label ?? '')
        .where((label) => label.isNotEmpty)
        .join('\n');

    return Tooltip(
      message: tooltipMessage,
      child: GestureDetector(
        onTap: () async {
          if (normalizeDate(day).isAfter(DateTime.now())) return;
          await controller.toggleFastingDay(normalizeDate(day));
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.day.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                hijri.hDay.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isFastingMarked)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(
                          Icons.check_circle,
                          size: 12,
                          color: Colors.teal,
                        ),
                      ),
                    ...fastingTypes.map((type) {
                      final meta = fastingTypeMeta[type]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(meta.icon, size: 10, color: meta.color),
                      );
                    }),
                    if (!isFastingMarked && fastingTypes.isEmpty)
                      const SizedBox(width: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Legend UI
//

Widget buildFastingLegend() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
        fastingTypeMeta.entries
            .where((e) => e.key != FastingType.none)
            .map((e) => fastingLegendItem(e.value.color, e.value.label))
            .toList(),
  );
}

Widget fastingLegendItem(Color? color, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(label),
      ],
    ),
  );
}
