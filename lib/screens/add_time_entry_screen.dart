import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();
  String? projectId;
  String? taskId;
  DateTime date = DateTime.now();

  @override
  void dispose() {
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeEntryProvider>(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10),
              
              // Project Selection - List
              const Text(
                'Project',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (projectId != null)
                Text(
                  provider.getProjectName(projectId!) ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 8),
              ...provider.projects.map((project) {
                return ListTile(
                  title: Text(project.name),
                  onTap: () {
                    setState(() {
                      projectId = project.id;
                      taskId = null; // Reset task when project changes
                    });
                  },
                  selected: projectId == project.id,
                  selectedTileColor: Colors.grey[200],
                );
              }).toList(),

              const Divider(),
              const SizedBox(height: 16),

              // Task Selection - Radio Buttons
              if (projectId != null) ...[
                const Text(
                  'Task',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ...provider.tasks.map((task) {
                  return RadioListTile<String>(
                    title: Text(task.name),
                    value: task.id,
                    groupValue: taskId,
                    onChanged: (value) {
                      setState(() {
                        taskId = value;
                      });
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],

              // Date Picker
              const Text(
                'Date:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(dateFormat.format(date)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date'),
              ),

              const SizedBox(height: 16),

              // Total Time Field
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Total Time (in hours)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter time';
                  final parsed = double.tryParse(value);
                  if (parsed == null) return 'Enter a valid number';
                  if (parsed <= 0) return 'Time must be greater than 0';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (projectId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a project')),
                      );
                      return;
                    }
                    if (taskId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a task')),
                      );
                      return;
                    }
                    final totalTime = double.parse(_timeController.text);
                    provider.addTimeEntry(TimeEntry(
                      id: _uuid.v4(),
                      projectId: projectId!,
                      taskId: taskId!,
                      totalTime: totalTime,
                      date: date,
                      notes: _notesController.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Time Entry'),
              )
            ],
          ),
        ),
      ),
    );
  }
}