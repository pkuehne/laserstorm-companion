import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'weapon.dart';
import 'validators.dart' as validator;

class AddEditWeaponDialog extends StatefulWidget {
  final int? id;
  const AddEditWeaponDialog({
    this.id,
    super.key,
  });

  @override
  State<AddEditWeaponDialog> createState() => _AddEditWeaponDialogState();
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

class _AddEditWeaponDialogState extends State<AddEditWeaponDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// The [Weapon] being added/edited
  Weapon weapon = Weapon.empty();

  void saveTraits(String? value) {
    if (value == null || value.isEmpty) {
      weapon.traits = [];
      return;
    }
    var traits = value.split(',');
    weapon.traits = traits.map((e) => e.trim()).toList();
  }

  void deleteWeapon(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final snackText = "Removed ${weapon.name}";

    appState.removeWeapon(weapon.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackText)),
    );
    closeDialog(context);
  }

  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  void submitDialog(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save(); // Store current values
    final appState = Provider.of<AppState>(context, listen: false);
    String snackText = "";
    if (weapon.id == 0) {
      weapon.id = UniqueKey().hashCode;
      snackText = "Added new weapon ${weapon.name}";
    } else {
      snackText = "Updated weapon ${weapon.name}";
    }
    appState.setWeapon(weapon);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackText)),
    );
    closeDialog(context);
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
    var appState = Provider.of<AppState>(context, listen: false);
    if (widget.id != null && appState.hasWeapon(widget.id!)) {
      // Load the weapon
      weapon = appState.getWeapon(widget.id!);
    }

    return SingleChildScrollView(
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
                  initialValue: weapon.name,
                  validator: validator.notEmpty,
                  onSaved: (v) => weapon.name = v!,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.all_out),
                    labelText: "Weapon Type",
                    hintText: "Type of weapon",
                  ),
                  value: weapon.type,
                  items: _weaponTypeList,
                  onChanged: (v) => weapon.type = v!,
                  onSaved: (v) => weapon.type = v!,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.social_distance),
                    labelText: "Range:",
                    hintText: "Weapon Range in inches",
                  ),
                  initialValue: weapon.range.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) =>
                      validator.notEmpty(v) ??
                      validator.strictlyPositiveNumber(v),
                  onSaved: (v) => weapon.range = int.parse(v!),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.multiple_stop),
                    labelText: "Shots:",
                    hintText: "Dice per weapon",
                  ),
                  initialValue: weapon.shots.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) =>
                      validator.notEmpty(v) ??
                      validator.strictlyPositiveNumber(v),
                  onSaved: (v) => weapon.shots = int.parse(v!),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.healing),
                    labelText: "Impact:",
                    hintText: "",
                  ),
                  initialValue: weapon.impact.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) =>
                      validator.notEmpty(v) ?? validator.positiveNumber(v),
                  onSaved: (v) => weapon.impact = int.parse(v!),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: 'Traits:',
                    hintText: 'Aim, Heavy',
                  ),
                  initialValue: weapon.traits.join(", "),
                  validator: validator.traits,
                  onSaved: saveTraits,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Cost: ",
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(weapon.cost().toInt().toString(),
                          style: Theme.of(context).textTheme.titleLarge),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: weapon.id != 0,
                child: IconButton(
                  onPressed: () => deleteWeapon(context),
                  icon: const Icon(Icons.delete),
                  tooltip: "Delete this weapon",
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => closeDialog(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => submitDialog(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
