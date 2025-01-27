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
    var cost = weapon.rangeCost();

    // Then
    expect(cost, equals(10));
  });

  test('The Heavy trait reduces cost by 1', () {
    // Given
    var weapon = Weapon.empty();
    weapon.range = 20;
    weapon.traits = ["Heavy"];

    // When
    var cost = weapon.rangeCost();

    // Then
    expect(cost, equals(1));
  });

  test('The Indirect trait increases by three', () {
    // Given
    var weapon = Weapon.empty();
    weapon.traits = ["Indirect"];

    // When
    var cost = weapon.rangeCost();

    // Then
    expect(cost, equals(3));
  });

  test('Impact of 4 adds 8 to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.impact = 4;

    // When
    var cost = weapon.impactCost();

    // Then
    expect(cost, equals(8));
  });

  test('Impact of 10 adds 22 to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.impact = 10;

    // When
    var cost = weapon.impactCost();

    // Then
    expect(cost, equals(22));
  });

  test('Impact of 15 adds 37 to cost', () {
    // Given
    var weapon = Weapon.empty();
    weapon.impact = 15;

    // When
    var cost = weapon.impactCost();

    // Then
    expect(cost, equals(37));
  });

  test('Flame trait adds 6', () {
    // Given
    var weapon = Weapon.empty();
    weapon.traits = ["Flame"];

    // When
    var cost = weapon.impactCost();

    // Then
    expect(cost, equals(6));
  });

  test('Burst trait adds impact+4', () {
    // Given
    var weapon = Weapon.empty();
    weapon.traits = ["Burst"];
    weapon.impact = 2;

    // When
    var cost = weapon.impactCost();

    // Then
    expect(cost, equals(10)); // 4 from impact (2+4) from burst
  });

  test('Frag trait reduces save cost by 25%', () {
    // Given
    var weapon = Weapon.empty();
    weapon.impact = 15;
    weapon.traits = ["Frag"];

    // When
    var cost = weapon.impactCost();

    // Then
    expect(cost, equals(27.75));
  });

  test('Additional shot adds 50% of (rangeCost + impactCost)', () {
    // Given
    var weapon = Weapon.empty();
    weapon.impact = 2;
    weapon.range = 20;
    weapon.shots = 2;

    // When
    var cost = weapon.shotsCost();

    // Then
    expect(cost, equals(3));
  });

  test('Repeating trait adds 0.5 cost per shot', () {
    // Given
    var weapon = Weapon.empty();
    weapon.shots = 2;
    weapon.traits = ["Repeating Fire"];

    // When
    var cost = weapon.shotsCost();

    // Then
    expect(cost, equals(1));
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
    weapon.impact = 2;
    weapon.type = WeaponType.gp;

    // When
    var cost = weapon.cost();

    // Then
    expect(cost, equals(6));
  });

  test('Check pre-build costs', () {
    expect(
        Weapon(
            id: 1,
            name: "Small arms",
            type: WeaponType.ai,
            range: 20,
            shots: 1,
            impact: 0,
            traits: []).cost(),
        equals(2));
    expect(
        Weapon(
                id: 2,
                name: "Buzzbombs",
                type: WeaponType.at,
                range: 10,
                shots: 1,
                impact: 3)
            .cost(),
        equals(6));
    expect(
        Weapon(
          id: 3,
          name: "Machine gun",
          type: WeaponType.ai,
          range: 20,
          shots: 2,
          impact: 0,
        ).cost(),
        equals(3)); // TODO: Differs from the rule book
    expect(
        Weapon(
          id: 4,
          name: "Gauss rifle",
          type: WeaponType.gp,
          range: 20,
          shots: 1,
          impact: 1,
        ).cost(),
        equals(6));
    expect(
        Weapon(
          id: 5,
          name: "Fusion gun",
          type: WeaponType.at,
          range: 10,
          shots: 1,
          impact: 4,
        ).cost(),
        equals(8));
    expect(
        Weapon(
          id: 6,
          name: "Plasma rifle",
          type: WeaponType.gp,
          range: 10,
          shots: 1,
          impact: 2,
        ).cost(),
        equals(6));
    expect(
        Weapon(
            id: 7,
            name: "Infantry laser",
            type: WeaponType.at,
            range: 40,
            shots: 1,
            impact: 3,
            traits: ["Heavy", "Targeting"]).cost(),
        equals(15));
  });
}
