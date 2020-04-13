enum Gender { Male, Female }

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.Male:
        return "Male";
        break;
      case Gender.Female:
        return "Female";
        break;
      default:
        return null;
    }
  }
}
