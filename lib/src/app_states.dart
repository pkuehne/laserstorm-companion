import 'package:flutter/material.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/taskforce.dart';
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
  final Map<int, TaskForce> _taskforces = {};

  /// Creates or updates the given [Weapon] based on its id field
  void setWeapon(Weapon weapon) {
    weapon.ensureId();
    _weapons[weapon.id] = weapon;
    notifyListeners();
  }

  void duplicateWeapon(Weapon weapon) {
    var newWeapon = Weapon.clone(weapon);
    newWeapon.id = 0;
    setWeapon(newWeapon);
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

  void duplicateStand(Stand stand) {
    var newStand = Stand.clone(stand);
    newStand.id = 0;
    setStand(newStand);
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

  void duplicateUnit(Unit unit) {
    var newUnit = Unit.clone(unit);
    newUnit.id = 0;
    setUnit(newUnit);
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

  // Taskforces
  void setTaskForce(TaskForce tf) {
    tf.ensureId();
    _taskforces[tf.id] = tf;
    notifyListeners();
  }

  void duplicateTaskForce(TaskForce tf) {
    var newTaskforce = TaskForce.clone(tf);
    newTaskforce.id = 0;
    setTaskForce(newTaskforce);
  }

  void removeTaskForce(TaskForce tf) {
    _taskforces.remove(tf.id);
    notifyListeners();
  }

  List<TaskForce> get taskforces {
    return _taskforces.values.toList();
  }

  TaskForce getTaskForce(int id) {
    return _taskforces[id]!;
  }
}

class LaserstormState extends ChangeNotifier {
  var x = 0;
}
