import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sos_logic.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(primarySwatch: Colors.red),
  home: SafeGuardHome()
));

class SafeGuardHome extends StatefulWidget {
  @override
  _SafeGuardHomeState createState() => _SafeGuardHomeState();
}

class _SafeGuardHomeState extends State<SafeGuardHome> {
  List<String> _contacts = [];
  bool _useWhatsApp = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    // In a real app, you'd check for the trigger here if the app is launched via the service
    _checkForTrigger();
  }

  _checkForTrigger() async {
    // This is just a placeholder to simulate the trigger when the app opens via Accessibility Service
    // In production, the service starts this logic
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contacts = prefs.getStringList('contacts') ?? [];
      _useWhatsApp = prefs.getBool('wa') ?? false;
    });
  }

  _addContact() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _contacts.add(_controller.text);
        _controller.clear();
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('contacts', _contacts);
    }
  }

  _removeContact(int index) async {
    setState(() {
      _contacts.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('contacts', _contacts);
  }

  _toggleWA(bool val) async {
    setState(() => _useWhatsApp = val);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wa', val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SafeGuard 2026')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Add Emergency Contact",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addContact,
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(minimumSize: Size(50, 55)),
                )
              ],
            ),
            SwitchListTile(
              title: Text("WhatsApp Mode (Uses MB)"),
              subtitle: Text("Sends location via WhatsApp if ON"),
              value: _useWhatsApp,
              onChanged: _toggleWA,
            ),
            Divider(),
            Text("Your Emergency Contacts:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_contacts[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeContact(index),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              color: Colors.red,
              child: Text(
                "PRESS VOLUME BUTTON 4 TIMES\nTO ALERT ALL CONTACTS",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
