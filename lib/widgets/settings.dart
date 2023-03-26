import 'package:flutter/material.dart';
import 'package:chat_ease/store/shared_preferences_manager.dart';

import '../api/chat_api.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.chatApi});

  final ChatApi chatApi;

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final String _defaultModel = 'gpt-3.5-turbo';
  final String _invalidKeyMsg =
      'Incorrect API key provided. You can find your API key at https://platform.openai.com/account/api-keys.';
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
    String model =
        await (await SharedPreferencesManager.getInstance()).getModel();
    setState(() {
      _selectedModel = model.isNotEmpty ? model : _defaultModel;
    });
  }

  Future<void> _loadApiKey() async {
    String apiKey =
        await (await SharedPreferencesManager.getInstance()).getApiKey();
    setState(() {
      _apiKey = apiKey.isEmpty ? _defaultModel : apiKey;
    });
  }

  void _saveModel(String model) {
    setState(() {
      _selectedModel = model;
    });
  }

  void _saveAPIKey(String key) {
    setState(() {
      _apiKey = key;
    });
  }

  void _validateAPIKey(BuildContext context) async {
    bool isValid = await widget.chatApi.validateApiKey(_apiKey);
    if (isValid) {
      (await SharedPreferencesManager.getInstance()).setApiKey(_apiKey);
    }
    _showAlertDialog(context);
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(_invalidKeyMsg),
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
                _validateAPIKey(context);
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
