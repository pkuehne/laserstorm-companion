import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import 'package:weasel/src/laserstorm/stand.dart';
import 'package:weasel/src/laserstorm/unit.dart';
import 'package:weasel/src/app_states.dart';
import 'package:weasel/src/laserstorm/validators.dart' as validator;

/// Holds unit id argument for EditUnitPage
class UnitId {
  final int? id;
  UnitId(this.id);
}

class AddUnitPage extends StatelessWidget {
  const AddUnitPage({super.key});

  static const routeName = '/laserstorm/unit/add';

  @override
  Widget build(BuildContext context) {
    return UnitForm(
      unit: Unit.empty(),
      title: "Add Unit",
      snackText: "Added",
    );
  }
}

class EditUnitPage extends StatelessWidget {
  const EditUnitPage({super.key});

  static const routeName = '/laserstorm/unit/edit';

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    final args = ModalRoute.of(context)?.settings.arguments as UnitId?;
    final id = args?.id;
    if (id == null || !appState.hasUnit(id)) {
      Navigator.of(context).pop();
    }

    return UnitForm(
      unit: Unit.clone(appState.getUnit(id!)),
      title: "Edit Unit",
      snackText: "Updated",
    );
  }
}

class UnitForm extends StatefulWidget {
  final Unit unit;
  final String title;
  final String snackText;

  const UnitForm({
    super.key,
    required this.unit,
    required this.title,
    required this.snackText,
  });

  @override
  State<UnitForm> createState() => _UnitFormState();
}

class _UnitFormState extends State<UnitForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void deleteUnit(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final snackText = "Removed ${widget.unit.name}";

    appState.removeUnit(widget.unit.id);
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
    if (widget.unit.id == 0) {
      widget.unit.id = UniqueKey().hashCode;
    }
    appState.setUnit(widget.unit);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.snackText} ${widget.unit.name}")),
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
    var appState = Provider.of<AppState>(context, listen: false);
    var transportStands = appState.stands
        .where((stand) => stand.transports > 0)
        .map<DropdownMenuItem<int>>((Stand stand) {
      return DropdownMenuItem<int>(
        value: stand.id,
        child: Text(stand.name),
      );
    }).toList();
    // Add null value
    transportStands.insert(
      0,
      const DropdownMenuItem<int>(
        value: null,
        child: Text(
          "<None>",
        ),
      ),
    );

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
                          hintText: 'Unit Name?',
                        ),
                        initialValue: widget.unit.name,
                        validator: validator.notEmpty,
                        onSaved: (v) => widget.unit.name = v!,
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Stand:',
                          hintText: 'Stands?',
                        ),
                        items: appState.stands
                            .map<DropdownMenuItem<int>>((Stand stand) {
                          return DropdownMenuItem<int>(
                            value: stand.id,
                            child: Text(stand.name),
                          );
                        }).toList(),
                        value: widget.unit.stand.id,
                        onSaved: (v) =>
                            widget.unit.stand = appState.getStand(v!),
                        onChanged: (v) =>
                            widget.unit.stand = appState.getStand(v!),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Size:',
                          hintText: 'How many stands in this unit?',
                        ),
                        initialValue: widget.unit.size.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (v) => widget.unit.size = int.parse(v!),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Transports:',
                          hintText: 'How many transports in this unit?',
                        ),
                        initialValue: widget.unit.transportSize.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (v) =>
                            widget.unit.transportSize = int.parse(v!),
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Transports:',
                          hintText: 'What transports?',
                        ),
                        items: transportStands,
                        value: widget.unit.transport?.id,
                        onSaved: (v) => widget.unit.transport =
                            v != null ? appState.getStand(v) : null,
                        onChanged: (v) => widget.unit.transport =
                            v != null ? appState.getStand(v) : null,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: widget.unit.command,
                            onChanged: (v) =>
                                setState(() => widget.unit.command = v!),
                          ),
                          const Text("Command Stand"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: widget.unit.hero,
                            onChanged: (v) =>
                                setState(() => widget.unit.hero = v!),
                          ),
                          const Text("Hero Stand"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Cost: ",
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(widget.unit.cost().toInt().toString(),
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
