import 'package:flutter/foundation.dart';

abstract class Item {
  int id;
  String name;

  Item({this.id = 0, this.name = ""});

  double cost();

  int ensureId() {
    if (id == 0) {
      id = UniqueKey().hashCode;
    }
    return id;
  }
}
