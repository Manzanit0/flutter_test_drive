import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getLoggedUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("logged_user");
}

Future<bool> setLoggedUser(String user) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString("logged_user", user);
}
