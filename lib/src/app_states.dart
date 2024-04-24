import 'package:flutter/material.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/weapon.dart';
import 'package:weasel/src/laserstorm/unit.dart';

class AppState extends ChangeNotifier {
  var _counter = 0;
  final _weapons = {
    1: Weapon(
        id: 1,
        name: "Small arms",
        type: WeaponType.ai,
        range: 20,
        shots: 1,
        impact: 0,
        traits: []),
    2: Weapon(
        id: 2,
        name: "Carl Gustav",
        type: WeaponType.at,
        range: 10,
        shots: 1,
        impact: 3,
        traits: []),
    3: Weapon(
        id: 3,
        name: "Machine Gun",
        type: WeaponType.ai,
        range: 20,
        shots: 2,
        impact: 0,
        traits: []),
  };
  final _stands = {
    1: Stand(id: 1, name: "Infantry Fire-team"),
    2: Stand(
      id: 2,
      name: "Infantry Fighting Vehicle",
      type: StandType.vehicle,
      transports: 6,
    ),
  };

  final _units = {
    1: Unit(
      id: 1,
      name: "Marine Company",
      stand: Stand(id: 1, name: "Infantry Fire-team"),
    ),
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

  // Stand
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

  // Units
  void setUnit(Unit unit) {
    _units[unit.id] = unit;
    notifyListeners();
  }

  void removeUnit(int id) {
    _units.remove(id);
    notifyListeners();
  }

  List<Unit> get units {
    return _units.values.toList();
  }

  Unit getUnit(int id) {
    return _units[id]!;
  }

  bool hasUnit(int id) {
    return _units.containsKey(id);
  }

  // Counters

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
