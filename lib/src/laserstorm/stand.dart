import 'weapon.dart';

enum StandType {
  infantry,
  cavalry,
  lightVehicle,
  fieldGun,
  vehicle,
  superHeavy,
  behemoth;

  @override
  String toString() {
    return switch (this) {
      StandType.infantry => "Infantry",
      StandType.cavalry => "Cavalry",
      StandType.lightVehicle => "Light Vehicle",
      StandType.fieldGun => "Field Gun",
      StandType.vehicle => "Vehicle",
      StandType.superHeavy => "Super Heavy",
      StandType.behemoth => "Behemoth",
    };
  }
}

enum MovementType {
  wheel,
  walker,
  tracked,
  grav;

  @override
  String toString() {
    return switch (this) {
      MovementType.wheel => "Wheeled",
      MovementType.walker => "Walker",
      MovementType.tracked => "Tracked",
      MovementType.grav => "Anti-Grav",
    };
  }
}

enum WeaponSlotType {
  primary,
  secondary,
}

class WeaponSlot {
  Weapon weapon;
  WeaponSlotType type;

  WeaponSlot({required this.weapon, this.type = WeaponSlotType.primary});
}

class Stand {
  int id = 0;
  String name = "";
  StandType type = StandType.infantry;
  MovementType movement = MovementType.wheel;
  bool hasMinimumMove = false;
  int speed = 4;
  int transports = 0;
  int aim = 5;
  int assault = 0;
  int save = 24;
  int morale = 6;
  List<WeaponSlot> slots = [];
  List<String> traits = [];

  Stand.empty();
  Stand(this.id, this.name, this.type, this.speed, this.transports, this.aim,
      this.assault, this.save, this.morale, this.slots, this.traits);
  double cost() {
    double cost = 0.0;

    // Speed costs
    double speedCost = 0.0;
    if (speed > 4) {
      int freeSpeed = 4;
      if (speed > 8 && type == StandType.cavalry) {
        freeSpeed = 8;
      }
      speedCost = (speed - freeSpeed) * .25;
    }
    if (movement == MovementType.walker) {
      speedCost += 2;
    }
    if (movement == MovementType.grav) {
      speedCost += 4;
      if (hasMinimumMove) {
        speedCost -= 1;
      }
    }
    if (traits.contains("Move Out")) {
      speedCost += 0.5;
    }
    if (traits.contains("Scouts")) {
      speedCost += 1;
    }
    if (traits.contains("Jump Troops")) {
      speedCost += 1;
    }
    cost += speedCost;

    // Transport costs
    double transportCosts = 0.0;
    if (transports == 1 && traits.contains("Gun Only")) {
      transportCosts = 1;
    } else {
      transportCosts = transports * 1.5;
    }
    cost += transportCosts;

    // Aim costs
    double aimCost = 0.0;
    if (aim < 5) {
      double costModifier = type == StandType.infantry ? 1.0 : 2.0;
      aimCost = (5 - aim) * costModifier * slots.length;
    }

    // Weapon costs
    for (var slot in slots) {
      var weapon = slot.weapon;
      if (weapon.save <= -4 && weapon.range > 10) {
        aimCost += 4;
      }
      aimCost +=
          weapon.cost() * (slot.type == WeaponSlotType.primary ? 1.0 : 0.8);
    }

    if (traits.contains("Tank Hunters")) {
      aimCost += 1;
    }
    if (traits.contains("Precise Fire")) {
      aimCost += 1;
    }
    cost += aimCost;

    // Assault costs
    double assaultCost = assault * 0.5;
    if (assault > 3) {
      assaultCost += 1;
    }
    if (traits.contains("Charge")) {
      assaultCost += 0.5;
    }
    if (traits.contains("Melee Weapons")) {
      assaultCost += 0.5;
    }
    if (traits.contains("Guard")) {
      assaultCost += 1;
    }
    if (traits.contains("Infest")) {
      assaultCost += 1;
    }
    cost += assaultCost;

    // Save costs
    double saveCosts = 0.0;
    int baseSave = 6;
    if (type == StandType.vehicle) {
      baseSave = 10;
    }
    if (type == StandType.superHeavy) {
      baseSave = 18;
    }
    if (type == StandType.behemoth) {
      baseSave = 24;
    }
    if (save < baseSave) {
      saveCosts = (baseSave - save) * 1.0;
    }
    if (traits.contains("Stealth")) {
      saveCosts += 2;
    }
    if (traits.contains("Active Defences")) {
      saveCosts += 3;
    }
    cost += saveCosts;

    // Morale costs
    double moraleCosts = (6 - morale) * 1.0;
    if (morale < 4) {
      moraleCosts += 1;
    }
    if (traits.contains("Tactical Deployment")) {
      moraleCosts += 1;
    }
    if (traits.contains("Inspiration")) {
      moraleCosts += 3;
    }
    if (traits.contains("Stubborn")) {
      moraleCosts += 1;
    }
    if (traits.contains("Horde")) {
      moraleCosts += 1;
    }

    cost += moraleCosts;

    if (cost < 1) {
      cost = 1;
    }
    if (type == StandType.vehicle) {
      cost *= 2;
    }
    if (type == StandType.superHeavy) {
      cost *= 3;
    }
    if (type == StandType.behemoth) {
      cost *= 4;
    }
    return cost.roundToDouble();
  }
}
