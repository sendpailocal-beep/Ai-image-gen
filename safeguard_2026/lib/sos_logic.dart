import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSLogic {
  static Future<void> startSOS(List<String> contacts) async {
    // 1. Get Location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    String locationMsg = "EMERGENCY! I need help. My location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

    // 2. Send SMS/Call for each contact
    for (String contact in contacts) {
      await _sendSMS(contact, locationMsg);
      await _makeCall(contact);
    }
  }

  static Future<void> _sendSMS(String number, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: <String, String>{'body': message},
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  static Future<void> _makeCall(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }
}
