import 'package:weasel/src/laserstorm/template.dart';

import 'stand.dart';

class Unit extends Template {
  Stand stand;
  int size = 1;
  Stand? transport;
  int transportSize = 0;
  bool command = false;
  bool hero = false;

  Unit({
    super.id = 0,
    super.name = "",
    required this.stand,
    this.transport,
    this.size = 1,
    this.transportSize = 0,
    this.command = false,
    this.hero = false,
  });
  Unit.empty()
      : stand = Stand.empty(),
        super(name: "");
  Unit.clone(Unit original)
      : this(
            id: original.id,
            name: original.name,
            stand: original.stand,
            size: original.size,
            transport: original.transport,
            transportSize: original.transportSize,
            command: original.command,
            hero: original.hero);

  @override
  double cost() {
    double cost = stand.cost() * size;
    if (transport != null) {
      cost += transport!.cost() * transportSize;
    }

    if (size > 1) {
      if (stand.type == StandType.infantry && size < 6) {
        cost *= 1.1;
      }
      if (stand.type == StandType.cavalry && size < 4) {
        cost *= 1.1;
      }
      if (stand.type == StandType.scout && size < 4) {
        cost *= 1.1;
      }
      if (stand.type == StandType.fieldGun && size < 3) {
        cost *= 1.1;
      }
      if (stand.type == StandType.vehicle && size < 3) {
        cost *= 1.1;
      }
    } else {
      double independentCost = 1.0;
      if (stand.type != StandType.superHeavy &&
          stand.type != StandType.behemoth) {
        // Independent stand
        independentCost += 0.3;
        if (command) {
          independentCost += 0.2;
        }
      } else {
        independentCost += 0.2;
      }
      if (hero) {
        independentCost += 0.25;
      }
      cost *= independentCost;
    }

    cost += 0.4; // Always round up
    cost = cost.roundToDouble();

    // Round to nearest 5
    while (cost % 5 > 0) {
      cost += 1;
    }
    return cost;
  }
}
