import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weasel/src/laserstorm/add_edit_taskforce_page.dart';
import 'package:weasel/src/laserstorm/common_widgets.dart';
import 'package:weasel/src/laserstorm/taskforce.dart';
import 'package:weasel/src/laserstorm/template_page.dart';
import 'package:weasel/src/app_states.dart';

class TaskForcesPage extends StatelessWidget {
  const TaskForcesPage({super.key});

  static const String routeName = "/laserstorm/taskforces/";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return TemplatePage<TaskForce>(
      templateName: "Task Force",
      onAdd: () => Navigator.pushNamed(
        context,
        AddTaskForcePage.routeName,
        arguments: null,
      ),
      onEdit: (tf) => Navigator.pushNamed(
        context,
        EditTaskForcePage.routeName,
        arguments: TaskForceId(tf.id),
      ),
      onDuplicate: (tf) => appState.duplicateTaskForce(tf),
      onDelete: (tf) => appState.removeTaskForce(tf),
      getItem: (i) => appState.taskforces[i],
      itemCount: appState.taskforces.length,
      leadingBuilder: (TaskForce tf) {
        return TypeData(
          tooltip: tf.option, // iconTooltip,
          icon: switch (tf.option) {
            "infantry" => Icons.person,
            _ => Icons.car_crash,
          },
        );
      },
      statBuilder: (TaskForce tf) => [
        StatDisplay(
          stat: "Infantry",
          value: "${tf.infantry.length}",
        ),
      ],
    );
  }
}
