import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/common_widgets.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import '../app_states.dart';
import 'weapon.dart';
import 'validators.dart' as validator;

/// Holds weapon id argument for EditUnitPage
class WeaponId {
  final int? id;
  WeaponId(this.id);
}

class AddWeaponPage extends StatelessWidget {
  const AddWeaponPage({super.key});

  static const routeName = '/laserstorm/weapon/add';

  @override
  Widget build(BuildContext context) {
    return WeaponForm(
      weapon: Weapon.empty(),
      title: "Add Weapon",
      snackText: "Added",
    );
  }
}

class EditWeaponPage extends StatelessWidget {
  const EditWeaponPage({super.key});

  static const routeName = '/laserstorm/weapon/edit';

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    final args = ModalRoute.of(context)?.settings.arguments as WeaponId?;
    final id = args?.id;
    if (id == null || !appState.hasWeapon(id)) {
      Navigator.of(context).pop();
    }

    return WeaponForm(
      weapon: Weapon.clone(appState.getWeapon(id!)),
      title: "Edit Unit",
      snackText: "Updated",
    );
  }
}

class WeaponForm extends StatefulWidget {
  final Weapon weapon;
  final String title;
  final String snackText;

  const WeaponForm({
    super.key,
    required this.weapon,
    required this.title,
    required this.snackText,
  });

  @override
  State<WeaponForm> createState() => _WeaponFormState();
}

const _weaponTypeList = [
  DropdownMenuItem(
    value: WeaponType.gp,
    child: Text("General Purpose"),
  ),
  DropdownMenuItem(
    value: WeaponType.ai,
    child: Text("Anti-Infantry"),
  ),
  DropdownMenuItem(
    value: WeaponType.at,
    child: Text("Anti-Tank"),
  ),
];

class _WeaponFormState extends State<WeaponForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveTraits(String? value) {
    if (value == null || value.isEmpty) {
      widget.weapon.traits = [];
      return;
    }
    var traits = value.split(',');
    widget.weapon.traits = traits.map((e) => e.trim()).toList();
  }

  void deleteWeapon(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final snackText = "Removed ${widget.weapon.name}";

    appState.removeWeapon(widget.weapon.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackText)),
    );
    goBack(context);
  }

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void submitChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save(); // Store current values
    final appState = Provider.of<AppState>(context, listen: false);
    widget.weapon.ensureId();
    appState.setWeapon(widget.weapon);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.snackText} ${widget.weapon.name}")),
    );
    goBack(context);
  }

  void recalculateCost() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save(); // Store current values
    setState(() {/* Cost value has changed */});
  }

  @override
  Widget build(BuildContext context) {
    // var appState = Provider.of<AppState>(context, listen: false);

    return LaserStormScaffold(
      title: widget.title,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(400, double.infinity)),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.abc),
                          labelText: 'Name:',
                          hintText: 'Weapon Name?',
                        ),
                        initialValue: widget.weapon.name,
                        validator: validator.notEmpty,
                        onSaved: (v) => widget.weapon.name = v!,
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.all_out),
                          labelText: "Weapon Type",
                          hintText: "Type of weapon",
                        ),
                        value: widget.weapon.type,
                        items: _weaponTypeList,
                        onChanged: (v) => widget.weapon.type = v!,
                        onSaved: (v) => widget.weapon.type = v!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.social_distance),
                          labelText: "Range:",
                          hintText: "Weapon Range in inches",
                        ),
                        initialValue: widget.weapon.range.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) =>
                            validator.notEmpty(v) ??
                            validator.strictlyPositiveNumber(v),
                        onSaved: (v) => widget.weapon.range = int.parse(v!),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.multiple_stop),
                          labelText: "Shots:",
                          hintText: "Dice per weapon",
                        ),
                        initialValue: widget.weapon.shots.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) =>
                            validator.notEmpty(v) ??
                            validator.strictlyPositiveNumber(v),
                        onSaved: (v) => widget.weapon.shots = int.parse(v!),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.healing),
                          labelText: "Impact:",
                          hintText: "",
                        ),
                        initialValue: widget.weapon.impact.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) =>
                            validator.notEmpty(v) ??
                            validator.positiveNumber(v),
                        onSaved: (v) => widget.weapon.impact = int.parse(v!),
                      ),
                      MultiSelectFormField<String>(
                        title: "Traits:",
                        onSaved: (v) => widget.weapon.traits = v!,
                        validator: (v) => v == null
                            ? "invalid"
                            : null, // TODO: Validate traits
                        items: const ["Aim", "Heavy"], //TODO: Add all traits
                        initialValue: widget.weapon.traits,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Cost: ",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              widget.weapon.cost().toInt().toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              onPressed: recalculateCost,
                              icon: const Icon(Icons.calculate),
                              tooltip: "Recalculate Cost",
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => submitChanges(context),
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
