import 'weapon.dart';

enum StandType {
  infantry,
  cavalry,
  scout,
  fieldGun,
  vehicle,
  aircraft,
  superHeavy,
  behemoth;

  @override
  String toString() {
    return switch (this) {
      StandType.infantry => "Infantry",
      StandType.cavalry => "Cavalry",
      StandType.scout => "Scout",
      StandType.fieldGun => "Field Gun",
      StandType.vehicle => "AFV",
      StandType.aircraft => "Aircraft",
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

// enum WeaponSlotType {
//   primary,
//   secondary,
// }

// class WeaponSlot {
//   Weapon weapon;
//   WeaponSlotType type;

//   WeaponSlot({required this.weapon, this.type = WeaponSlotType.primary});
// }

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
  List<Weapon> primaries = [];
  List<Weapon> secondaries = [];
  List<String> traits = [];

  Stand.empty();
  Stand(
      this.id,
      this.name,
      this.type,
      this.speed,
      this.transports,
      this.aim,
      this.assault,
      this.save,
      this.morale,
      this.primaries,
      this.secondaries,
      this.traits);

  int weaponSlots() {
    return primaries.length + secondaries.length;
  }

  double speedCost() {
    double cost = 0.0;
    if (speed > 4) {
      int freeSpeed = 4;
      if ([StandType.cavalry, StandType.aircraft].contains(type)) {
        freeSpeed = 8;
      }
      cost = (speed - freeSpeed) * .25;
    }
    if (movement == MovementType.walker && type == StandType.scout) {
      cost += 2;
    }
    if (movement == MovementType.grav && type == StandType.scout) {
      cost += 4;
      if (hasMinimumMove) {
        cost -= 1;
      }
    }
    if (traits.contains("Dogfighter")) {
      cost += 1;
    }
    if (traits.contains("Hover")) {
      cost += 2;
    }
    if (traits.contains("Jump Troops")) {
      cost += 0.5;
    }
    if (traits.contains("Minimum Speed")) {
      cost -= 1;
    }
    if (traits.contains("Move Out")) {
      cost += 1;
    }
    if (traits.contains("VTOL")) {
      cost += 1;
    }
    return cost;
  }

  double transportCost() {
    double cost = 0.0;
    if (transports == 1 && traits.contains("Gun Only")) {
      cost = 1;
    } else {
      cost = transports * 1.5;
    }
    return cost;
  }

  double aimCost() {
    double cost = 0.0;
    if (aim < 5) {
      double costModifier = type == StandType.infantry ? 1.0 : 2.0;
      cost = (5 - aim) * costModifier * weaponSlots();
    }

    if (traits.contains("Battletide")) {
      cost += 1;
    }
    if (traits.contains("Bot-Net")) {
      cost += 1;
    }
    if (traits.contains("Precise Fire")) {
      cost += 1;
    }
    if (traits.contains("Tank Hunters")) {
      cost += 1;
    }
    return cost;
  }

  double assaultCost() {
    double cost = assault * 0.5;
    if (assault > 3) {
      cost += 1;
    }
    if (traits.contains("Assault Vehicle")) {
      cost += 1;
    }
    if (traits.contains("Battlecry")) {
      cost += 2;
    }
    if (traits.contains("Charge")) {
      cost += 0.5;
    }
    if (traits.contains("Ferocious")) {
      cost += 1;
    }
    if (traits.contains("Frenzy")) {
      cost += 1;
    }
    if (traits.contains("Glory")) {
      cost += 1;
    }
    if (traits.contains("Guard")) {
      cost += 1;
    }
    if (traits.contains("Infest")) {
      cost += 1;
    }
    if (traits.contains("Melee Weapons")) {
      cost += 0.5;
    }
    if (traits.contains("Terror")) {
      cost += 1;
    }
    return cost;
  }

  double saveCost() {
    double cost = 0.0;
    int baseSave = 6;
    if (type == StandType.vehicle || type == StandType.aircraft) {
      baseSave = 10;
    }
    if (type == StandType.superHeavy) {
      baseSave = 18;
    }
    if (type == StandType.behemoth) {
      baseSave = 24;
    }
    if (save < baseSave) {
      cost = (baseSave - save) * 1.0;
    }
    if (traits.contains("Stealth")) {
      cost += 2;
    }
    if (traits.contains("Active Defences")) {
      cost += 3;
    }
    return cost;
  }

  double moraleCost() {
    double cost = (6 - morale) * 1.0;
    if (morale < 4) {
      cost += 1;
    }
    if (traits.contains("Aggression Loop")) {
      cost += 1;
    }
    if (traits.contains("Horde")) {
      cost += 1;
      if (morale < 4) {
        cost += 2;
      }
    }
    if (traits.contains("Inspiration")) {
      cost += 3;
    }
    if (traits.contains("In The Walls")) {
      cost += 2;
    }
    if (traits.contains("Spawn")) {
      cost += 2;
    }
    if (traits.contains("Stubborn")) {
      cost += 1;
    }
    if (traits.contains("Tactical Deployment")) {
      cost += 1;
    }
    if (traits.contains("Vow-Sworn")) {
      cost += 1;
    }

    return cost;
  }

  double otherCost() {
    double cost = 0.0;
    if (traits.contains("Overclocked")) {
      cost += 1;
    }
    if (traits.contains("Relic Bearer")) {
      cost += 1;
    }
    if (traits.contains("Third Fate")) {
      cost += 3;
    }
    return cost;
  }

  double weaponCost() {
    double cost = 0.0;
    for (var weapon in primaries) {
      cost += weapon.cost();
    }
    for (var weapon in secondaries) {
      cost += weapon.cost() * 0.8;
    }
    return cost;
  }

  double cost() {
    double cost = 0.0;

    cost += speedCost();
    cost += transportCost();
    cost += aimCost();
    cost += assaultCost();
    cost += saveCost();
    cost += moraleCost();
    cost += otherCost();

    if (cost < 1) {
      cost = 1;
    }

    cost += 0.4; // Always round up
    cost = cost.roundToDouble();

    cost += weaponCost();

    if (type == StandType.vehicle || type == StandType.aircraft) {
      cost *= 2;
    }
    if (type == StandType.superHeavy) {
      cost *= 3;
    }
    if (type == StandType.behemoth) {
      cost *= 4;
    }

    cost += 0.4; // Always round up
    return cost.roundToDouble();
  }
}
