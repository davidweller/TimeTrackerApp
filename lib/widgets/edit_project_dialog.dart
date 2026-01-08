import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';

class EditProjectDialog extends StatefulWidget {
  final String projectId;
  final String currentName;

  const EditProjectDialog({
    Key? key,
    required this.projectId,
    required this.currentName,
  }) : super(key: key);

  @override
  _EditProjectDialogState createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<EditProjectDialog> {
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
      title: const Text('Edit Project'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Project Name"),
        autofocus: true,
        onSubmitted: (_) {
          if (_controller.text.trim().isNotEmpty) {
            Provider.of<TimeEntryProvider>(context, listen: false)
                .updateProject(widget.projectId, _controller.text.trim());
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
                  .updateProject(widget.projectId, _controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

