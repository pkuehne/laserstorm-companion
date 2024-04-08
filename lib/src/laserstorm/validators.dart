/// This library contains function to validate a weapon
library;

/// Validates a weapon name
String? notEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return "Can't be empty";
  }
  return null;
}

String? strictlyPositiveNumber(String? value) {
  int numValue = int.parse(value!);
  if (numValue < 1) {
    return "Must be a non-zero positive number";
  }
  return null;
}

String? positiveNumber(String? value) {
  int numValue = int.parse(value!);
  if (numValue < 0) {
    return "Number must be positive number";
  }
  return null;
}

String? traits(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  List<String> traits = value.split(',');
  List<String> traitList = [
    "Aim",
    "Burst",
    "Flame",
    "Frag",
    "Heavy",
    "Indirect",
    "Rapid",
    "Repeating",
  ];
  for (final trait in traits) {
    if (!traitList.any((String value) => value.contains(trait.trim()))) {
      return "$trait is not a valid trait";
    }
  }
  return null;
}
