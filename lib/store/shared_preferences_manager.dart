import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  static SharedPreferences? _prefs;

  SharedPreferencesManager._();

  static Future<SharedPreferencesManager> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesManager._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String> getModel() async {
    return _prefs?.getString('open_ai_model') ?? '';
  }

  Future<void> setModel(String newValue) async {
    await _prefs?.setString('open_ai_model', newValue);
  }

  Future<String> getApiKey() async {
    return _prefs?.getString('open_ai_api_key') ?? '';
  }

  Future<void> setApiKey(String newValue) async {
    await _prefs?.setString('open_ai_api_key', newValue);
  }

  Future<String> getApiOrg() async {
    return _prefs?.getString('open_ai_org') ?? '';
  }

  Future<void> setApiOrg(String newValue) async {
    await _prefs?.setString('open_ai_org', newValue);
  }
}
