import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';

class EditTaskDialog extends StatefulWidget {
  final String taskId;
  final String currentName;

  const EditTaskDialog({
    Key? key,
    required this.taskId,
    required this.currentName,
  }) : super(key: key);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Task Name"),
        autofocus: true,
        onSubmitted: (_) {
          if (_controller.text.trim().isNotEmpty) {
            Provider.of<TimeEntryProvider>(context, listen: false)
                .updateTask(widget.taskId, _controller.text.trim());
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              Provider.of<TimeEntryProvider>(context, listen: false)
                  .updateTask(widget.taskId, _controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

