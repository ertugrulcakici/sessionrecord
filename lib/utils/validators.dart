String? validateDouble(String? value) {
  if (value == null) {
    return null;
  }
  if (value.isEmpty) {
    return null;
  }
  if (double.tryParse(value) == null) {
    return "Lütfen sayı giriniz";
  }
  return null;
}

String? validateInt(String? value) {
  if (value == null) {
    return null;
  }
  if (value.isEmpty) {
    return null;
  }
  if (int.tryParse(value) == null) {
    return "Lütfen sayı giriniz";
  }
  return null;
}

// create a number validator with form of xxx-xxx-xx-xx
String? validatePhoneNumber(String? value) {
  if (value == null) {
    return null;
  }
  if (value.isEmpty) {
    return null;
  }
  List<String> _splitted = value.split(" ");
  if (_splitted.length == 4 || _splitted.length == 3) {
    bool _done = true;
    for (var element in _splitted) {
      if (int.tryParse(element) == null) {
        _done = false;
      }
    }

    if (_splitted.length == 4) {
      if (_splitted[0].length != 3 ||
          _splitted[1].length != 3 ||
          _splitted[2].length != 2 ||
          _splitted[3].length != 2) {
        _done = false;
      }
    } else if (_splitted.length == 3) {
      if (_splitted[0].length != 3 ||
          _splitted[1].length != 3 ||
          _splitted[2].length != 4) {
        _done = false;
      }
    }

    if (_done) {
      return null;
    }
    return "Lütfen geçerli bir telefon numarası giriniz";
  } else {
    return "Lütfen geçerli bir telefon numarası giriniz";
  }
}
