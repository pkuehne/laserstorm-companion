import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'add_edit_weapon_dialog.dart';
import 'weapon.dart';
import 'common_widgets.dart';

void showAddEditWeaponDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) => const AlertDialog(
      title: Text("Create new Weapon"),
      content: AddEditWeaponDialog(id: 0),
    ),
  );
}

class WeaponsPage extends StatelessWidget {
  const WeaponsPage({super.key});

  /// Edit an existing Weapon using the same dialog as the Add
  void onPressedEdit(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var weapon = appState.weapons[index];

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (BuildContext _, __, ___) => AlertDialog(
        title: const Text("Edit Weapon"),
        content: AddEditWeaponDialog(id: weapon.id),
      ),
    );
  }

  void onPressedDelete(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var weapon = appState.weapons[index];
    appState.removeWeapon(weapon.id);
  }

  ({IconData data, String tooltip}) getIcon(Weapon weapon) {
    return switch (weapon.type) {
      WeaponType.ai => (data: Icons.person, tooltip: "Anti-Infantry"),
      WeaponType.gp => (data: Icons.all_out, tooltip: "General Purpose"),
      WeaponType.at => (data: Icons.car_crash, tooltip: "Anti-Tank"),
    };
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ListView.builder(
        itemCount: appState.weaponCount(),
        itemBuilder: (BuildContext _, int index) {
          final weapon = appState.weapons[index];
          final mainIcon = getIcon(weapon);
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () => onPressedEdit(context, index),
            leading: Tooltip(
              message: mainIcon.tooltip,
              child: Icon(mainIcon.data),
            ),
            title: Row(
              children: [
                Text(
                  weapon.name,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("(${weapon.cost().toInt().toString()} pts)"),
              ],
            ),
            subtitle: Visibility(
              visible: MediaQuery.of(context).size.width > 350,
              child: Row(
                children: [
                  StatDisplay(
                      stat: "Range",
                      value: weapon.range.toString(),
                      icon: Icons.social_distance),
                  StatDisplay(
                      stat: "Save",
                      value: weapon.save.toString(),
                      icon: Icons.healing),
                  StatDisplay(
                      stat: "Shots",
                      value: weapon.shots.toString(),
                      icon: Icons.multiple_stop),
                  Visibility(
                    visible: weapon.traits.isNotEmpty,
                    child: StatDisplay(
                        stat: "Traits",
                        value: weapon.traits.join(", "),
                        icon: Icons.list),
                  ),
                ],
              ),
            ),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //   onPressed: () => onPressedEdit(context, index),
                //   icon: const Icon(Icons.edit),
                //   tooltip: "Edit",
                // ),
                // IconButton(
                //   onPressed: () => onPressedDelete(context, index),
                //   icon: const Icon(Icons.delete),
                //   tooltip: "Delete",
                // ),
              ],
            ),
          );
        });
  }
}
