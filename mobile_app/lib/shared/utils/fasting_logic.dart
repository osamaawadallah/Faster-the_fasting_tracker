import 'package:hijri/hijri_calendar.dart';
import 'package:mobile_app/shared/utils/fasting_type_metadata.dart';

List<FastingType> getFastingTypes(DateTime date) {
  final List<FastingType> types = [];
  final hijri = HijriCalendar.fromDate(date);
  final weekday = date.weekday;

  if (hijri.hMonth == 9) types.add(FastingType.ramadan);
  if (hijri.hMonth == 12 && hijri.hDay == 10) {
    types.add(FastingType.dhulHijjah10);
  }
  if (hijri.hMonth == 1 && [9, 10, 11].contains(hijri.hDay)) {
    types.add(FastingType.ashura);
  }
  if ([13, 14, 15].contains(hijri.hDay)) {
    types.add(FastingType.ayyamAlBeid);
  }
  if (weekday == DateTime.monday || weekday == DateTime.thursday) {
    types.add(FastingType.mondayThursday);
  }

  return types;
}
