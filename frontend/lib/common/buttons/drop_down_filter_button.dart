import 'package:flutter/material.dart';


class DropDownFilterButton extends StatelessWidget {
  final String? title;
  final List<String> options;
  final String selected;
  final void Function(String) onSelected;
  final bool hasError;

  const DropDownFilterButton({
    Key? key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.title,
    this.hasError = false,
  }) : super(key: key);

  static BorderRadius borderRadius = BorderRadius.circular(10.0);

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(
        maxWidth: 250, minWidth: 100,
    ),
    child: InkWell(
      onTap: () async {
        final RenderBox button = context.findRenderObject()! as RenderBox;
        final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
        const Offset offset = Offset(0, 30); // offset = Offset(button.size.width, 0);
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(offset, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(offset) + Offset.zero, ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );
  
        String? selectedValue = await showMenu(
          context: context,
          position: position,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          items: options.map((e) => PopupMenuItem(
            value: e,
            child: Text(e),
          )).toList(),
        );
        if (selectedValue != null) {
          onSelected(selectedValue);
        }
      },
      borderRadius: borderRadius,
      child: Container(
        height: 34.0,
        decoration: BoxDecoration(
          border: Border.all(color: hasError ? Colors.red : Colors.grey),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 8.0),
            if (title != null) Flexible(
              child: Text('$title: ', 
                style: const TextStyle(color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(child: Text(selected, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    ),
  );
}