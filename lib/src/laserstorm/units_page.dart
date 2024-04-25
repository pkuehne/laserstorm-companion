import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/add_edit_unit_page.dart';
import 'package:weasel/src/laserstorm/common_widgets.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/template_page.dart';
import 'package:weasel/src/app_states.dart';
import 'package:weasel/src/laserstorm/unit.dart';

class UnitsPage extends StatelessWidget {
  const UnitsPage({super.key});

  static const String routeName = "/laserstorm/units/";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return TemplatePage<Unit>(
      templateName: "Unit",
      onAdd: () => Navigator.pushNamed(
        context,
        AddUnitPage.routeName,
        arguments: null,
      ),
      onEdit: (unit) => Navigator.pushNamed(
        context,
        EditUnitPage.routeName,
        arguments: UnitId(unit.id),
      ),
      onDuplicate: (unit) => {appState.duplicateUnit(unit)},
      onDelete: (unit) => {appState.removeUnit(unit.id)},
      getItem: (i) => appState.units[i],
      itemCount: appState.units.length,
      leadingBuilder: (Unit unit) {
        return Tooltip(
          message: unit.stand.type.toString(), // iconTooltip,
          child: Icon(
            switch (unit.stand.type) {
              StandType.infantry => Icons.person,
              _ => Icons.car_crash,
            },
          ),
        );
      },
      statBuilder: (Unit unit) {
        return [
          StatDisplay(
              stat: "Stand Type",
              value: "${unit.stand.name} x${unit.size}",
              icon: Icons.keyboard_double_arrow_up),
          Visibility(
            visible: unit.stand.transports > 0,
            child: StatDisplay(
                stat: "Transports",
                value: unit.transport?.name ?? "",
                icon: Icons.train),
          ),
        ];
      },
    );
  }
}
