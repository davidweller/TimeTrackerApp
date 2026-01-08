import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';

class AddTaskDialog extends StatefulWidget {
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Task Name"),
        autofocus: true,
        onSubmitted: (_) {
          if (_controller.text.isNotEmpty) {
            Provider.of<TimeEntryProvider>(context, listen: false)
                .addTask(_controller.text);
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
                  .addTask(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}