# Time Tracker App

A Flutter web application for tracking time spent on projects and tasks.

## Features

- **Project Management**: Create, edit, and delete projects
- **Task Management**: Create, edit, and delete tasks
- **Time Entry Tracking**: Log time spent on projects and tasks with notes
- **Data Visualization**: View all entries or group by project
- **Persistent Storage**: Data is saved in browser local storage
- **Full CRUD Operations**: Complete create, read, update, and delete functionality

## Screenshots

The app features a clean Material Design interface with:
- Home screen with tabs for "All Entries" and "By Project"
- Drawer navigation for managing projects and tasks
- Floating action button for quick entry creation
- Edit and delete actions for all entities

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Chrome browser (for web development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/TimeTrackerApp.git
cd TimeTrackerApp
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run -d chrome
```

The app will open in your default Chrome browser at `http://localhost:3000` (or another available port).

## Usage

1. **Add Projects**: Open the drawer menu (☰) → "Manage Projects" → Tap the + button
2. **Add Tasks**: Open the drawer menu (☰) → "Manage Tasks" → Tap the + button
3. **Add Time Entries**: Tap the floating action button (+) on the home screen
4. **View Entries**: Switch between "All Entries" and "By Project" tabs
5. **Edit/Delete**: Use the edit and delete icons on any project, task, or entry

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── time_entry.dart      # Data models (Project, Task, TimeEntry)
├── providers/
│   └── time_entry_provider.dart  # State management with LocalStorage
├── screens/
│   ├── home_screen.dart           # Main screen with tabs
│   ├── add_time_entry_screen.dart # Add new time entries
│   ├── edit_time_entry_screen.dart # Edit existing entries
│   ├── project_management_screen.dart
│   └── task_management_screen.dart
└── widgets/
    ├── add_project_dialog.dart
    ├── add_task_dialog.dart
    ├── edit_project_dialog.dart
    └── edit_task_dialog.dart
```

## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **LocalStorage**: Browser-based persistent storage
- **UUID**: Unique ID generation
- **Material Design 3**: Modern UI components

## Data Storage

The app uses browser LocalStorage to persist data. All data is stored locally in your browser and persists between sessions.

## License

This project is open source and available for personal and commercial use.

## Contributing

Contributions, issues, and feature requests are welcome!

