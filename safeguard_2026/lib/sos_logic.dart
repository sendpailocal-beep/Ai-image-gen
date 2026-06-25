import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSLogic {
  static Future<void> trigger() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String num = prefs.getString('num') ?? "";
    bool useWA = prefs.getBool('wa') ?? false;

    if (num.isEmpty) return;

    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String maps = "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";
    String msg = "🚨 EMERGENCY! 🚨\nI need help immediately!\nMy LIVE LOCATION: $maps\n(Please track me now!)";

    if (useWA) {
      final waUrl = Uri.parse("https://wa.me/$num?text=${Uri.encodeComponent(msg)}");
      if (await canLaunchUrl(waUrl)) await launchUrl(waUrl, mode: LaunchMode.externalApplication);
    } else {
      final smsUrl = Uri(scheme: 'sms', path: num, queryParameters: {'body': msg});
      if (await canLaunchUrl(smsUrl)) await launchUrl(smsUrl);
    }

    await Future.delayed(Duration(seconds: 2));
    final telUrl = Uri(scheme: 'tel', path: num);
    if (await canLaunchUrl(telUrl)) await launchUrl(telUrl);
  }
}
