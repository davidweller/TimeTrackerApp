import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
import 'edit_time_entry_screen.dart';
import 'project_management_screen.dart';
import 'task_management_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // The DefaultTabController handles the two tabs requested in the tutorial.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Time Entries'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'All Entries'),
              Tab(icon: Icon(Icons.group_work), text: 'By Project'),
            ],
          ),
        ),
        // Side menu for navigating to Project and Task management.
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'Time Tracker Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Manage Projects'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectManagementScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Manage Tasks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskManagementScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllEntriesTab(),
            _buildGroupedEntriesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          tooltip: 'Add Time Entry',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Tab 1: Displays a simple list of all individual time entries.
  Widget _buildAllEntriesTab() {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No entries found.\nTap the + button to add a time entry.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            final projectName = provider.getProjectName(entry.projectId) ?? 'Unknown Project';
            final taskName = provider.getTaskName(entry.taskId) ?? 'Unknown Task';
            final dateFormat = DateFormat('yyyy-MM-dd');
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.access_time)),
                title: Text(
                  '$projectName - $taskName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Time: ${entry.totalTime} hours'),
                    Text('Date: ${dateFormat.format(entry.date)}'),
                    if (entry.notes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          entry.notes,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTimeEntryScreen(entry: entry),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmation(context, provider, entry);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Tab 2: Groups entries by project and calculates total hours.
  Widget _buildGroupedEntriesTab() {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No data to group.\nAdd some time entries to see them grouped by project.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        // Uses the collection package to group entries by projectId.
        final groupedEntries = groupBy(provider.entries, (TimeEntry entry) => entry.projectId);
        
        return ListView(
          children: groupedEntries.entries.map((group) {
            final projectId = group.key;
            final projectName = provider.getProjectName(projectId) ?? 'Unknown Project';
            // Sums the totalTime for all entries in this project group.
            final totalHours = group.value.fold<double>(0, (sum, item) => sum + item.totalTime);
            final entryCount = group.value.length;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.folder)),
                title: Text(
                  projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Total: ${totalHours.toStringAsFixed(2)} hours ($entryCount ${entryCount == 1 ? 'entry' : 'entries'})'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TimeEntryProvider provider,
    TimeEntry entry,
  ) {
    final projectName = provider.getProjectName(entry.projectId) ?? 'Unknown Project';
    final taskName = provider.getTaskName(entry.taskId) ?? 'Unknown Task';
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Time Entry'),
          content: Text(
            'Are you sure you want to delete this time entry?\n\n'
            'Project: $projectName\n'
            'Task: $taskName\n'
            'Time: ${entry.totalTime} hours',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                provider.deleteTimeEntry(entry.id);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Time entry deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}