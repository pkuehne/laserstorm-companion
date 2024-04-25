import 'package:flutter/foundation.dart';

abstract class Template {
  int id;
  String name;

  Template({this.id = 0, this.name = ""});

  double cost();

  int ensureId() {
    if (id == 0) {
      id = UniqueKey().hashCode;
    }
    return id;
  }

  @override
  toString() {
    return name;
  }
}
