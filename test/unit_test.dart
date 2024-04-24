import 'package:flutter_test/flutter_test.dart';
import 'package:weasel/src/laserstorm/unit.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/weapon.dart';

void main() {
  test("stands multiplies by stand size", () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;
    var unit = Unit(id: 1, name: "", stand: stand);
    unit.size = 6;

    // When
    var cost = unit.cost();

    // Then
    expect(cost, equals(10));
  });

  test("Rounds to nearest 5", () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;
    var unit = Unit(id: 1, name: "", stand: stand);
    unit.size = 6;

    // When
    var cost = unit.cost();

    // Then
    expect(cost, equals(10));
  });

  test("Transports cost is added", () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;
    var transport = Stand.empty();
    transport.type = StandType.vehicle;

    var unit = Unit(id: 1, name: "", stand: stand, transport: transport);
    unit.size = 8;
    unit.transportSize = 4;

    // When
    var cost = unit.cost();

    // Then
    expect(cost, equals(20));
  });

  test("Smaller units are 10% more expensive", () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;

    var unit = Unit(id: 1, name: "", stand: stand);
    unit.size = 5;

    // When
    var cost = unit.cost();

    // Then
    expect(cost, equals(10));
  });
  test("Independent infantry stand adds 30%", () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;

    var unit = Unit(id: 1, name: "", stand: stand);
    unit.size = 1;

    // When
    var cost = unit.cost();

    // Then
    expect(cost, equals(5));
  });

  test("Example from book", () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.speed = 12;
    stand.movement = MovementType.tracked;
    stand.aim = 4;
    stand.traits = ["Tank Hunters"];
    stand.assault = 0;
    stand.save = 5;
    stand.morale = 4;
    stand.primaries = [EmptyWeapon()];
    expect(stand.cost(), 2 * 12); // Differs from the book

    var weapon = Weapon.empty();
    weapon.range = 30;
    weapon.impact = 6;
    weapon.type = WeaponType.at;
    expect(weapon.cost(), 17); // Matches the book

    stand.primaries = [weapon];
    expect(stand.cost(), 58); // Differs from the book

    var unit = Unit(id: 1, name: "", stand: stand);
    unit.size = 3;

    // When
    var cost = unit.cost();

    // Then
    expect(cost, equals(175)); // Differs from the book
  });
}
