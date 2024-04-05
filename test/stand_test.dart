import 'package:flutter_test/flutter_test.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/weapon.dart';

void main() {
  test('Speed of 4 is free', () {
    // Given
    var stand = Stand.empty();

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(1)); // 1 point per shot
  });

  test('Speed of 8 is free for cav', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.cavalry;
    stand.speed = 8;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(1)); // 1 point per shot
  });

  test('Walkers cost 2 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.movement = MovementType.walker;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(3)); // 1 point per shot
  });

  test('Grav cost 4 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.movement = MovementType.grav;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(5)); // 1 point per shot
  });

  test('Grav cost 4 more but 1 less with minimum move distance', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.movement = MovementType.grav;
    stand.hasMinimumMove = true;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(4)); // 1 point per shot
  });

  test('Move Out trait costs 0.5 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.traits = ["Move Out"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); // Rounded up
  });

  test('Scouts trait costs 1 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.traits = ["Scouts"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); // 1 point per shot
  });

  test('Jump Troops trait costs 1 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.traits = ["Jump Troops"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); // 1 point per shot
  });

  test('Transport capacity is 1.5 per stand', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 4;
    stand.transports = 2;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(3)); // 1 point per shot
  });

  test('Gun-Only can transport 1 for 1 point', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 4;
    stand.transports = 1;
    stand.traits = ["Gun Only"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(1)); // 1 point per shot
  });

  test('Weapon slots are free for aim 5+', () {
    // Given
    var stand = Stand.empty();
    var weapon = Weapon.empty();
    stand.slots = [WeaponSlot(weapon: weapon), WeaponSlot(weapon: weapon)];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); // Weapon costs 1
  });

  test('Weapon slot is 4 for aim 3+', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.aim = 3;
    var weapon = Weapon.empty();
    stand.slots = [WeaponSlot(weapon: weapon)];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(10)); // Weapon costs 1 as well * 2 for vehicle
  });

  test('Primary weapon slot is 8 for aim 3+ and two weapons', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.aim = 3;
    var weapon = Weapon.empty();
    stand.slots = [WeaponSlot(weapon: weapon), WeaponSlot(weapon: weapon)];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(20)); // Weapon costs 1 as well * 20 for vehicle
  });

  test('Primary weapon slot is 6 for aim 3+ and two weapons for infantry', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 3;
    stand.type = StandType.infantry;
    var weapon = Weapon.empty();
    stand.slots = [WeaponSlot(weapon: weapon), WeaponSlot(weapon: weapon)];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(6)); // Weapon costs 1 as well
  });

  test('Weapon with -4 save adds +4', () {
    // Given
    var stand = Stand.empty();
    var weapon = Weapon.empty();
    weapon.save = -4;
    weapon.range = 20;
    stand.slots = [WeaponSlot(weapon: weapon)];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(14)); // Weapon costs 10
  });
  test('Weapon with -4 save and short range does not add _+4', () {
    // Given
    var stand = Stand.empty();
    var weapon = Weapon.empty();
    weapon.save = -4;
    weapon.range = 10;
    stand.slots = [WeaponSlot(weapon: weapon)];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(8)); // Weapon costs 8
  });

  test('Tank Hunter trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 4;
    var weapon = Weapon.empty();
    stand.slots = [WeaponSlot(weapon: weapon)];
    stand.traits = ["Tank Hunters"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(3));
  });

  test('Precise Fire trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 4;
    var weapon = Weapon.empty();
    stand.slots = [WeaponSlot(weapon: weapon)];
    stand.traits = ["Precise Fire"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(3));
  });

  test('Assault of 3 adds 1.5', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 3;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); // Rounding
  });

  test('Assault of more than 3 adds extra 1', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 4;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(3));
  });

  test('Charge trait adds 0.5', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Charge"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); // Rounding
  });

  test('Melee Weapons trait adds 0.5', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Melee Weapons"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2)); //Rounding
  });

  test('Guard trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Guard"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });

  test('Infest trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Infest"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });

  test('Infantry cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;
    stand.save = 4;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });
  test('Vehicle cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.save = 4;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(12));
  });
  test('Super Heavy cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.superHeavy;
    stand.save = 16;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(6));
  });
  test('Behemoth cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.behemoth;
    stand.save = 22;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(8));
  });

  test('Stealth trait adds 2', () {
    // Given
    var stand = Stand.empty();
    stand.traits = ["Stealth"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });

  test('Active Defences trait adds 3', () {
    // Given
    var stand = Stand.empty();
    stand.traits = ["Active Defences"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(3));
  });

  test('Morale of 4 adds 2', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 4;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });
  test('Morale of 3 adds 4', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 3;

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(4));
  });

  test('Tactical Deployment trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Tactical Deployment"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });

  test('Inspiration trait adds 3', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Inspiration"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(4));
  });
  test('Stubborn trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Stubborn"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });
  test('Horde trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Horde"];

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(2));
  });
}
