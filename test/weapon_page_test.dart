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
    final weapon = Weapon(
        id: 10,
        name: "FooBar",
        type: WeaponType.gp,
        range: 10,
        shots: 2,
        impact: 5,
        traits: []);
    final state = AppState()..setWeapon(weapon);
    const widget = WeaponsPage();

    // When
    await tester.pumpWidget(makeTestableWidget(child: widget, state: state));

    // Then
    expect(find.text("FooBar"), findsOneWidget);
  }, skip: true);

  testWidgets('Item shows range', (WidgetTester tester) async {
    // Given
    final weapon = Weapon(id: 10, name: "FooBar", type: WeaponType.gp);
    final state = AppState()..setWeapon(weapon);
    const widget = WeaponsPage();

    // When
    await tester.pumpWidget(makeTestableWidget(child: widget, state: state));

    // Then
    final finder = find.widgetWithText(StatDisplay, weapon.range.toString());
    expect(finder, findsAtLeastNWidgets(2));
  }, skip: true);
}
