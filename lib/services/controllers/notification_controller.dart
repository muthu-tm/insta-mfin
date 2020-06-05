import 'package:instamfin/db/models/notification.dart';
import 'package:instamfin/services/analytics/analytics.dart';

class NotificationController {
  Future create(String logo, String title, String desc, int type) async {
    try {
      Notification noti = Notification();
      noti.type = type;
      noti.desc = desc;
      noti.title = title;
      noti.logoPath = logo;

      noti.create();
    } catch (err) {
      Analytics.sendAnalyticsEvent(
          'notification_create_error', {'error': err.toString()});
    }
  }
}
