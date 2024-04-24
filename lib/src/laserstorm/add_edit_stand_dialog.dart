import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import '../app_states.dart';
import 'stand.dart';

/// Holds stand id argument for EditUnitPage
class StandId {
  final int? id;
  StandId(this.id);
}

class AddStandPage extends StatelessWidget {
  const AddStandPage({super.key});

  static const routeName = '/laserstorm/stand/add';

  @override
  Widget build(BuildContext context) {
    return StandForm(
      stand: Stand.empty(),
      title: "Add Unit",
      snackText: "Added",
    );
  }
}

class EditStandPage extends StatelessWidget {
  const EditStandPage({super.key});

  static const routeName = '/laserstorm/stand/edit';

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    final args = ModalRoute.of(context)?.settings.arguments as StandId?;
    final id = args?.id;
    if (id == null || !appState.hasUnit(id)) {
      Navigator.of(context).pop();
    }

    return StandForm(
      stand: Stand.clone(appState.getStand(id!)),
      title: "Edit Unit",
      snackText: "Updated",
    );
  }
}

class StandForm extends StatefulWidget {
  final Stand stand;
  final String title;
  final String snackText;

  const StandForm({
    super.key,
    required this.stand,
    required this.title,
    required this.snackText,
  });

  @override
  State<StandForm> createState() => _StandFormState();
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

class _StandFormState extends State<StandForm> {
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

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void submitChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save(); // Store current values
    final appState = Provider.of<AppState>(context, listen: false);
    widget.stand.ensureId();
    appState.setStand(widget.stand);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.snackText} ${widget.stand.name}")),
    );
    goBack(context);
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
    // var appState = Provider.of<AppState>(context, listen: false);
    // var weaponList = appState.weapons.map<DropdownMenuItem<int>>((Weapon w) {
    //   return DropdownMenuItem<int>(
    //     value: w.id,
    //     child: Text(w.name),
    //   );
    // }).toList();

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
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
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
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
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
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Save:",
                                hintText: "Base Save number",
                              ),
                              initialValue: stand.save.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: shotsValidator,
                              onSaved: saveSave,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
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
