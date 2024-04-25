import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class TileTitle extends StatelessWidget {
  final String title;
  final String cost;

  const TileTitle({super.key, required this.title, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          width: 10,
        ),
        Text("($cost pts)"),
      ],
    );
  }
}

/// Displays a stat with an icon and tooltip
///
/// The stat, its value and the icon to use must be supplied at creation.
/// The value of the stat must be a string.
class StatDisplay extends StatelessWidget {
  const StatDisplay({
    super.key,
    required this.stat,
    required this.value,
    this.icon,
  });

  final String stat;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Tooltip(
        message: "$stat: $value",
        child: Column(
          children: [
            Text(stat),
            Text(value),
          ],
        ),
      ),
    );
  }
}

class MultiSelectFormField<T> extends FormField<List<T>> {
  MultiSelectFormField({
    super.key,
    required FormFieldSetter<List<T>> onSaved,
    required FormFieldValidator<List<T>> validator,
    String? title,
    List<T> items = const [],
    List<T> initialValue = const [],
    bool autovalidate = false,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.disabled,
          builder: (FormFieldState<List<T>> state) {
            var options = items.map<ValueItem<T>>((T item) {
              return ValueItem(
                label: item.toString(),
                value: item,
              );
            }).toList();
            var selected = initialValue.map<ValueItem<T>>((T item) {
              return ValueItem(
                label: item.toString(),
                value: item,
              );
            }).toList();

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(fontSize: 12),
                    ),
                  MultiSelectDropDown<T>(
                    // inputDecoration: decoration,
                    padding: EdgeInsets.zero,
                    onOptionSelected: (options) {
                      state.didChange(options.map((e) => e.value!).toList());
                    },
                    options: options,
                    selectedOptions: selected,
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
