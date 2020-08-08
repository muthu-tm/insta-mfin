import 'package:instamfin/db/models/notification.dart';
import 'package:instamfin/services/analytics/analytics.dart';

class NController {
  Future create(
      String logo, String title, String desc, int type, int uNumber) async {
    try {
      Notification _n = Notification();
      _n.type = type;
      _n.desc = desc;
      _n.title = title;
      _n.logoPath = logo;
      _n.userNumber = uNumber;

      _n.create();
    } catch (err) {
      Analytics.reportError(
          {'type': 'notification_create_error', 'error': err.toString()},
          'notification');
    }
  }
}
