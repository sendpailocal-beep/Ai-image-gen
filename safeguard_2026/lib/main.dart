import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sos_logic.dart';

void main() => runApp(MaterialApp(home: SafeGuardHome()));

class SafeGuardHome extends StatefulWidget {
  @override
  _SafeGuardHomeState createState() => _SafeGuardHomeState();
}

class _SafeGuardHomeState extends State<SafeGuardHome> {
  String _guardianNum = "";
  bool _useWhatsApp = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _guardianNum = prefs.getString('num') ?? "";
      _useWhatsApp = prefs.getBool('wa') ?? false;
      _controller.text = _guardianNum;
    });
  }

  _save(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('num', val);
    setState(() => _guardianNum = val);
  }

  _toggleWA(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wa', val);
    setState(() => _useWhatsApp = val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SafeGuard 2026')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Guardian Number", border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
              onChanged: _save,
            ),
            SwitchListTile(
              title: Text("Use WhatsApp (Data Mode)"),
              subtitle: Text("Uses MB instead of SMS credit"),
              value: _useWhatsApp,
              onChanged: _toggleWA,
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.red.shade100,
              child: Text("4x Volume Up = EMERGENCY SOS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ),
            SizedBox(height: 10),
            Text("Setup: 1. Add Number. 2. Turn on Accessibility. DONE.", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
