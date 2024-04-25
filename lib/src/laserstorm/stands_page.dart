import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/template_page.dart';
import '../app_states.dart';
import 'add_edit_stand_dialog.dart';
import 'stand.dart';
import 'common_widgets.dart';

class StandsPage extends StatelessWidget {
  static const String routeName = "/laserstorm/stands/";

  const StandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return TemplatePage<Stand>(
      onAdd: () => Navigator.pushNamed(
        context,
        AddStandPage.routeName,
        arguments: null,
      ),
      onEdit: (stand) => Navigator.pushNamed(
        context,
        EditStandPage.routeName,
        arguments: StandId(stand.id),
      ),
      onDuplicate: (stand) => appState.duplicateStand(stand),
      onDelete: (stand) => appState.removeStand(stand.id),
      getItem: (index) => appState.stands[index],
      templateName: "Stand",
      itemCount: appState.stands.length,
      leadingBuilder: (stand) {
        return TypeData(
          tooltip: stand.type.toString(), // iconTooltip,
          icon: switch (stand.type) {
            StandType.infantry => Icons.person,
            _ => Icons.car_crash,
          },
        );
      },
      statBuilder: (stand) => [
        StatDisplay(
          stat: "Save",
          value: stand.save.toString(),
        ),
        StatDisplay(
          stat: "Speed",
          value: stand.speed.toString(),
        ),
        StatDisplay(
          stat: "Aim",
          value: stand.aim.toString(),
        ),
        StatDisplay(
          stat: "Assault",
          value: stand.assault.toString(),
        ),
        StatDisplay(
          stat: "Morale",
          value: stand.morale.toString(),
        ),
        Visibility(
          visible: stand.traits.isNotEmpty,
          child: StatDisplay(
            stat: "Traits",
            value: stand.traits.join(", "),
          ),
        ),
      ],
    );
  }
}
