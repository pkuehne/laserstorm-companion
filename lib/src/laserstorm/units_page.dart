import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'add_edit_stand_dialog.dart';
import 'stand.dart';
import 'common_widgets.dart';

void showAddEditUnitDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) => const AlertDialog(
      title: Text("Create new Unit"),
      content: AddEditStandDialog(id: 0),
    ),
  );
}

class UnitsPage extends StatelessWidget {
  const UnitsPage({super.key});

  /// Edit an existing Weapon using the same dialog as the Add
  void onPressedEdit(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var stand = appState.stands[index]; //Todo: Replace with units

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext _, __, ___) => AlertDialog(
        title: const Text("Edit Unit"),
        content: AddEditStandDialog(id: stand.id),
      ),
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

    return ListView.builder(
        itemCount: appState.units.length, // Todo: Units
        itemBuilder: (BuildContext _, int index) {
          final unit = appState.units[index];
          final icon = switch (unit.stand.type) {
            StandType.infantry => Icons.person,
            _ => Icons.car_crash,
          };
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () => onPressedEdit(context, index),
            leading: Tooltip(
              message: unit.stand.type.toString(), // iconTooltip,
              child: Icon(icon),
            ),
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
                      stat: "Save",
                      value: unit.stand.save.toString(),
                      icon: Icons.healing),
                  StatDisplay(
                      stat: "Speed",
                      value: unit.stand.speed.toString(),
                      icon: Icons.speed),
                  StatDisplay(
                      stat: "Aim",
                      value: unit.stand.aim.toString(),
                      icon: Icons.add_box_outlined),
                  StatDisplay(
                      stat: "Assault",
                      value: unit.stand.assault.toString(),
                      icon: Icons.sports_handball),
                  StatDisplay(
                      stat: "Morale",
                      value: unit.stand.morale.toString(),
                      icon: Icons.add_reaction),
                  Visibility(
                    visible: unit.stand.traits.isNotEmpty,
                    child: StatDisplay(
                        stat: "Traits",
                        value: unit.stand.traits.join(", "),
                        icon: Icons.list),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
