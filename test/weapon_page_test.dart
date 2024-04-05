// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/app_states.dart';
import 'package:weasel/src/laserstorm/weapon.dart';
import 'package:weasel/src/laserstorm/weapons_page.dart';
import 'package:weasel/src/laserstorm/common_widgets.dart';

Widget makeTestableWidget({required child, AppState? state}) => MaterialApp(
      home: ChangeNotifierProvider<AppState>(
        create: (_) => state ?? AppState(),
        child: Scaffold(
          body: child,
        ),
      ),
    );

void main() {
  testWidgets('Item shows weapon name', (WidgetTester tester) async {
    // Given
    final weapon = Weapon(10, "FooBar", WeaponType.gp, 10, 2, -5, []);
    final state = AppState()..setWeapon(weapon);
    const widget = WeaponsPage();

    // When
    await tester.pumpWidget(makeTestableWidget(child: widget, state: state));

    // Then
    expect(find.text("FooBar"), findsOneWidget);
  });

  testWidgets('Item shows range', (WidgetTester tester) async {
    // Given
    final weapon = Weapon(10, "FooBar", WeaponType.gp, 10, 2, -5, []);
    final state = AppState()..setWeapon(weapon);
    const widget = WeaponsPage();

    // When
    await tester.pumpWidget(makeTestableWidget(child: widget, state: state));

    // Then
    final finder = find.widgetWithText(StatDisplay, weapon.range.toString());
    expect(finder, findsAtLeastNWidgets(2));
  });
}
