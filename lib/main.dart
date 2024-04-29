import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/add_edit_stand_page.dart';
import 'package:weasel/src/laserstorm/add_edit_taskforce_page.dart';
import 'package:weasel/src/laserstorm/add_edit_unit_page.dart';
import 'package:weasel/src/laserstorm/add_edit_weapon_page.dart';
import 'package:weasel/src/laserstorm/stands_page.dart';
import 'package:weasel/src/laserstorm/taskforces_page.dart';
import 'package:weasel/src/laserstorm/units_page.dart';
import 'package:weasel/src/laserstorm/weapons_page.dart';
import 'src/app_states.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Nordic Weasel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: "/laserstorm/weapons/",
        routes: {
          WeaponsPage.routeName: (context) => const WeaponsPage(),
          AddWeaponPage.routeName: (context) => const AddWeaponPage(),
          EditWeaponPage.routeName: (context) => const EditWeaponPage(),
          StandsPage.routeName: (context) => const StandsPage(),
          AddStandPage.routeName: (context) => const AddStandPage(),
          EditStandPage.routeName: (context) => const EditStandPage(),
          UnitsPage.routeName: (context) => const UnitsPage(),
          AddUnitPage.routeName: (context) => const AddUnitPage(),
          EditUnitPage.routeName: (context) => const EditUnitPage(),
          TaskForcesPage.routeName: (context) => const TaskForcesPage(),
          AddTaskForcePage.routeName: (context) => const AddTaskForcePage(),
          EditTaskForcePage.routeName: (context) => const EditTaskForcePage(),
          '/': (context) => const Placeholder(),
        },
      ),
    );
  }
}
