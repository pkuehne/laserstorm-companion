import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/template_page.dart';
import '../app_states.dart';
import 'add_edit_weapon_dialog.dart';
import 'weapon.dart';
import 'common_widgets.dart';

class WeaponsPage extends StatelessWidget {
  static const String routeName = "/laserstorm/weapons/";

  const WeaponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return TemplatePage<Weapon>(
      onAdd: () => Navigator.pushNamed(
        context,
        AddWeaponPage.routeName,
        arguments: null,
      ),
      onEdit: (weapon) => Navigator.pushNamed(
        context,
        EditWeaponPage.routeName,
        arguments: WeaponId(weapon.id),
      ),
      onDuplicate: (weapon) => appState.duplicateWeapon(weapon),
      onDelete: (weapon) => appState.removeWeapon(weapon.id),
      getItem: (index) => appState.weapons[index],
      templateName: "Weapon",
      itemCount: appState.weapons.length,
      leadingBuilder: (Weapon weapon) {
        return switch (weapon.type) {
          WeaponType.ai =>
            TypeData(icon: Icons.person, tooltip: "Anti-Infantry"),
          WeaponType.gp =>
            TypeData(icon: Icons.all_out, tooltip: "General Purpose"),
          WeaponType.at =>
            TypeData(icon: Icons.car_crash, tooltip: "Anti-Tank"),
        };
      },
      statBuilder: (weapon) => [
        StatDisplay(
          stat: "Range",
          value: weapon.range.toString(),
        ),
        StatDisplay(
          stat: "Impact",
          value: weapon.impact.toString(),
        ),
        StatDisplay(
          stat: "Shots",
          value: weapon.shots.toString(),
        ),
        Visibility(
          visible: weapon.traits.isNotEmpty,
          child: StatDisplay(
            stat: "Traits",
            value: weapon.traits.join(", "),
          ),
        ),
      ],
    );
  }
}
