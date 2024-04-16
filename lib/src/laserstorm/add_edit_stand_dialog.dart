import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../app_states.dart';
import 'stand.dart';

class AddEditStandDialog extends StatefulWidget {
  final int? id;
  const AddEditStandDialog({
    this.id,
    super.key,
  });

  @override
  State<AddEditStandDialog> createState() => _AddEditStandDialogState();
}

final _standTypeList = [
  for (var type in StandType.values)
    DropdownMenuItem(
      value: type,
      child: Text(type.toString()),
    ),
];

final _movementTypeList = [
  for (var type in MovementType.values)
    DropdownMenuItem(
      value: type,
      child: Text(type.toString()),
    ),
];

final _booleanTypeList = [
  const DropdownMenuItem(value: true, child: Text("Yes")),
  const DropdownMenuItem(value: false, child: Text("No")),
];

class _AddEditStandDialogState extends State<AddEditStandDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Stand stand = Stand.empty();

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name!';
    }
    return null;
  }

  void saveName(String? value) {
    stand.name = value!;
  }

  void saveType(StandType? value) {
    stand.type = value!;
  }

  String? movementValidator(MovementType? value) {
    if (value == null) {
      return 'A movement type must be selected!';
    }
    if (stand.type == StandType.infantry && value != MovementType.wheel) {
      return "Infantry can only be Wheeled";
    }
    return null;
  }

  void saveMovement(MovementType? value) {
    stand.movement = value!;
  }

  String? minimumMoveValidator(bool? value) {
    if (value == null) {
      return 'A minimum move value must be selected';
    }
    if (stand.movement != MovementType.grav && value == true) {
      return "Only grav vehicles can have a minimum move distance";
    }
    return null;
  }

  void saveMinimumMove(bool? value) {
    stand.hasMinimumMove = value!;
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

  void saveAim(String? value) {
    stand.aim = int.parse(value!);
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

  void saveSpeed(String? value) {
    stand.speed = int.parse(value!);
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
    stand.save = int.parse(value!);
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
      stand.traits = [];
      return;
    }
    var traits = value.split(',');
    stand.traits = traits.map((e) => e.trim()).toList();
  }

  void deleteStand(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final snackText = "Removed ${stand.name}";

    appState.removeStand(stand.id);
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
    if (stand.id == 0) {
      stand.id = UniqueKey().hashCode;
      snackText = "Added new stand ${stand.name}";
    } else {
      snackText = "Updated stand ${stand.name}";
    }
    appState.setStand(stand);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    if (widget.id != null && appState.hasStand(widget.id!)) {
      // Load the stand
      stand = appState.getStand(widget.id!);
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
                    labelText: 'Name:',
                    hintText: 'Stand Name?',
                  ),
                  initialValue: stand.name,
                  validator: nameValidator,
                  onSaved: saveName,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Stand Type",
                    hintText: "Type of stand",
                  ),
                  value: stand.type,
                  items: _standTypeList,
                  onChanged: saveType,
                  onSaved: saveType,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Capacity:',
                    hintText: 'Transport capacity?',
                  ),
                  initialValue: stand.transports.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onSaved: (v) => stand.transports = int.parse(v!),
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Movement Type",
                    hintText: "Type of movement",
                  ),
                  value: stand.movement,
                  items: _movementTypeList,
                  onChanged: saveMovement,
                  onSaved: saveMovement,
                  validator: movementValidator,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Minimum Move",
                    hintText: "Vehicle has minimum move distance",
                  ),
                  value: stand.hasMinimumMove,
                  items: _booleanTypeList,
                  onChanged: saveMinimumMove,
                  onSaved: saveMinimumMove,
                  validator: minimumMoveValidator,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.social_distance),
                    labelText: "Aim:",
                    hintText: "Aim Range in inches",
                  ),
                  initialValue: stand.aim.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: rangeValidator,
                  onSaved: saveAim,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.multiple_stop),
                    labelText: "Speed:",
                    hintText: "How fast this stand moves",
                  ),
                  initialValue: stand.speed.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: shotsValidator,
                  onSaved: saveSpeed,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.healing),
                    labelText: "Save:",
                    hintText: "Base Save number",
                  ),
                  initialValue: stand.save.toString(),
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: shotsValidator,
                  onSaved: saveSave,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: 'Traits:',
                    hintText: 'Aim, Heavy',
                  ),
                  initialValue: stand.traits.join(", "),
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
                      Text(stand.cost().toInt().toString(),
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
                visible: stand.id != 0,
                child: IconButton(
                  onPressed: () => deleteStand(context),
                  icon: const Icon(Icons.delete),
                  tooltip: "Delete this stand",
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
