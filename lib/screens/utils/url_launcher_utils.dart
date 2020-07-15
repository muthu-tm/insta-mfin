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
  
  static Future<void> sendEmail(String to, String subject, String body) async {
    String mailURL = 'mailto:$to?subject=$subject&body=$body';
    if (await UrlLauncher.canLaunch(mailURL)) {
      await UrlLauncher.launch(mailURL);
    } else {
      throw 'Could not send Email to $to';
    }
  }
  
  static Future<void> launchURL(String url) async {
    if (await UrlLauncher.canLaunch(url)) {
      await UrlLauncher.launch(url);
    } else {
      throw 'Could not launch URL $url';
    }
  }
}