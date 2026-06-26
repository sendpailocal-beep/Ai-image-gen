import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * SAFEGUARD 2026 - COMPLETE CORE
 * Copy and paste this into your lib/main.dart for instant setup.
 */

void main() => runApp(MaterialApp(theme: ThemeData(primarySwatch: Colors.red), home: SOSHome()));

class SOSHome extends StatefulWidget {
  @override
  _SOSHomeState createState() => _SOSHomeState();
}

class _SOSHomeState extends State<SOSHome> {
  List<String> _nums = [];
  bool _isWA = false;
  final TextEditingController _c = TextEditingController();

  @override
  void initState() { super.initState(); _load(); }

  _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _nums = p.getStringList('n') ?? [];
      _isWA = p.getBool('w') ?? false;
    });
  }

  _add() async {
    if (_c.text.isEmpty) return;
    _nums.add(_c.text);
    _c.clear();
    final p = await SharedPreferences.getInstance();
    await p.setStringList('n', _nums);
    setState(() {});
  }

  _trigger() async {
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String msg = "EMERGENCY! My Location: https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";
    for (var n in _nums) {
      if (_isWA) {
        await launchUrl(Uri.parse("https://wa.me/$n?text=${Uri.encodeComponent(msg)}"), mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri(scheme: 'sms', path: n, queryParameters: {'body': msg}));
      }
      await Future.delayed(Duration(seconds: 2));
      await launchUrl(Uri(scheme: 'tel', path: n));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SafeGuard 2026")),
      body: Column(
        children: [
          TextField(controller: _c, decoration: InputDecoration(labelText: "Add Guardian Number")),
          ElevatedButton(onPressed: _add, child: Text("Save Number")),
          SwitchListTile(title: Text("WhatsApp Mode (Free)"), value: _isWA, onChanged: (v) async {
            setState(() => _isWA = v);
            (await SharedPreferences.getInstance()).setBool('w', v);
          }),
          Expanded(child: ListView(children: _nums.map((n) => ListTile(title: Text(n))).toList())),
          InkWell(
            onLongPress: _trigger,
            child: Container(color: Colors.red, height: 100, width: double.infinity, child: Center(child: Text("HOLD TO TEST SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ),
          Padding(padding: EdgeInsets.all(10), child: Text("4x Volume Up = SOS (Requires Setup)", style: TextStyle(fontSize: 10))),
        ],
      ),
    );
  }
}
