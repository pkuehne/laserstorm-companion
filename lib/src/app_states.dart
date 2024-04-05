import 'package:flutter/material.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import '/src/laserstorm/weapon.dart';

class AppState extends ChangeNotifier {
  var _counter = 0;
  final _weapons = {
    1: Weapon(1, "Small arms", WeaponType.ai, 20, 1, 0, []),
    2: Weapon(2, "Carl Gustav", WeaponType.at, 10, 1, -3, []),
    3: Weapon(3, "Machine Gun", WeaponType.ai, 20, 2, 0, []),
  };
  final _stands = {
    1: Stand(
        1, "Infantry Fire-team", StandType.infantry, 4, 0, 5, 0, 24, 6, [], []),
  };

  /// Creates or updates the given [Weapon] based on its id field
  void setWeapon(Weapon weapon) {
    _weapons[weapon.id] = weapon;
    notifyListeners();
  }

  void removeWeapon(int id) {
    _weapons.remove(id);
    notifyListeners();
  }

  void clearWeapons() {
    _weapons.clear();
    notifyListeners();
  }

  bool hasWeapon(int id) {
    return _weapons.containsKey(id);
  }

  Weapon getWeapon(int id) {
    return _weapons[id]!;
  }

  int weaponCount() {
    return _weapons.values.length;
  }

  List<Weapon> get weapons {
    return _weapons.values.toList();
  }

  void setStand(Stand stand) {
    _stands[stand.id] = stand;
    notifyListeners();
  }

  void removeStand(int id) {
    _stands.remove(id);
    notifyListeners();
  }

  List<Stand> get stands {
    return _stands.values.toList();
  }

  Stand getStand(int id) {
    return _stands[id]!;
  }

  bool hasStand(int id) {
    return _stands.containsKey(id);
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  int get counter {
    return _counter;
  }
}

class LaserstormState extends ChangeNotifier {
  var x = 0;
}
