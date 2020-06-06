import 'package:instamfin/services/controllers/notification/n_controller.dart';

class NUtils {
  static NController _nc = NController();

  static financeNotify(String logo, String title, String desc) {
    _nc.create(logo, title, desc, 5, null, null);
  }

  static userNotify(String logo, String title, String desc, int number) {
    _nc.create(logo, title, desc, 6, number, null);
  }

  static custNotify(String logo, String title, String desc, int number) {
    _nc.create(logo, title, desc, 4, null, number);
  }

  static generalNotify(String logo, String title, String desc) {
    _nc.create(logo, title, desc, 1, null, null);
  }

  static alertNotify(String logo, String title, String desc) {
    _nc.create(logo, title, desc, 3, null, null);
  }
}
