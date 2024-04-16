import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/add_edit_unit_page.dart';
import 'package:weasel/src/laserstorm/laser_storm_home_page.dart';
import '../app_states.dart';
import 'stand.dart';
import 'common_widgets.dart';

class UnitsPage extends StatelessWidget {
  const UnitsPage({super.key});

  static const String routeName = "/laserstorm/units/";

  /// Edit an existing Unit
  void onPressedEdit(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var unit = appState.units[index];

    Navigator.pushNamed(
      context,
      EditUnitPage.routeName,
      arguments: UnitId(unit.id),
    );
  }

  void onPressedDelete(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var unit = appState.units[index]; // Todo: Delete Unit
    appState.removeStand(unit.id);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return LaserStormScaffold(
      title: "Units",
      addButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          AddUnitPage.routeName,
          arguments: null,
        ),
        tooltip: 'Add Unit',
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: appState.units.length, // Todo: Units
              itemBuilder: (BuildContext _, int index) {
                final unit = appState.units[index];
                final icon = switch (unit.stand.type) {
                  StandType.infantry => Icons.person,
                  _ => Icons.car_crash,
                };
                return Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size(400, double.infinity)),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      onTap: () => onPressedEdit(context, index),
                      leading: Tooltip(
                        message: unit.stand.type.toString(), // iconTooltip,
                        child: Icon(icon),
                      ),
                      trailing: const Icon(Icons.more_vert),
                      title: Row(
                        children: [
                          Text(unit.name),
                          StatDisplay(
                              stat: "Cost",
                              value: unit.cost().toInt().toString(),
                              icon: Icons.attach_money),
                        ],
                      ),
                      subtitle: Visibility(
                        visible: MediaQuery.of(context).size.width > 350,
                        child: Row(
                          children: [
                            StatDisplay(
                                stat: "Unit",
                                value: "${unit.stand.name} x${unit.size}",
                                icon: Icons.keyboard_double_arrow_up),
                            Visibility(
                              visible: unit.stand.transports > 0,
                              child: StatDisplay(
                                  stat: "Transports",
                                  value: unit.transport?.name ?? "",
                                  icon: Icons.train),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
