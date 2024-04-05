import 'package:flutter_test/flutter_test.dart';
import 'package:weasel/src/laserstorm/weapon.dart';

void main() {
  test('Default cost is one', () {
    // Given
    var weapon = Weapon.empty();

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(1)); // 1 point per shot
  });

  test('A larger Range costs more', () {
    // Given
    var weapon = Weapon.empty();
    weapon.range = 40;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(10));
  });

  test('The Heavy trait reduces cost by 1', () {
    // Given
    var weapon = Weapon.empty();
    weapon.range = 20;
    weapon.traits = ["Heavy"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(1));
  });

  test('The Indirect trait increases by three', () {
    // Given
    var weapon = Weapon.empty();
    weapon.traits = ["Indirect"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(3));
  });

  test('save of -1 adds two to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -1;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(2));
  });

  test('save of -5 adds ten to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -5;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(10));
  });

  test('save of greater than -6 adds another 2 to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -7;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(16));
  });

  test('save of greater than -10 adds another 5 to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -11;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(29));
  });

  test('frag trait reduces save cost by 25%', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -6;
    weapon.traits = ["Frag"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(9));
  });

  test('burst trait adds 4 to 0 save cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = 0;
    weapon.traits = ["Burst"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(4));
  });

  test('burst trait adds 2 to -2 save cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -2;
    weapon.traits = ["Burst"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(6));
  });

  test('flame trait adds another 6 to save cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = 0;
    weapon.traits = ["Flame"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(6));
  });

  test('Additional shot adds 50% of (rangeCost + saveCost)', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -2;
    weapon.range = 20;
    weapon.shots = 2;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(9));
  });

  test('Repeating trait adds 0.5 cost per shot', () {
    // Given
    var weapon = Weapon.empty();
    weapon.shots = 2;
    weapon.range = 20;
    weapon.traits = ["Repeating"];

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(3));
  });

  test('Minimum cost is 1 point per shot', () {
    // Given
    var weapon = Weapon.empty();
    weapon.shots = 10;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(10));
  });

  test('GP weapons add 50% to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.save = -1;
    weapon.range = 20;
    weapon.type = WeaponType.gp;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(6));
  });

  test('Check pre-build costs', () {
    expect(
        Weapon(1, "Small arms", WeaponType.ai, 20, 1, 0, []).cost(), equals(2));
    expect(
        Weapon(2, "Buzzbombs", WeaponType.at, 10, 1, -3, []).cost(), equals(6));
    expect(Weapon(3, "Machine gun", WeaponType.ai, 20, 2, 0, []).cost(),
        equals(3));
    expect(Weapon(4, "Gauss rifle", WeaponType.gp, 20, 1, -1, []).cost(),
        equals(6));
    expect(Weapon(5, "Fusion gun", WeaponType.at, 10, 1, -4, []).cost(),
        equals(8));
    expect(Weapon(6, "Plasma rifle", WeaponType.gp, 10, 1, -2, []).cost(),
        equals(6));
    expect(
        Weapon(7, "Infantry laser", WeaponType.at, 40, 1, -3, ["Heavy", "Aim"])
            .cost(),
        equals(15));
  });
}
