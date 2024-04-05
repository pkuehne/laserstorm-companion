enum WeaponType {
  gp,
  ai,
  at,
}

class Weapon {
  int id = 0;
  String name = "";
  WeaponType type = WeaponType.ai;
  int range = 10;
  int save = 0;
  int shots = 1;
  List<String> traits = [];

  Weapon.empty();
  Weapon(this.id, this.name, this.type, this.range, this.shots, this.save,
      this.traits);

  double cost() {
    double cost = 0.0;

    // Range costs
    double rangeCost = 0.0;
    if (range == 20) {
      rangeCost += 2;
    } else if (range == 30) {
      rangeCost += 5;
    } else if (range == 40) {
      rangeCost += 10;
    }
    cost += rangeCost;

    // Traits costs
    if (traits.contains("Heavy")) {
      cost -= 1;
    }
    if (traits.contains("Indirect")) {
      cost += 3;
    }

    // Save costs
    double saveCost = save.abs() * 2;
    if (save < -6) {
      saveCost += 2;
    }
    if (save < -10) {
      saveCost += 5;
    }
    if (traits.contains("Frag")) {
      saveCost *= 0.75;
    }
    cost += saveCost;

    if (traits.contains("Burst")) {
      cost += (4 + save);
    }
    if (traits.contains("Flame")) {
      cost += 6;
    }

    // Shots costs
    double shotsCost = (rangeCost + saveCost) * .5 * (shots - 1);
    cost += shotsCost;

    if (type == WeaponType.gp) {
      cost *= 1.5;
    }

    if (cost < shots) {
      cost = shots * 1.0;
    }

    return cost;
  }
}
