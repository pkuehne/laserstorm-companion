import 'package:flutter/material.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/weapon.dart';
import 'package:weasel/src/laserstorm/unit.dart';

class AppState extends ChangeNotifier {
  AppState({bool initialize = true}) {
    if (initialize) {
      initializeSamples();
    }
  }

  initializeSamples() {
    var smallArms = Weapon(
        name: "Small Arms",
        type: WeaponType.ai,
        range: 20,
        shots: 1,
        impact: 0);
    setWeapon(smallArms);
    var carlGustav = Weapon(
        name: "Carl Gustav",
        type: WeaponType.at,
        range: 10,
        shots: 1,
        impact: 3);
    setWeapon(carlGustav);
    var mg = Weapon(
        id: 3,
        name: "Machine Gun",
        type: WeaponType.gp,
        range: 20,
        shots: 2,
        impact: 0,
        traits: []);
    setWeapon(mg);

    var fireTeam = Stand(
      name: "Infantry Fire-team",
      primaries: [smallArms],
      selectables: [mg, carlGustav],
    );
    setStand(fireTeam);
    var ifv = Stand(
      name: "Infantry Fighting Vehicle",
      type: StandType.vehicle,
      primaries: [mg],
      transports: 2,
    );
    setStand(ifv);

    var squad = Unit(
      name: "Infantry Platoon",
      stand: fireTeam,
      size: 6,
      transportSize: 3,
      transport: ifv,
    );
    setUnit(squad);
  }

  final Map<int, Weapon> _weapons = {};
  final Map<int, Stand> _stands = {};
  final Map<int, Unit> _units = {};

  /// Creates or updates the given [Weapon] based on its id field
  void setWeapon(Weapon weapon) {
    weapon.ensureId();
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
    stand.ensureId();
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
    unit.ensureId();
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
}

class LaserstormState extends ChangeNotifier {
  var x = 0;
}
