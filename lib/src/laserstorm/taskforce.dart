import 'package:weasel/src/laserstorm/template.dart';

import 'unit.dart';

class TaskForce extends Template {
  String commander;
  String option;
  List<Unit> infantry;
  List<Unit> scout;
  List<Unit> cavalry;
  List<Unit> fieldgun;
  List<Unit> afv;
  List<Unit> superheavy;
  List<Unit> behemoth;
  List<Unit> aircraft;

  TaskForce({
    super.id = 0,
    super.name = "",
    this.commander = "",
    this.option = "",
    this.infantry = const [],
    this.scout = const [],
    this.cavalry = const [],
    this.fieldgun = const [],
    this.afv = const [],
    this.superheavy = const [],
    this.behemoth = const [],
    this.aircraft = const [],
  });

  TaskForce.clone(TaskForce original)
      : this(
          id: original.id,
          name: original.name,
          commander: original.commander,
          option: original.option,
          infantry: original.infantry,
          scout: original.scout,
          cavalry: original.cavalry,
          fieldgun: original.fieldgun,
          afv: original.afv,
          superheavy: original.superheavy,
          behemoth: original.behemoth,
          aircraft: original.aircraft,
        );

  @override
  double cost() {
    double cost = 1.0;
    return cost;
  }
}
