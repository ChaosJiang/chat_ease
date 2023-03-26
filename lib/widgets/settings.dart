import 'package:flutter/material.dart';
import 'package:chat_ease/store/shared_preferences_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.prefsManager});

  final SharedPreferencesManager prefsManager;

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final List<String> _modelOptions = ['gpt-3.5-turbo', 'gpt-4'];
  String _selectedModel = 'gpt-3.5-turbo';
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _loadModel();
  }

  Future<void> _loadModel() async {
    String model = await widget.prefsManager.getModel();
    setState(() {
      _selectedModel = model;
    });
  }

  Future<void> _loadApiKey() async {
    String apiKey = await widget.prefsManager.getApiKey();
    setState(() {
      _apiKey = apiKey;
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

  void _validateAPIKey() {
    // TODO
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
                _validateAPIKey();
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
