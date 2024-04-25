import 'package:flutter_test/flutter_test.dart';
import 'package:weasel/src/app_states.dart';
import 'package:weasel/src/laserstorm/weapon.dart';

void main() {
  group("setWeapon", () {
    test("creates id if 0", () {
      // Given
      var w = Weapon.empty();
      var state = AppState(initialize: false);

      // When
      state.setWeapon(w);

      // Then
      expect(w.id, isNot(equals(0)));
    });
    test("doesn't create id if non-zero", () {
      // Given
      var w = Weapon.empty();
      w.id = 1234;
      var state = AppState(initialize: false);

      // When
      state.setWeapon(w);

      // Then
      expect(w.id, equals(1234));
    });

    test("Duplicate weapon creates two", () {
      // Given
      var state = AppState(initialize: false);
      var w = Weapon(name: "Foo");
      w.id = 1234;
      state.setWeapon(w);

      // When
      state.duplicateWeapon(w);

      // Then
      expect(w.id, equals(1234));
      expect(state.weapons.length, equals(2));
    });
  });
}
