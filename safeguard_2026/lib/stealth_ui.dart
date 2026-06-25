import 'package:flutter/material.dart';

class GhostOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Completely black screen
      child: Center(
        child: Text(
          '', // No text, looks like phone is off
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class FakePowerOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Shutting down...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
