class Validators {

  static bool emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return false;
    }
    return true;
  }

  static bool passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    if (value.length < 6) {
      return false;
    }
    return true;
  }

  static bool validateUrl(String url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }
}