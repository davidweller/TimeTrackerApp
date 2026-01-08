import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final Uuid _uuid = const Uuid();
  List<Project> _projects = [];
  List<Task> _tasks = [];
  List<TimeEntry> _entries = [];
  bool _initialized = false;

  static const String _storagePrefix = 'time_tracker_';

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  List<TimeEntry> get entries => _entries;

  TimeEntryProvider() {
    _init();
  }

  Future<void> _init() async {
    if (!_initialized) {
      await _loadFromStorage();
      _initialized = true;
    }
  }

  void _saveToStorage() {
    localStorage.setItem('${_storagePrefix}projects', jsonEncode(_projects.map((e) => e.toJson()).toList()));
    localStorage.setItem('${_storagePrefix}tasks', jsonEncode(_tasks.map((e) => e.toJson()).toList()));
    localStorage.setItem('${_storagePrefix}entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  Future<void> _loadFromStorage() async {
    String? storedProjects = localStorage.getItem('${_storagePrefix}projects');
    String? storedTasks = localStorage.getItem('${_storagePrefix}tasks');
    String? storedEntries = localStorage.getItem('${_storagePrefix}entries');

    if (storedProjects != null) {
      List<dynamic> projectsData = jsonDecode(storedProjects);
      _projects = projectsData.map((x) => Project.fromJson(x)).toList();
    }

    if (storedTasks != null) {
      List<dynamic> tasksData = jsonDecode(storedTasks);
      _tasks = tasksData.map((x) => Task.fromJson(x)).toList();
    }

    if (storedEntries != null) {
      List<dynamic> entriesData = jsonDecode(storedEntries);
      _entries = entriesData.map((x) => TimeEntry.fromJson(x)).toList();
    }

    notifyListeners();
  }

  void addProject(String name) {
    _projects.add(Project(id: _uuid.v4(), name: name));
    _saveToStorage();
    notifyListeners();
  }

  void addTask(String name) {
    _tasks.add(Task(id: _uuid.v4(), name: name));
    _saveToStorage();
    notifyListeners();
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveToStorage();
    notifyListeners();
  }

  void updateProject(String id, String name) {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index != -1) {
      _projects[index] = Project(id: id, name: name);
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateTask(String id, String name) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = Task(id: id, name: name);
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateTimeEntry(TimeEntry entry) {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    // Also delete all time entries associated with this project
    _entries.removeWhere((e) => e.projectId == id);
    _saveToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    // Also delete all time entries associated with this task
    _entries.removeWhere((e) => e.taskId == id);
    _saveToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    _saveToStorage();
    notifyListeners();
  }

  String? getProjectName(String projectId) {
    try {
      return _projects.firstWhere((p) => p.id == projectId).name;
    } catch (e) {
      return null;
    }
  }

  String? getTaskName(String taskId) {
    try {
      return _tasks.firstWhere((t) => t.id == taskId).name;
    } catch (e) {
      return null;
    }
  }
}