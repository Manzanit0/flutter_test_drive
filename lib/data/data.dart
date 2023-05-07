import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getLoggedUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("logged_user");
}

Future<bool> setLoggedUser(String user) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString("logged_user", user);
}

Future<String?> getCookbookToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("cookbook_token");
}

Future<bool> setCookbookToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString("cookbook_token", token);
}

Future<bool> logout() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove("logged_user");
}
