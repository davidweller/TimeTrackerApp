import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import 'add_time_entry_screen.dart';
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
          title: const Text('Time Tracking'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    onSurface: Colors.white,
                    onPrimary: Colors.white,
                  ),
                  tabBarTheme: const TabBarThemeData(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: Colors.yellow,
                    labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                    unselectedLabelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                child: TabBar(
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.list, color: Colors.white),
                      text: 'All Entries',
                    ),
                    Tab(
                      icon: Icon(Icons.group_work, color: Colors.white),
                      text: 'Grouped by Projects',
                    ),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.yellow,
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  unselectedLabelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
            ),
          ),
        ),
        // Side menu for navigating to Project and Task management.
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF008080)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Time Tracking',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Projects'),
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
                title: const Text('Tasks'),
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No time entries yet!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first entry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
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
            final dateFormat = DateFormat('MMM dd, yyyy');
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(
                  '$projectName - $taskName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008080),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Time: ${entry.totalTime} hours'),
                    Text('Date: ${dateFormat.format(entry.date)}'),
                    if (entry.notes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Note: ${entry.notes}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context, provider, entry);
                  },
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No time entries yet!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first entry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Uses the collection package to group entries by projectId.
        final groupedEntries = groupBy(provider.entries, (TimeEntry entry) => entry.projectId);
        final dateFormat = DateFormat('MMM dd, yyyy');
        
        return ListView(
          children: groupedEntries.entries.map((group) {
            final projectId = group.key;
            final projectName = provider.getProjectName(projectId) ?? 'Unknown Project';
            final entries = group.value;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF008080),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...entries.map((entry) {
                      final taskName = provider.getTaskName(entry.taskId) ?? 'Unknown Task';
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text(
                          '- $taskName: ${entry.totalTime} hours (${dateFormat.format(entry.date)})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ],
                ),
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