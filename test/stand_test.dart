import 'package:flutter_test/flutter_test.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/weapon.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Weapon>()])
import 'stand_test.mocks.dart';

void main() {
  test('Speed of 4 is free', () {
    // Given
    var stand = Stand.empty();

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(0));
  });

  test('8 extra point of speed cost 2', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.speed = 12;

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(2));
  });

  test('Speed of 8 is free for cav', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.cavalry;
    stand.speed = 8;

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(0));
  });

  test('Speed of 8 is free for aircraft', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.aircraft;
    stand.speed = 8;

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(0));
  });

  test('Walkers cost 2 more for movement', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.type = StandType.scout;
    stand.movement = MovementType.walker;

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(3));
  });

  test('Grav cost 4 more for movement', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.type = StandType.scout;
    stand.movement = MovementType.grav;

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(5));
  });

  test('Grav cost 4 more but 1 less with minimum move distance', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.type = StandType.scout;
    stand.movement = MovementType.grav;
    stand.hasMinimumMove = true;

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(4));
  });

  test('Move Out trait costs 1 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.traits = ["Move Out"];

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(2));
  });

  test('Dogfighter trait costs 1 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.traits = ["Dogfighter"];

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(2));
  });

  test('Jump Troops trait costs 0.5 more', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 8;
    stand.traits = ["Jump Troops"];

    // When
    var cost = stand.speedCost();

    // Then
    expect(cost, equals(1.5));
  });

  test('Transport capacity of 0 is free', () {
    // Given
    var stand = Stand.empty();
    stand.transports = 0;

    // When
    var cost = stand.transportCost();

    // Then
    expect(cost, equals(0));
  });

  test('Transport capacity is 1.5 per stand', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 4;
    stand.transports = 2;

    // When
    var cost = stand.transportCost();

    // Then
    expect(cost, equals(3));
  });

  test('Gun-Only can transport 1 for 1 point', () {
    // Given
    var stand = Stand.empty();
    stand.speed = 4;
    stand.transports = 1;
    stand.traits = ["Gun Only"];

    // When
    var cost = stand.transportCost();

    // Then
    expect(cost, equals(1));
  });

  test('Weapon slots are free for aim 5+', () {
    // Given
    var stand = Stand.empty();
    var weapon = Weapon.empty();
    stand.aim = 5;
    stand.primaries = [weapon, weapon];

    // When
    var cost = stand.aimCost();

    // Then
    expect(cost, equals(0));
  });

  test('Weapon slot is 4 for aim 3+', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.aim = 3;
    var weapon = Weapon.empty();
    stand.primaries = [weapon];

    // When
    var cost = stand.aimCost();

    // Then
    expect(cost, equals(4));
  });

  test('Primary weapon slot is 8 for aim 3+ and two weapons', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.aim = 3;
    var weapon = Weapon.empty();
    stand.primaries = [weapon, weapon];

    // When
    var cost = stand.aimCost();

    // Then
    expect(cost, equals(8));
  });

  test('Primary weapon slot is +2*2 for aim 3+ and two weapons for infantry',
      () {
    // Given
    var stand = Stand.empty();
    stand.aim = 3;
    stand.type = StandType.infantry;
    var weapon = Weapon.empty();
    stand.primaries = [weapon, weapon];

    // When
    var cost = stand.aimCost();

    // Then
    expect(cost, equals(4));
  });

  test('Tank Hunter trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 4;
    var weapon = Weapon.empty();
    stand.primaries = [weapon];
    stand.traits = ["Tank Hunters"];

    // When
    var cost = stand.aimCost();

    // Then
    expect(cost, equals(2));
  });

  test('Precise Fire trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 4;
    var weapon = Weapon.empty();
    stand.primaries = [weapon];
    stand.traits = ["Precise Fire"];

    // When
    var cost = stand.aimCost();

    // Then
    expect(cost, equals(2));
  });

  test('Assault of 0 is free', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 0;

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(0));
  });

  test('Assault of 3 adds 1.5', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 3;

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(1.5));
  });

  test('Assault of more than 3 adds extra 1', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 4;

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(3));
  });

  test('Charge trait adds 0.5', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Charge"];

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(1.5));
  });

  test('Melee Weapons trait adds 0.5', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Melee Weapons"];

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(1.5));
  });

  test('Guard trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Guard"];

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(2));
  });

  test('Infest trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.assault = 2;
    stand.traits = ["Infest"];

    // When
    var cost = stand.assaultCost();

    // Then
    expect(cost, equals(2));
  });

  test('Infantry cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.infantry;
    stand.save = 4;

    // When
    var cost = stand.saveCost();

    // Then
    expect(cost, equals(2));
  });
  test('Vehicle cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.vehicle;
    stand.save = 4;

    // When
    var cost = stand.saveCost();

    // Then
    expect(cost, equals(6));
  });
  test('Super Heavy cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.superHeavy;
    stand.save = 16;

    // When
    var cost = stand.saveCost();

    // Then
    expect(cost, equals(2));
  });
  test('Behemoth cost 1 point per lower save', () {
    // Given
    var stand = Stand.empty();
    stand.type = StandType.behemoth;
    stand.save = 22;

    // When
    var cost = stand.saveCost();

    // Then
    expect(cost, equals(2));
  });

  test('Stealth trait adds 2', () {
    // Given
    var stand = Stand.empty();
    stand.traits = ["Stealth"];

    // When
    var cost = stand.saveCost();

    // Then
    expect(cost, equals(2));
  });

  test('Active Defences trait adds 3', () {
    // Given
    var stand = Stand.empty();
    stand.traits = ["Active Defences"];

    // When
    var cost = stand.saveCost();

    // Then
    expect(cost, equals(3));
  });

  test('Morale of 4 adds 2', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 4;

    // When
    var cost = stand.moraleCost();

    // Then
    expect(cost, equals(2));
  });
  test('Morale of 3 adds 4', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 3;

    // When
    var cost = stand.moraleCost();

    // Then
    expect(cost, equals(4));
  });

  test('Tactical Deployment trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Tactical Deployment"];

    // When
    var cost = stand.moraleCost();

    // Then
    expect(cost, equals(2));
  });

  test('Inspiration trait adds 3', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Inspiration"];

    // When
    var cost = stand.moraleCost();

    // Then
    expect(cost, equals(4));
  });

  test('Stubborn trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Stubborn"];

    // When
    var cost = stand.moraleCost();

    // Then
    expect(cost, equals(2));
  });
  test('Horde trait adds 1', () {
    // Given
    var stand = Stand.empty();
    stand.morale = 5; // Adds 1 point
    stand.traits = ["Horde"];

    // When
    var cost = stand.moraleCost();

    // Then
    expect(cost, equals(2));
  });

  test('Third Fate trait adds 3', () {
    // Given
    var stand = Stand.empty();
    stand.traits = ["Third Fate"];

    // When
    var cost = stand.otherCost();

    // Then
    expect(cost, equals(3));
  });

  test('Primary weapons cost full-price', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 4;
    var weapon = MockWeapon();
    when(weapon.cost()).thenReturn(20.0);
    stand.primaries = [weapon, weapon];

    // When
    var cost = stand.weaponCost();

    // Then
    expect(cost, equals(40));
  });

  test('Secondary weapons cost 20% less', () {
    // Given
    var stand = Stand.empty();
    stand.aim = 4;
    var weapon = MockWeapon();
    when(weapon.cost()).thenReturn(20.0);
    stand.secondaries = [weapon];

    // When
    var cost = stand.weaponCost();

    // Then
    expect(cost, equals(16));
  });

  test('Empty stand costs 1', () {
    // Given
    var stand = Stand.empty();

    // When
    var cost = stand.cost();

    // Then
    expect(cost, equals(1));
  });
}
