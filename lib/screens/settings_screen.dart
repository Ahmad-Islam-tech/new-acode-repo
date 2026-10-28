import 'package:flutter/material.dart';

/// App preferences will eventually be saved locally on the user's device.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Reading appearance'),
            subtitle: Text('Font size, text colour, and reading background — coming next'),
          ),
          ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Languages'),
            subtitle: Text('Arabic, English, and Luganda — coming next'),
          ),
          ListTile(
            leading: Icon(Icons.offline_pin_outlined),
            title: Text('Offline library'),
            subtitle: Text('Local storage and offline reading — coming next'),
          ),
        ],
      ),
    );
  }
}
