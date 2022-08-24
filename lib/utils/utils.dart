import 'package:pakan_ikan_iot/pages/settings_page.dart';
import 'package:pakan_ikan_iot/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void printout() {
  print('OUTOUTOUT');
}

// Future<void> setSchedulePref(bool isSchedule) async {
//   final pref = await SharedPreferences.getInstance();
//   pref.setBool('isSchedule', isSchedule);
// }

// Future<void> setNotifPref(bool isNotif) async {
//   final pref = await SharedPreferences.getInstance();
//   pref.setBool('isNotif', isNotif);
//   print('is SET $isNotif');
// }

void getPref() async {
  final pref = await SharedPreferences.getInstance();
}

Future<bool> getNotifPref2() async {
  final pref = await SharedPreferences.getInstance();
  bool isit = await pref.getBool('isNotif') ?? true;
  // return pref.getBool('isNotif') ?? true;
  return isit;
}
