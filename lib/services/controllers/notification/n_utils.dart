import 'package:instamfin/services/controllers/notification/n_controller.dart';

class NUtils {
  static NController _nc = NController();

  static userNotify(String logo, String title, String desc, int number) {
    _nc.create(logo, title, desc, 1, number);
  }
}
