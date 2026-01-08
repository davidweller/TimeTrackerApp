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

    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10),
              
              // Project Dropdown
              DropdownButtonFormField<String>(
                value: projectId,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: provider.projects.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name),
                )).toList(),
                onChanged: (val) => setState(() => projectId = val),
                validator: (value) => value == null ? 'Select a project' : null,
              ),

              const SizedBox(height: 16),

              // Task Dropdown
              DropdownButtonFormField<String>(
                value: taskId,
                decoration: const InputDecoration(
                  labelText: 'Task',
                  border: OutlineInputBorder(),
                ),
                items: provider.tasks.map((t) => DropdownMenuItem(
                  value: t.id,
                  child: Text(t.name),
                )).toList(),
                onChanged: (val) => setState(() => taskId = val),
                validator: (value) => value == null ? 'Select a task' : null,
              ),

              const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('yyyy-MM-dd').format(date)),
                ),
              ),

              const SizedBox(height: 16),

              // Total Time Field
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Total Time (hours)',
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
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
                child: const Text('Save Entry'),
              )
            ],
          ),
        ),
      ),
    );
  }
}