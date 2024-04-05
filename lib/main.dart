import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app_states.dart';
import 'src/laserstorm/laser_storm_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        home: const LaserStormHomePage(),
      ),
    );
  }
}
