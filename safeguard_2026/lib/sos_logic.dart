import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSLogic {
  static Future<void> trigger() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String num = prefs.getString('num') ?? "";
    bool useWA = prefs.getBool('wa') ?? false;

    if (num.isEmpty) return;

    Position pos = await Geolocator.getCurrentPosition();
    String maps = "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";
    String msg = "EMERGENCY! My location: $maps";

    if (useWA) {
      // WhatsApp Mode (Free via MB)
      final waUrl = Uri.parse("https://wa.me/$num?text=${Uri.encodeComponent(msg)}");
      if (await canLaunchUrl(waUrl)) await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      // Default Phone/SMS Mode
      final smsUrl = Uri(scheme: 'sms', path: num, queryParameters: {'body': msg});
      if (await canLaunchUrl(smsUrl)) await launchUrl(smsUrl);
    }

    // Always attempt a voice call as backup
    await Future.delayed(Duration(seconds: 2));
    final telUrl = Uri(scheme: 'tel', path: num);
    if (await canLaunchUrl(telUrl)) await launchUrl(telUrl);
  }
}
