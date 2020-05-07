import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class UrlLauncherUtils {
  static Future<void> makePhoneCall(int mobileNumber) async {
    String callURL = 'tel:+91$mobileNumber';
    if (await UrlLauncher.canLaunch(callURL)) {
      await UrlLauncher.launch(callURL);
    } else {
      throw 'Could not make Phone to $mobileNumber';
    }
  }

  static Future<void> makeSMS(int mobileNumber) async {
    String callURL = 'sms:+91$mobileNumber';
    if (await UrlLauncher.canLaunch(callURL)) {
      await UrlLauncher.launch(callURL);
    } else {
      throw 'Could not send SMS to $mobileNumber';
    }
  }
}