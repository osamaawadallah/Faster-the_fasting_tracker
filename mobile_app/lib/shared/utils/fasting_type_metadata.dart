import 'package:flutter/material.dart';

enum FastingType {
  ramadan,
  sixShawwal,
  ayyamAlBeid,
  dhulHijjah10,
  ashura,
  mondayThursday,
  none,
}

class FastingTypeDetails {
  final String label;
  final IconData icon;
  final Color color;

  const FastingTypeDetails({
    required this.label,
    required this.icon,
    required this.color,
  });
}

const Map<FastingType, FastingTypeDetails> fastingTypeMeta = {
  FastingType.ramadan: FastingTypeDetails(
    label: "Ramadan",
    icon: Icons.nightlight_round,
    color: Color(0xFFFFCC80),
  ),
  FastingType.sixShawwal: FastingTypeDetails(
    label: "6 of Shawwal",
    icon: Icons.wb_sunny,
    color: Color(0xFFFFF176),
  ),
  FastingType.ayyamAlBeid: FastingTypeDetails(
    label: "Ayyam al-Beid",
    icon: Icons.calendar_today,
    color: Color(0xFFBBDEFB),
  ),
  FastingType.dhulHijjah10: FastingTypeDetails(
    label: "10th of Dhul Hijjah",
    icon: Icons.emoji_events,
    color: Color(0xFFE1BEE7),
  ),
  FastingType.ashura: FastingTypeDetails(
    label: "Ashura (±1 day)",
    icon: Icons.local_fire_department,
    color: Color(0xFFEF9A9A),
  ),
  FastingType.mondayThursday: FastingTypeDetails(
    label: "Monday / Thursday",
    icon: Icons.access_time,
    color: Color(0xFFC8E6C9),
  ),
  FastingType.none: FastingTypeDetails(
    label: "None",
    icon: Icons.remove,
    color: Colors.transparent,
  ),
};
