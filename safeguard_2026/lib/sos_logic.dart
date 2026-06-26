import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSLogic {
  static Future<void> trigger() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contacts = prefs.getStringList('contacts') ?? [];
    bool useWA = prefs.getBool('wa') ?? false;

    if (contacts.isEmpty) return;

    // 1. Get High Accuracy Location
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String maps = "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";
    String msg = "🚨 EMERGENCY! 🚨\nMy Live Location: $maps\nPlease help me immediately!";

    // 2. Loop through all contacts
    for (String num in contacts) {
      if (useWA) {
        // WhatsApp Mode (Free via Data)
        final waUrl = Uri.parse("https://wa.me/$num?text=${Uri.encodeComponent(msg)}");
        if (await canLaunchUrl(waUrl)) {
          await launchUrl(waUrl, mode: LaunchMode.externalApplication);
        }
      } else {
        // Default SMS Mode
        final smsUrl = Uri(scheme: 'sms', path: num, queryParameters: {'body': msg});
        if (await canLaunchUrl(smsUrl)) {
          await launchUrl(smsUrl);
        }
      }

      // 3. Small delay to ensure message is triggered, then CALL
      await Future.delayed(Duration(seconds: 3));

      final telUrl = Uri(scheme: 'tel', path: num);
      if (await canLaunchUrl(telUrl)) {
        await launchUrl(telUrl);
      }

      // Wait before moving to next contact to prevent system crash/flood
      await Future.delayed(Duration(seconds: 2));
    }
  }
}
