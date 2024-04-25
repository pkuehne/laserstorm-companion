import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/add_edit_unit_page.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
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
    appState.removeUnit(unit.id);
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
              itemCount: appState.units.length,
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
                      trailing: MenuAnchor(
                        builder: (BuildContext _, MenuController controller,
                            Widget? child) {
                          return IconButton(
                            onPressed: controller.open,
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Show menu',
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.edit),
                            onPressed: () => onPressedEdit(context, index),
                            child: const Text("Edit"),
                          ),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.copy),
                            onPressed: () => {appState.duplicateUnit(unit)},
                            child: const Text("Duplicate"),
                          ),
                          const Divider(),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.delete),
                            onPressed: () => {appState.removeUnit(unit.id)},
                            child: const Text("Delete"),
                          )
                        ],
                      ),
                      title: TileTitle(
                        title: unit.name,
                        cost: unit.cost().toInt().toString(),
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
