import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'weapons_page.dart';
import 'stands_page.dart';

class Page<T> {
  String title;
  FloatingActionButton? button;
  final T Function() creator;

  Page(this.title, this.creator, [this.button]);
  T build() => creator();
}

class LaserStormHomePage extends StatefulWidget {
  const LaserStormHomePage({super.key});

  @override
  State<LaserStormHomePage> createState() => _LaserStormHomePageState();
}

class _LaserStormHomePageState extends State<LaserStormHomePage> {
  int currentPage = 0;
  List<Page> pages = [
    Page("Counter", CounterPage.new),
    Page("Weapons", WeaponsPage.new),
    Page("Stands", StandsPage.new),
    Page("Units", Placeholder.new),
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
    var appState = context.watch<AppState>();

    return LayoutBuilder(builder: (_, constraints) {
      var actionButtons = [
        FloatingActionButton(
          onPressed: appState.incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: () => showAddEditWeaponDialog(context),
          tooltip: 'Add Weapon',
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

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have clicked the button ${context.watch<AppState>().counter} times',
          ),
        ],
      ),
    );
  }
}
