import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'weapon.dart';

class AddEditWeaponDialog extends StatefulWidget {
  final int? id;
  const AddEditWeaponDialog({
    this.id,
    super.key,
  });

  @override
  State<AddEditWeaponDialog> createState() => _AddEditWeaponDialogState();
}

class _AddEditWeaponDialogState extends State<AddEditWeaponDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Weapon weapon = Weapon.empty();

  final _weaponTypeList = const [
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

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name!';
    }
    return null;
  }

  void saveName(String? value) {
    weapon.name = value!;
  }

  void saveType(WeaponType? value) {
    weapon.type = value!;
  }

  String? rangeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a range!';
    }
    int numValue = int.parse(value);
    if (numValue < 1) {
      return "Range must be a positive number";
    }
    return null;
  }

  void saveRange(String? value) {
    weapon.range = int.parse(value!);
  }

  String? shotsValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter number of shots!';
    }
    int numValue = int.parse(value);
    if (numValue < 1) {
      return "Shots must be a positive number";
    }
    return null;
  }

  void saveShots(String? value) {
    weapon.shots = int.parse(value!);
  }

  String? saveValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a negative number';
    }
    int numValue = int.parse(value);
    if (numValue > 0) {
      return "Number must be negative";
    }
    return null;
  }

  void saveSave(String? value) {
    weapon.save = int.parse(value!);
  }

  String? traitValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    List<String> traits = value.split(',');
    List<String> traitList = [
      "Aim",
      "Burst",
      "Flame",
      "Frag",
      "Heavy",
      "Indirect",
      "Rapid",
      "Repeating",
    ];
    for (final trait in traits) {
      if (!traitList.any((String value) => value.contains(trait.trim()))) {
        return "$trait is not a valid trait";
      }
    }
    return null;
  }

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
                  validator: nameValidator,
                  onSaved: saveName,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.all_out),
                    labelText: "Weapon Type",
                    hintText: "Type of weapon",
                  ),
                  value: weapon.type,
                  items: _weaponTypeList,
                  onChanged: saveType,
                  onSaved: saveType,
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
                  validator: rangeValidator,
                  onSaved: saveRange,
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
                  validator: shotsValidator,
                  onSaved: saveShots,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.healing),
                    labelText: "Save:",
                    hintText: "Negative modifier to target",
                  ),
                  initialValue: weapon.save.toString(),
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
                  ],
                  validator: saveValidator,
                  onSaved: saveSave,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: 'Traits:',
                    hintText: 'Aim, Heavy',
                  ),
                  initialValue: weapon.traits.join(", "),
                  validator: traitValidator,
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
