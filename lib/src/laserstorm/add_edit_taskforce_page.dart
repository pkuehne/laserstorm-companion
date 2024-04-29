import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import 'package:weasel/src/laserstorm/taskforce.dart';
import 'package:weasel/src/app_states.dart';
import 'package:weasel/src/laserstorm/validators.dart' as validator;

/// Holds unit id argument for EditTaskForcePage
class TaskForceId {
  final int? id;
  TaskForceId(this.id);
}

class AddTaskForcePage extends StatelessWidget {
  const AddTaskForcePage({super.key});

  static const routeName = '/laserstorm/taskforce/add';

  @override
  Widget build(BuildContext context) {
    return TaskForceForm(
      taskforce: TaskForce(),
      title: "Add Task Force",
      snackText: "Added",
    );
  }
}

class EditTaskForcePage extends StatelessWidget {
  const EditTaskForcePage({super.key});

  static const routeName = '/laserstorm/taskforce/edit';

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    final args = ModalRoute.of(context)?.settings.arguments as TaskForceId?;
    final id = args?.id;
    if (id == null) {
      Navigator.of(context).pop();
    }

    return TaskForceForm(
      taskforce: TaskForce.clone(appState.getTaskForce(id!)),
      title: "Edit Task Force",
      snackText: "Updated",
    );
  }
}

class TaskForceForm extends StatefulWidget {
  final TaskForce taskforce;
  final String title;
  final String snackText;

  const TaskForceForm({
    super.key,
    required this.taskforce,
    required this.title,
    required this.snackText,
  });

  @override
  State<TaskForceForm> createState() => _TaskForceFormState();
}

class _TaskForceFormState extends State<TaskForceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void submitChanges(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save(); // Store current values
    final appState = Provider.of<AppState>(context, listen: false);
    widget.taskforce.ensureId();
    appState.setTaskForce(widget.taskforce);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.snackText} ${widget.taskforce.name}")),
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
    // var units = appState.units.map<DropdownMenuItem<int>>((Unit unit) {
    //   return DropdownMenuItem<int>(
    //     value: unit.id,
    //     child: Text(unit.name),
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
                          hintText: 'Task Force Name?',
                        ),
                        initialValue: widget.taskforce.name,
                        validator: validator.notEmpty,
                        onSaved: (v) => widget.taskforce.name = v!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Commander:',
                          hintText: 'TaskForce Commander?',
                        ),
                        initialValue: widget.taskforce.commander,
                        validator: validator.notEmpty,
                        onSaved: (v) => widget.taskforce.commander = v!,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Cost: ",
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(widget.taskforce.cost().toInt().toString(),
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
