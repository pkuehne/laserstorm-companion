import 'dart:core';
import 'package:flutter/material.dart';
import 'package:weasel/src/laserstorm/stands_page.dart';
import 'package:weasel/src/laserstorm/units_page.dart';
import 'package:weasel/src/laserstorm/weapons_page.dart';

class DrawerItem {
  String title;
  String route;

  DrawerItem(this.title, this.route);
}

List<DrawerItem> drawers = [
  DrawerItem("Weapons", WeaponsPage.routeName),
  DrawerItem("Stands", StandsPage.routeName),
  DrawerItem("Units", UnitsPage.routeName),
  DrawerItem("Task Forces", "/"),
];

class LaserStormScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? addButton;

  const LaserStormScaffold(
      {super.key, required this.body, required this.title, this.addButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      drawer: addButton == null
          ? null
          : Drawer(
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
                      onTap: () =>
                          Navigator.pushNamed(context, drawers[ii].route),
                    ),
                ],
              ),
            ),
      body: body,
      floatingActionButton: addButton,
    );
  }
}
