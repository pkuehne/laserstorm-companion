import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import '../app_states.dart';
import 'add_edit_stand_dialog.dart';
import 'stand.dart';
import 'common_widgets.dart';

class StandsPage extends StatelessWidget {
  static const String routeName = "/laserstorm/stands/";

  const StandsPage({super.key});

  /// Edit an existing Stand using the same dialog as the Add
  void onPressedEdit(BuildContext context, int index) {
    var appState = Provider.of<AppState>(context, listen: false);
    var stand = appState.stands[index];
    Navigator.pushNamed(
      context,
      EditStandPage.routeName,
      arguments: StandId(stand.id),
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

    return LaserStormScaffold(
      title: "Stands",
      addButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          AddStandPage.routeName,
          arguments: null,
        ),
        tooltip: 'Add Stand',
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: appState.stands.length,
              itemBuilder: (BuildContext _, int index) {
                final stand = appState.stands[index];
                final icon = switch (stand.type) {
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
                        message: stand.type.toString(), // iconTooltip,
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
