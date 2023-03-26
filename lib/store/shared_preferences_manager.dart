import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getModel() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('open_ai_model') ?? '';
  }

  Future<void> setModel(String newValue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('open_ai_model', newValue);
  }

  Future<String> getApiKey() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('open_ai_api_key') ?? '';
  }

  Future<void> setApiKey(String newValue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('open_ai_api_key', newValue);
  }

  Future<String> getApiOrg() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('open_ai_org') ?? '';
  }

  Future<void> setApiOrg(String newValue) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('open_ai_org', newValue);
  }
}
