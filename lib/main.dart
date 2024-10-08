import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskNameController = TextEditingController();
  String _selectedPriority = 'Low';
  List<Task> _tasks = [];

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  void _addTask() {
    String taskName = _taskNameController.text.trim();
    if (taskName.isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: taskName, priority: _selectedPriority));
        _taskNameController.clear();
        _selectedPriority = 'Low';
      });
    }
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 1;
      case 'Medium':
        return 2;
      case 'Low':
        return 3;
      default:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort tasks based on priority
    _tasks.sort((a, b) =>
        _getPriorityValue(a.priority).compareTo(_getPriorityValue(b.priority)));

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field and Add button
            Row(
              children: [
                // Task Name Input
                Expanded(
                  child: TextField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Priority Selector
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: _priorities.map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                SizedBox(width: 10),
                // Add Button
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Task List
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text('No tasks added yet.'))
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        _toggleTaskCompletion(task);
                      },
                    ),
                    title: Text(
                      task.name,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text('Priority: ${task.priority}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTask(task),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
