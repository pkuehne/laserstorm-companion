import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/add_edit_unit_page.dart';
import 'package:weasel/src/laserstorm/stands_page.dart';
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
        initialRoute: "/LaserStorm/Weapons/",
        routes: {
          '/LaserStorm/Weapons/': (context) => const WeaponsPage(),
          '/LaserStorm/Stands/': (context) => const StandsPage(),
          UnitsPage.routeName: (context) => const UnitsPage(),
          AddUnitPage.routeName: (context) => const AddUnitPage(),
          EditUnitPage.routeName: (context) => const EditUnitPage(),
          '/': (context) => const Placeholder(),
        },
      ),
    );
  }
}
