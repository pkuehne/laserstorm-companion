import 'package:weasel/src/laserstorm/item.dart';

enum WeaponType {
  gp,
  ai,
  at,
}

class Weapon extends Item {
  WeaponType type = WeaponType.ai;
  int range = 10;
  int impact = 0;
  int shots = 1;
  List<String> traits = [];

  Weapon.empty() : super(name: "");
  Weapon(
      {super.id = 0,
      super.name = "",
      this.type = WeaponType.ai,
      this.range = 10,
      this.shots = 1,
      this.impact = 0,
      this.traits = const []});
  Weapon.clone(Weapon o)
      : this(
            id: o.id,
            name: o.name,
            type: o.type,
            range: o.range,
            shots: o.shots,
            impact: o.impact,
            traits: o.traits);

  double rangeCost() {
    double cost = 0.0;
    if (range == 20) {
      cost += 2;
    } else if (range == 30) {
      cost += 5;
    } else if (range == 40) {
      cost += 10;
    } else if (range == 50) {
      cost += 20;
    }
    if (traits.contains("Anti-Aircraft")) {
      cost += 1;
    }
    if (traits.contains("Heavy")) {
      cost -= 1;
    }
    if (traits.contains("Indirect")) {
      cost += 3;
    }
    return cost;
  }

  double impactCost() {
    double cost = 0.0;
    cost = impact * 2;
    if (impact > 6) {
      cost += 2;
    }
    if (impact > 10) {
      cost += 5;
    }
    if (traits.contains("Frag")) {
      cost *= 0.75;
    }
    if (traits.contains("Burst")) {
      cost += (4 + impact);
    }
    if (traits.contains("Flame")) {
      cost += 6;
    }

    return cost;
  }

  double shotsCost() {
    double cost = 0.0;
    cost = (rangeCost() + impactCost()) * .5 * (shots - 1);
    if (traits.contains("AI Guided")) {
      cost += 0.5 * shots;
    }
    if (traits.contains("Repeating Fire")) {
      cost += 0.5 * shots;
    }

    return cost;
  }

  @override
  double cost() {
    double cost = 0.0;
    cost += rangeCost();
    cost += impactCost();
    cost += shotsCost();

    if (type == WeaponType.gp) {
      cost *= 1.5;
    }

    if (cost < shots) {
      cost = shots * 1.0;
    }

    return cost;
  }
}

class EmptyWeapon extends Weapon {
  EmptyWeapon() : super.empty();

  @override
  double cost() {
    return 0.0;
  }
}
