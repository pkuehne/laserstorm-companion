import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/common_widgets.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import 'package:weasel/src/app_states.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/validators.dart' as validator;
import 'package:weasel/src/laserstorm/weapon.dart';

/// Holds stand id argument for EditStandPage
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
      title: "Add Stand",
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
    if (id == null || !appState.hasStand(id)) {
      Navigator.of(context).pop();
    }

    return StandForm(
      stand: Stand.clone(appState.getStand(id!)),
      title: "Edit Stand",
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

  String? movementValidator(MovementType? value) {
    if (value == null) {
      return 'A movement type must be selected!';
    }
    if (widget.stand.type == StandType.infantry &&
        value != MovementType.wheel) {
      return "Infantry can only be Wheeled";
    }
    return null;
  }

  String? minimumMoveValidator(bool? value) {
    if (value == null) {
      return 'A minimum move value must be selected';
    }
    if (widget.stand.movement != MovementType.grav && value == true) {
      return "Only grav vehicles can have a minimum move distance";
    }
    return null;
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
      widget.stand.traits = [];
      return;
    }
    var traits = value.split(',');
    widget.stand.traits = traits.map((e) => e.trim()).toList();
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                        initialValue: widget.stand.name,
                        validator: (v) => validator.notEmpty(v),
                        onSaved: (v) => widget.stand.name = v!,
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: "Stand Type",
                          hintText: "Type of stand",
                        ),
                        value: widget.stand.type,
                        items: _standTypeList,
                        onChanged: (v) => widget.stand.type = v!,
                        onSaved: (v) => widget.stand.type = v!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Capacity:',
                          hintText: 'Transport capacity?',
                        ),
                        initialValue: widget.stand.transports.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (v) => widget.stand.transports = int.parse(v!),
                        validator: (v) =>
                            validator.notEmpty(v) ??
                            validator.positiveNumber(v),
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: "Movement Type",
                          hintText: "Type of movement",
                        ),
                        value: widget.stand.movement,
                        items: _movementTypeList,
                        onChanged: (v) => widget.stand.movement = v!,
                        onSaved: (v) => widget.stand.movement = v!,
                        validator: movementValidator,
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: "Minimum Move",
                          hintText: "Vehicle has minimum move distance",
                        ),
                        value: widget.stand.hasMinimumMove,
                        items: _booleanTypeList,
                        onChanged: (v) => widget.stand.hasMinimumMove = v!,
                        onSaved: (v) => widget.stand.hasMinimumMove = v!,
                        validator: minimumMoveValidator,
                      ),
                      MultiSelectFormField<Weapon>(
                        title: "Primary Weapons",
                        onSaved: (v) => widget.stand.primaries = v!,
                        validator: (v) => v == null ? "invalid" : null,
                        items: appState.weapons,
                        initialValue: widget.stand.primaries,
                      ),
                      MultiSelectFormField<Weapon>(
                        title: "Selectable Weapons",
                        onSaved: (v) => widget.stand.selectables = v!,
                        validator: (v) => v == null ? "invalid" : null,
                        items: appState.weapons,
                        initialValue: widget.stand.selectables,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Aim:",
                                hintText: "Aim Range in inches",
                              ),
                              initialValue: widget.stand.aim.toString(),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: validator.strictlyPositiveNumber,
                              onSaved: (v) => widget.stand.aim = int.parse(v!),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Speed:",
                                hintText: "How fast this stand moves",
                              ),
                              initialValue: widget.stand.speed.toString(),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: validator.strictlyPositiveNumber,
                              onSaved: (v) =>
                                  widget.stand.speed = int.parse(v!),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Save:",
                                hintText: "Base Save number",
                              ),
                              initialValue: widget.stand.save.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: validator.strictlyPositiveNumber,
                              onSaved: (v) => widget.stand.save = int.parse(v!),
                            ),
                          ),
                        ],
                      ),
                      MultiSelectFormField<String>(
                        title: "Traits:",
                        onSaved: (v) => widget.stand.traits = v!,
                        validator: (v) => v == null ? "invalid" : null,
                        items: const [
                          "Active Defenses",
                          "Aggression Loop",
                          "Assault Vehicle",
                          "Battlecry",
                          "Battletide",
                          "Bot-Net",
                          "Charge",
                          "Dogfighter",
                          "Ferocious",
                          "Frenzy",
                          "Glory",
                          "Guard",
                          "Horde",
                          "Hover",
                          "In the Walls",
                          "Infiltrate",
                          "Inspiration",
                          "Infest",
                          "Jump Troops",
                          "Melee Weapons",
                          "Minimum Speed",
                          "Move Out",
                          "Overclocked",
                          "Precise Fire",
                          "Relic Bearer",
                          "Spawn",
                          "Stealth",
                          "Stubborn",
                          "Tactical Deployment",
                          "Tank Hunter",
                          "Terror +2",
                          "Third Fate",
                          "Vow-Sworn",
                          "VTOL"
                        ],
                        initialValue: widget.stand.traits,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        // TODO: Make cost calculation a form field
                        // Then add custom validator for the additional logic
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Cost: ",
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(widget.stand.cost().toInt().toString(),
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
