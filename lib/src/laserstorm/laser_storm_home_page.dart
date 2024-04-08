import 'dart:core';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/units_page.dart';
// import '../app_states.dart';
import 'weapons_page.dart';
import 'stands_page.dart';

class Page<T> {
  String title;
  FloatingActionButton? button;
  final T Function() creator;

  Page(this.title, this.creator, [this.button]);
  T build() => creator();
}

class DrawerItem {
  String title;
  String route;

  DrawerItem(this.title, this.route);
}

List<DrawerItem> drawers = [
  DrawerItem("Weapons", "/LaserStorm/Weapons/"),
  DrawerItem("Stands", "/LaserStorm/Stands/"),
  DrawerItem("Units", "/LaserStorm/Units/"),
  DrawerItem("Task Forces", "/LaserStorm/TaskForces/"),
];

class LaserStormScaffold extends StatelessWidget {
  final Widget? body;
  final String? title;

  const LaserStormScaffold({super.key, this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title ?? "LaserStorm"),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Laserstorm'),
            ),
            for (int ii = 0; ii < drawers.length; ii++)
              ListTile(
                title: Text(drawers[ii].title),
                onTap: () => "",
              ),
          ],
        ),
      ),
      body: body,
      // floatingActionButton: actionButtons.elementAtOrNull(currentPage),
    );
  }
}

class LaserStormHomePage extends StatefulWidget {
  const LaserStormHomePage({super.key});

  @override
  State<LaserStormHomePage> createState() => _LaserStormHomePageState();
}

class _LaserStormHomePageState extends State<LaserStormHomePage> {
  int currentPage = 0;
  List<Page> pages = [
    Page("Weapons", WeaponsPage.new),
    Page("Stands", StandsPage.new),
    Page("Units", UnitsPage.new),
    Page("Task Forces", Placeholder.new),
  ];

  void drawerOnTap(int index) {
    setState(() {
      currentPage = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<AppState>();

    return LayoutBuilder(builder: (_, constraints) {
      var actionButtons = [
        FloatingActionButton(
          onPressed: () => showAddEditWeaponDialog(context),
          tooltip: 'Add Weapon',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: () => showAddEditStandDialog(context),
          tooltip: 'Add Stand',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: () => showAddEditStandDialog(context),
          tooltip: 'Add Unit',
          child: const Icon(Icons.add),
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(pages[currentPage].title),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Laserstorm'),
              ),
              for (int ii = 0; ii < pages.length; ii++)
                ListTile(
                  title: Text(pages[ii].title),
                  onTap: () => drawerOnTap(ii),
                ),
            ],
          ),
        ),
        body: pages[currentPage].build(),
        floatingActionButton: actionButtons.elementAtOrNull(currentPage),
      );
    });
  }
}
