// Main entry point for SafeGuard 2026
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

void main() {
  runApp(SafeGuardApp());
}

class SafeGuardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeGuard 2026',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isServiceActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SafeGuard 2026')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isServiceActive ? Icons.shield : Icons.shield_outlined,
              size: 100,
              color: _isServiceActive ? Colors.green : Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              _isServiceActive ? 'System Active' : 'System Inactive',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isServiceActive = !_isServiceActive;
                });
              },
              child: Text(_isServiceActive ? 'Deactivate SOS' : 'Activate SOS'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Tip: Press Volume Up 3 times to trigger Ghost SOS.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
