import 'package:flutter/material.dart';
import 'package:weasel/src/laserstorm/common_widgets.dart';
import 'package:weasel/src/laserstorm/laser_storm_scaffold.dart';
import 'package:weasel/src/laserstorm/template.dart';

class TypeData {
  IconData icon;
  String tooltip;

  TypeData({required this.icon, required this.tooltip});
}

class TemplatePage<T extends Template> extends StatelessWidget {
  final String templateName;
  final void Function() onAdd;
  final void Function(T) onEdit;
  final void Function(T) onDuplicate;
  final void Function(T) onDelete;
  final T Function(int) getItem;
  final List<Widget> Function(T) statBuilder;
  final TypeData Function(T) leadingBuilder;
  final int itemCount;

  const TemplatePage({
    super.key,
    required this.onAdd,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.getItem,
    required this.templateName,
    required this.itemCount,
    required this.leadingBuilder,
    required this.statBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LaserStormScaffold(
      title: "${templateName}s",
      addButton: FloatingActionButton(
        onPressed: onAdd,
        tooltip: "Add $templateName",
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (BuildContext _, int index) {
                final item = getItem(index);
                final leading = leadingBuilder(item);

                return Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size(500, double.infinity)),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      onTap: () => onEdit(item),
                      leading: Tooltip(
                        message: leading.tooltip, // iconTooltip,
                        child: Icon(leading.icon),
                      ),
                      trailing: MenuAnchor(
                        builder: (BuildContext _, MenuController controller,
                            Widget? child) {
                          return IconButton(
                            onPressed: controller.open,
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Show menu',
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.edit),
                            onPressed: () => onEdit(item),
                            child: const Text("Edit"),
                          ),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.copy),
                            onPressed: () => onDuplicate(item),
                            child: const Text("Duplicate"),
                          ),
                          const Divider(),
                          MenuItemButton(
                            leadingIcon: const Icon(Icons.delete),
                            onPressed: () => onDelete(item),
                            child: const Text("Delete"),
                          )
                        ],
                      ),
                      title: TileTitle(
                        title: item.name,
                        cost: item.cost().toInt().toString(),
                      ),
                      subtitle: Visibility(
                        visible: MediaQuery.of(context).size.width > 350,
                        child: Row(
                          children: statBuilder(item),
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
