import 'package:flutter/material.dart';
import 'package:chat_ease/utils/shared_preferences_util.dart';

import '../api/chat_api.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.chatApi});

  final ChatApi chatApi;

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final String _invalidKeyMsg =
      'Incorrect API key provided. You can find your API key at https://platform.openai.com/account/api-keys.';
  final String _validKeyMsg = 'Validate success';
  final List<String> _modelOptions = ['gpt-3.5-turbo', 'gpt-4'];
  String _selectedModel = '';
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String model = SharedPreferencesUtil.prefs.getString('open_ai_model') ??
        'gpt-3.5-turbo';
    setState(() {
      _selectedModel = model;
    });
  }

  Future<void> _loadApiKey() async {
    String apiKey =
        SharedPreferencesUtil.prefs.getString('open_ai_api_key') ?? '';
    setState(() {
      _apiKey = apiKey;
    });
  }

  void _saveModel(String model) async {
    setState(() {
      _selectedModel = model;
    });
    SharedPreferencesUtil.prefs.setString('open_ai_model', model);
  }

  void _saveAPIKey(String key) async {
    setState(() {
      _apiKey = key;
    });
    SharedPreferencesUtil.prefs.setString('open_ai_api_key', key);
  }

  Future<bool> _validateAPIKey() async {
    // if (isValid) {
    //   (await SharedPreferencesManager.getInstance()).setApiKey(_apiKey);
    // }
    return await widget.chatApi.validateApiKey(_apiKey);
  }

  void _showAlertDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(child: Text('OK'))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(children: [
          _buildSectionHeader('Default Settings'),
          ListTile(
            title: const Text('Model'),
            trailing: DropdownButton<String>(
                value: _selectedModel,
                items: _modelOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _saveModel(newValue!);
                }),
          ),
          _buildSectionHeader('API KEY'),
          ListTile(
            title: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your API KEY',
              ),
              onChanged: (value) => _saveAPIKey(value),
            ),
            subtitle: ElevatedButton(
              onPressed: () {
                _validateAPIKey().then((isValid) => {
                      if (isValid)
                        _showAlertDialog(context, _validKeyMsg)
                      else
                        _showAlertDialog(context, _invalidKeyMsg)
                    });
              },
              child: const Text('Validate'),
            ),
          )
        ]));
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
