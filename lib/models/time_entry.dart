class Project {
  final String id;
  final String name;
  Project({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Project.fromJson(Map<String, dynamic> json) => Project(id: json['id'], name: json['name']);
}

class Task {
  final String id;
  final String name;
  Task({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Task.fromJson(Map<String, dynamic> json) => Task(id: json['id'], name: json['name']);
}

class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final double totalTime;
  final DateTime date;
  final String notes;

  TimeEntry({required this.id, required this.projectId, required this.taskId, required this.totalTime, required this.date, required this.notes});

  Map<String, dynamic> toJson() => {
    'id': id, 'projectId': projectId, 'taskId': taskId, 
    'totalTime': totalTime, 'date': date.toIso8601String(), 'notes': notes
  };

  factory TimeEntry.fromJson(Map<String, dynamic> json) => TimeEntry(
    id: json['id'], projectId: json['projectId'], taskId: json['taskId'],
    totalTime: json['totalTime'], date: DateTime.parse(json['date']), notes: json['notes']
  );
}