import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _modelOptions = ['gpt-3.5-turbo', 'gpt-4'];
  String _selectedOption = 'gpt-3.5-turbo';
  String _apiKey = '';

  void _setModel(String model) {
    setState(() {
      _selectedOption = model;
    });
  }

  void _setAPIKey(String key) {
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
                value: _selectedOption,
                items: _modelOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _setModel(newValue!);
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
              onChanged: (value) => _setAPIKey(value),
            ),
            subtitle: ElevatedButton(
              onPressed: () {
                // Handle button press
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
