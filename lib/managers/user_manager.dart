import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static final UserManager _INSTANCE = UserManager._internal();
  static final KEY_USER = "user";
  static final KEY_LOGIN_DATE = "login_date";

  UserManager._internal();

  factory UserManager() => _INSTANCE;

  Future<bool> saveUser(String? user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (user != null) {
        prefs.setString(KEY_USER, user);
        String date = DateFormat('yMd').format(DateTime.now());
        prefs.setString(KEY_LOGIN_DATE, date);
      } else {
        await prefs.clear();
      }
      return true;
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  Future<String?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(KEY_USER)) {
        return prefs.getString(KEY_USER);
      }
      return null;
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(KEY_USER) && prefs.containsKey(KEY_LOGIN_DATE)) {
        final user = prefs.getString(KEY_USER);
        String loggedInDate = prefs.getString(KEY_LOGIN_DATE).toString();
        String currentDate = DateFormat('yMd').format(DateTime.now());
        return user != null && loggedInDate == currentDate;
      }
      return false;
    } catch (exception) {
      print(exception);
      return false;
    }
  }
}
