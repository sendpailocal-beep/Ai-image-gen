import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSLogic {
  static Future<void> startSOS(List<String> contacts) async {
    if (contacts.isEmpty) return;

    // 1. Get current Location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    String mapsUrl = "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    String message = "EMERGENCY! I am in danger. My live location: $mapsUrl";

    // 2. Loop through contacts
    for (String number in contacts) {
      // Send SMS
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: number,
        queryParameters: <String, String>{'body': message},
      );

      // Auto Call
      final Uri telUri = Uri(scheme: 'tel', path: number);

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }

      // Small delay between actions
      await Future.delayed(Duration(seconds: 2));

      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      }
    }
  }
}
