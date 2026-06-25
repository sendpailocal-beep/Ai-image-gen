import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sos_logic.dart';

void main() {
  runApp(SafeGuardApp());
}

class SafeGuardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeGuard 2026',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ContactManager(),
    );
  }
}

class ContactManager extends StatefulWidget {
  @override
  _ContactManagerState createState() => _ContactManagerState();
}

class _ContactManagerState extends State<ContactManager> {
  List<String> _contacts = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState() ;
    _loadContacts();
  }

  _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _contacts = prefs.getStringList('contacts') ?? [];
    });
  }

  _addContact() async {
    if (_controller.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _contacts.add(_controller.text);
      await prefs.setStringList('contacts', _contacts);
      _controller.clear();
      setState(() {});
    }
  }

  _removeContact(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _contacts.removeAt(index);
    await prefs.setStringList('contacts', _contacts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Contacts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: _addContact),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_contacts[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeContact(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => SOSLogic.startSOS(_contacts),
              child: Text('TEST SOS (Manual)', style: TextStyle(color: Colors.white)),
            ),
          ),
          Text("Note: Press Volume Up 4 times to trigger automatically.", style: TextStyle(fontSize: 12, color: Colors.grey))
        ],
      ),
    );
  }
}
