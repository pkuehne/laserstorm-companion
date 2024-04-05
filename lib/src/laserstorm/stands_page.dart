import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'add_edit_stand_dialog.dart';
import 'stand.dart';
import 'common_widgets.dart';

void showAddEditStandDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) => const AlertDialog(
      title: Text("Create new Stand"),
      content: AddEditStandDialog(id: 0),
    ),
  );
}

class StandsPage extends StatelessWidget {
  const StandsPage({super.key});

  /// Edit an existing Weapon using the same dialog as the Add
  void onPressedEdit(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var stand = appState.stands[index];

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext _, __, ___) => AlertDialog(
        title: const Text("Edit Stand"),
        content: AddEditStandDialog(id: stand.id),
      ),
    );
  }

  void onPressedDelete(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var stand = appState.stands[index];
    appState.removeStand(stand.id);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ListView.builder(
        itemCount: appState.stands.length,
        itemBuilder: (BuildContext _, int index) {
          final stand = appState.stands[index];
          final icon = switch (stand.type) {
            StandType.infantry => Icons.person,
            _ => Icons.car_crash,
          };
          final iconTooltip = switch (stand.type) {
            StandType.infantry => "Infantry",
            StandType.cavalry => "Cavalry",
            StandType.lightVehicle => "Light Vehicle",
            StandType.fieldGun => "Field Gun",
            StandType.vehicle => "Vehicle",
            StandType.superHeavy => "Super Heavy",
            StandType.behemoth => "Behemoth",
          };
          return ListTile(
            leading: Tooltip(
              message: iconTooltip,
              child: Icon(icon),
            ),
            title: Row(
              children: [
                Text(stand.name),
                StatDisplay(
                    stat: "Cost",
                    value: stand.cost().toInt().toString(),
                    icon: Icons.attach_money),
              ],
            ),
            subtitle: Visibility(
              visible: MediaQuery.of(context).size.width > 350,
              child: Row(
                children: [
                  StatDisplay(
                      stat: "Save",
                      value: stand.save.toString(),
                      icon: Icons.healing),
                  StatDisplay(
                      stat: "Speed",
                      value: stand.speed.toString(),
                      icon: Icons.speed),
                  StatDisplay(
                      stat: "Aim",
                      value: stand.aim.toString(),
                      icon: Icons.add_box_outlined),
                  StatDisplay(
                      stat: "Assault",
                      value: stand.assault.toString(),
                      icon: Icons.sports_handball),
                  StatDisplay(
                      stat: "Morale",
                      value: stand.morale.toString(),
                      icon: Icons.add_reaction),
                  Visibility(
                    visible: stand.traits.isNotEmpty,
                    child: StatDisplay(
                        stat: "Traits",
                        value: stand.traits.join(", "),
                        icon: Icons.list),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: "Edit",
                  child: IconButton(
                    onPressed: () => onPressedEdit(context, index),
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Tooltip(
                  message: "Delete",
                  child: IconButton(
                    onPressed: () => onPressedDelete(context, index),
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
