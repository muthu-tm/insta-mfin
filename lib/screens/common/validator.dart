import 'package:email_validator/email_validator.dart';

class FieldValidator {
  static String mobileValidator(
      String number, Function(String) setMobileNumberState) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (number.length == 0) {
      return 'Please enter Mobile Number';
    } else if (!regExp.hasMatch(number)) {
      return 'Please enter valid Mobile Number';
    } else if (number.length != 10) {
      return 'Mobile Number must be of 10 digit';
    }

    setMobileNumberState(number);
    return null;
  }

  static String emailValidator(String emailID, Function(String) setEmailState) {
    if (emailID.isEmpty) {
      return 'Please enter your EmailID';
    }

    bool isValid = EmailValidator.validate(emailID);

    if (!isValid) {
      return "Please enter valid EmailID";
    }

    setEmailState(emailID);
    return null;
  }

  static String passwordValidator(
      String passkey, Function(String) setPasskeyState) {
    if (passkey.isEmpty) {
      return 'Password is required';
    } else if (passkey.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    setPasskeyState(passkey);
    return null;
  }
}
